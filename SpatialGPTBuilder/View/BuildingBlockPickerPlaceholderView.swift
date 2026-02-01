//
//  BuildingBlockPickerPlaceholderView.swift
//  SpatialGPTBuilder
//
//  Created by Steinhauer, Jan on 01.11.25.
//

import SwiftUI

struct BuildingBlockPickerPlaceholderView: View {
    @EnvironmentObject private var workflow: WorkflowCoordinator
    @Environment(\.openImmersiveSpace) private var openImmersiveSpace
    @Environment(\.dismissImmersiveSpace) private var dismissImmersiveSpace

    var body: some View {
        ZStack {
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
                } else if let req = workflow.pendingHandshake {
                    HandshakePrompt(
                        request: req,
                        onStart: {
                            Task { _ = await openImmersiveSpace(id: "HandTrackingScene") }
                        },
                        onHandshakeDetected: {
                            Task {
                                _ = await dismissImmersiveSpace()
                                await MainActor.run { workflow.completeHandshake() }
                            }
                        }
                    )
                } else {
                    idleHint
                }
            }
            .frame(minWidth: 360, minHeight: 420)

            if let msg = workflow.successMessage {
                successBanner(msg)
                    .transition(.move(edge: .top).combined(with: .opacity))
                    .zIndex(10)
            }
        }
        .animation(.spring(response: 0.35, dampingFraction: 0.86), value: workflow.successMessage)
        .onAppear {
            // Nothing to wire here; HandshakePrompt listens to notifications.
        }
    }

    private var idleHint: some View {
        VStack(spacing: 16) {
            Text("Wählen Sie einen Baustein im AI Integration Workflow.")
                .font(.headline)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 24)

            Text("Tipp: Lassen Sie dieses Fenster während der Auswahl geöffnet.")
                .font(.footnote)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.background)
    }

    private func successBanner(_ text: String) -> some View {
        VStack(spacing: 0) {
            HStack(spacing: 12) {
                Image(systemName: "checkmark.seal.fill")
                    .imageScale(.large)
                Text(text).font(.subheadline.weight(.semibold))
                Spacer()
            }
            .padding(12)
            .background(.regularMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 14))
            .shadow(radius: 8, y: 4)
            Spacer()
        }
        .padding()
        .allowsHitTesting(false)
    }
}
