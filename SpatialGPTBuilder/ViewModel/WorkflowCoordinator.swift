//
//  WorkflowCoordinator.swift
//  SpatialGPTBuilder
//
//  Created by Steinhauer, Jan on 01.11.25.
//

import SwiftUI
import Combine

@MainActor
final class WorkflowCoordinator: ObservableObject {

    @Published var selections: [Category: OptionItem] = [:]
    @Published var pickingCategory: Category? = nil
    @Published var pendingSelection: OptionItem? = nil

    @Published var pendingHandshake: HandshakeRequest? = nil
    @Published var successMessage: String? = nil

    @Published private(set) var confirmedColumns: Set<Column> = []

    // MARK: Picking API
    func beginPicking(_ category: Category) {
        pickingCategory = category
        pendingSelection = selections[category]
    }

    func confirmSelection() {
        guard let cat = pickingCategory, let opt = pendingSelection else { return }

        // Keep a snapshot to detect "became complete" transitions
        let before = selections

        // Apply the selection
        selections[cat] = opt
        pickingCategory = nil
        pendingSelection = nil

        let col = cat.column
        let wasCompleteBefore = before.hasAllSelected(in: col)
        let isCompleteNow     = selections.hasAllSelected(in: col)

        if !wasCompleteBefore, isCompleteNow, !confirmedColumns.contains(col), pendingHandshake == nil {
            requestHandshake(for: .column(col))
        }
    }

    func cancelPicking() {
        pickingCategory = nil
        pendingSelection = nil
    }

    // MARK: Handshake lifecycle
    func requestHandshake(for scope: HandshakeScope) {
        let items: [OptionItem]
        switch scope {
        case .category(let c):
            items = selections[c].map { [$0] } ?? []
        case .column(let col):
            items = col.categories.compactMap { selections[$0] }
        }
        pendingHandshake = HandshakeRequest(scope: scope, items: items)
    }

    func completeHandshake() {
        guard let request = pendingHandshake else { return }

        if case .column(let col) = request.scope {
            confirmedColumns.insert(col)
        }

        let list = request.items.map(\.displayName).joined(separator: ", ")
        successMessage = list.isEmpty
            ? "Selection successfully confirmed."
            : "Building block(s) confirmed: \(list)"

        pendingHandshake = nil

        Task { @MainActor in
            try? await Task.sleep(nanoseconds: 5_000_000_000)
            successMessage = nil
        }
    }
}
