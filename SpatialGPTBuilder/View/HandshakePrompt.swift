//
//  HandshakePrompt.swift
//  SpatialGPTBuilder
//
//  Created by Steinhauer, Jan on 02.11.25.
//

import SwiftUI
import AudioToolbox

struct HandshakePrompt: View {
    let request: HandshakeRequest
    let onStart: () -> Void
    let onHandshakeDetected: () -> Void

    @State private var started = false

    // Match the grid feel of PickerContentGrid
    private let columns = [GridItem(.adaptive(minimum: 140), spacing: 12, alignment: .top)]

    var body: some View {
        VStack(spacing: 24) {
            // New German Title - Centered & Bold
            Text("Klicke um den Handshake zu starten")
                .font(.title2.bold())
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)

            // Subline
            Text("Folgende Auswahl wird bestätigt:")
                .font(.body)
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
                    .padding(.horizontal, 4) // visible edges
                }
                .frame(maxHeight: 220) // keep prompt compact
            }

            Divider()
                .padding(.horizontal, 16)

            // Handshake controls
            if started {
                VStack(spacing: 8) {
                    Image(systemName: "hand.raised.fill")
                        .font(.system(size: 44))
                        .foregroundStyle(.blue)
                        .symbolEffect(.bounce.up.byLayer, options: .repeating)
                    
                    Text("Warte auf Handschlag...")
                        .font(.headline)
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 8)
                .transition(.opacity.combined(with: .scale))
            } else {
                Button {
                    // Play system sound for feedback (approx. "Tock" or confirmation click)
                    AudioServicesPlaySystemSound(1057)
                    
                    withAnimation {
                        started = true
                    }
                    onStart()
                } label: {
                    HStack(spacing: 12) {
                        Image(systemName: "hand.wave.fill")
                        Text("Handshake starten")
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 6)
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                .padding(.horizontal, 32)
            }
        }
        .padding(24)
        .frame(width: 440)
        .background(.regularMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .onReceive(NotificationCenter.default.publisher(for: .handshakeDetected)) { _ in
            onHandshakeDetected()
            started = false
        }
    }
}
