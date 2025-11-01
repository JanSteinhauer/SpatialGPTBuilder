//
//  BuildingBlockPickerPlaceholderView.swift
//  SpatialGPTBuilder
//
//  Created by Steinhauer, Jan on 01.11.25.
//

import SwiftUI

struct BuildingBlockPickerPlaceholderView: View {
    @EnvironmentObject private var workflow: WorkflowCoordinator

    var body: some View {
        Group {
            if let cat = workflow.pickingCategory {
                PickerContentGrid(
                    title: cat.display,
                    options: OptionsProvider.items(for: cat),
                    selected: Binding(
                        get: { workflow.pendingSelection },
                        set: { workflow.pendingSelection = $0 }
                    ),
                    onConfirm: { workflow.confirmSelection() },
                    onCancel: { workflow.cancelPicking() }
                )
            } else {
                VStack(spacing: 16) {
                    Text("Add a Buildingblock by clicking on one in the AI Integration Workflow.")
                        .font(.headline)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 24)
                    Text("Tip: You can keep this window open while selecting blocks.")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(.background)
            }
        }
        .frame(minWidth: 360, minHeight: 420)
    }
}

