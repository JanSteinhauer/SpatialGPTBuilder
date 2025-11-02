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

    func beginPicking(_ category: Category) {
        pickingCategory = category
        pendingSelection = selections[category]
    }

    func confirmSelection() {
        guard let cat = pickingCategory, let opt = pendingSelection else { return }
        selections[cat] = opt
        pickingCategory = nil
        pendingSelection = nil
    }

    func cancelPicking() {
        pickingCategory = nil
        pendingSelection = nil
    }
}

