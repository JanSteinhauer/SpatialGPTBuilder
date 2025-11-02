//
//  HandshakePrompt.swift
//  SpatialGPTBuilder
//
//  Created by Steinhauer, Jan on 02.11.25.
//

import SwiftUI

struct HandshakePrompt: View {
    let request: HandshakeRequest
    let onStart: () -> Void
    let onHandshakeDetected: () -> Void

    @State private var started = false

    // Match the grid feel of PickerContentGrid
    private let columns = [GridItem(.adaptive(minimum: 140), spacing: 12, alignment: .top)]

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            // Title
            Text(titleLine)
                .font(.headline)

            // Subline
            Text("These selections will be confirmed:")
                .font(.subheadline)
                .foregroundStyle(.secondary)

            // Selected items shown as tiles in a LazyVGrid
            if !request.items.isEmpty {
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 14) {
                        ForEach(request.items) { item in
                            // Display as the same PickerTile; non-interactive
                            PickerTile(item: item, isSelected: true)
                                .contentShape(RoundedRectangle(cornerRadius: 12))
                                .allowsHitTesting(false) // visually clickable, but inert
                        }
                    }
                    .padding(.top, 4)
                }
                .frame(maxHeight: 220) // keep prompt compact
            }

            Divider()

            // Handshake controls
            if started {
                Label("Waiting for handshake…", systemImage: "hand.raised.fill")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            } else {
                Button {
                    started = true
                    onStart()
                } label: {
                    HStack(spacing: 8) {
                        Image(systemName: "hand.raised")
                        Text("Start confirmation")
                    }
                }
                .buttonStyle(.borderedProminent)
            }
        }
        .padding(16)
        .onReceive(NotificationCenter.default.publisher(for: .handshakeDetected)) { _ in
            onHandshakeDetected()
            started = false
        }
    }

    private var titleLine: String {
        switch request.scope {
        case .category(let c):
            return "Please confirm your selection for “\(c.display)”. Start the handshake."
        case .column(let col):
            return "Please confirm all selected in \(col.displayName). Start the handshake."
        }
    }
}
