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
    @Published private(set) var revision: Int = 0 // <— new

    // MARK: Picking API
    func beginPicking(_ category: Category) {
        let was = (pickingCategory, pendingSelection)
        pickingCategory = category
        pendingSelection = selections[category]
        if was.0 != pickingCategory || was.1 != pendingSelection {
            revision &+= 1
            print("[Workflow] beginPicking(\(category.display)) -> rev \(revision)")
        } else {
            print("[Workflow] beginPicking(\(category.display)) -> no state change")
        }
    }

    func confirmSelection() {
        guard let cat = pickingCategory, let opt = pendingSelection else {
            print("[Workflow] confirmSelection() ignored — no pending selection.")
            return
        }
        let before = selections

        selections[cat] = opt
        pickingCategory = nil
        pendingSelection = nil

        // bump revision whenever we mutate selections
        if before != selections {
            revision &+= 1
            print("[Workflow] confirmSelection \(cat.display) = \(opt.displayName) -> rev \(revision)")
        } else {
            print("[Workflow] confirmSelection made no effective change.")
        }

        let col = cat.column
        let wasCompleteBefore = before.hasAllSelected(in: col)
        let isCompleteNow     = selections.hasAllSelected(in: col)
        print("[Workflow] Column \(col.displayName) completion: \(wasCompleteBefore) -> \(isCompleteNow)")

        if !wasCompleteBefore, isCompleteNow, !confirmedColumns.contains(col), pendingHandshake == nil {
            print("[Workflow] Requesting handshake for \(col.displayName)")
            requestHandshake(for: .column(col))
        }
    }
    
    func cancelPicking() {
        let was = (pickingCategory, pendingSelection)
        pickingCategory = nil
        pendingSelection = nil
        if was.0 != pickingCategory || was.1 != pendingSelection {
            revision &+= 1
            print("[Workflow] cancelPicking -> rev \(revision)")
        } else {
            print("[Workflow] cancelPicking -> no state change")
        }
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
        print("[Workflow] Handshake requested for \(scope) with items: \(items.map{$0.displayName}.joined(separator: ", "))")
    }

    func completeHandshake() {
        guard let request = pendingHandshake else {
            print("[Workflow] completeHandshake ignored — no pending handshake.")
            return
        }

        if case .column(let col) = request.scope {
            confirmedColumns.insert(col)
            print("[Workflow] Handshake completed for \(col.displayName). Confirmed columns: \(confirmedColumns.map{$0.displayName})")
        }

        let list = request.items.map(\.displayName).joined(separator: ", ")
        successMessage = list.isEmpty
            ? "Selection successfully confirmed."
            : "Building block(s) confirmed: \(list)"
        print("[Workflow] successMessage -> \(successMessage ?? "nil")")

        pendingHandshake = nil

        Task { @MainActor in
            try? await Task.sleep(nanoseconds: 5_000_000_000)
            successMessage = nil
            print("[Workflow] successMessage cleared.")
        }
    }
    
    // MARK: Snapshot I/O
    func makeSnapshot() -> WorkflowSnapshot {
        let snap = WorkflowSnapshot(
            selections: selections,
            pickingCategory: pickingCategory,
            pendingSelection: pendingSelection,
            revision: revision
        )
        // Lightweight log (don’t spam options list)
        print("[Workflow] makeSnapshot -> rev \(snap.revision), selections=\(selections.count)")
        return snap
    }

    func apply(snapshot: WorkflowSnapshot) {
        // Only apply if newer
        guard snapshot.revision >= self.revision else {
            print("[Workflow] apply(snapshot rev=\(snapshot.revision)) skipped; local rev=\(self.revision) is newer.")
            return
        }
        self.selections = snapshot.selections
        self.pickingCategory = snapshot.pickingCategory
        self.pendingSelection = snapshot.pendingSelection
        self.revision = snapshot.revision
        print("[Workflow] ⬅︎ Applied snapshot rev \(snapshot.revision). selections=\(selections.count)")
    }
}
