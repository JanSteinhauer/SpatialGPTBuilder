//
//  CurrentResultView.swift
//  SpatialGPTBuilder
//
//  Created by Steinhauer, Jan on 19.10.25.
//

import SwiftUI
import Combine
import AudioToolbox

struct CurrentResultView: View {
    @EnvironmentObject private var workflow: WorkflowCoordinator

    // If you want to let the user switch weighting, expose this as a @State var
    private let profile: ScoreProfile = .security

    @State private var metrics: Metrics = .init(costEURPer1K: Base.costEURPer1K,
                                                security: Base.security,
                                                speed: Base.speed,
                                                issues: Base.issues)
    @State private var score: Double = 0
    
    private var hasSelection: Bool {
        !workflow.selections.isEmpty
    }
    
    // Validation State
    @State private var isTaskCompleted: Bool = false
    @State private var validationMessage: String? = nil

    // Formatting helpers
    private func stars(from security: Int) -> String {
        // 0..100 mapped to 0..5 stars (half steps optional; keep whole stars for simplicity)
        let s = clamp((security + 9) / 20, 0, 5) // round-ish
        return String(repeating: "⭐️", count: s)
    }
    
    private func speedLabel(_ v: Int) -> String {
        switch v {
        case ..<35: return "langsam" // slow
        case 35..<65: return "mittel"  // middle
        case 65...: return "schnell" // fast
        default: return "mittel"
        }
    }
    
    private func issuesLabel(_ v: Int) -> String {
        switch v {
        case 0...10: return "keine Probleme" // no issues
        case 11...30: return "geringes Risiko" // low risk
        case 31...60: return "mittleres Risiko" // moderate risk
        case 61...100: return "hohes Risiko" // high risk
        default: return "—"
        }
    }
    
    private func currency(_ eurPer1K: Double) -> String {
        // Show as €/1K tokens, compact
        let val = eurPer1K
        return String(format: "€%.3f / 1K", val)
    }

    private func recompute() {
        let m = computeMetrics(from: workflow.selections)
        metrics = m
        score = finalScore(m, profile: profile)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Spacer()
                Text(isTaskCompleted ? "Aufgabe erfolgreich beendet" : "Aktuelles Ergebnis") // Current Result or Success Message
                    .font(.title.bold())
                    .padding(.horizontal, 16)
                    .padding(.top, 16)
                Spacer()
            }

            Divider().padding(.top, 8)

            // COST
            VStack(spacing: 12) {
                HStack {
                    Text("Aktuelle Kosten:") // current cost:
                    Spacer()
                    Text(hasSelection ? currency(metrics.costEURPer1K) : "—")
                        .monospacedDigit()
                }
                HStack {
                    Text("Vorgegebene Kosten:") // predetermined cost:
                    Spacer()
                    Text(currency(Targets.costEURPer1K))
                        .monospacedDigit()
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)

            Divider()

            // SECURITY
            VStack(spacing: 12) {
                HStack {
                    Text("Aktuelle Sicherheit:") // current security:
                    Spacer()
                    if hasSelection {
                        Text(stars(from: metrics.security))
                            .accessibilityLabel("\(metrics.security) von 100") // out of 100
                    } else {
                        Text("—")
                    }
                }
                HStack {
                    Text("Vorgegebene Sicherheit:") // predetermined security:
                    Spacer()
                    Text(stars(from: Targets.security))
                        .accessibilityLabel("\(Targets.security) von 100")
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)

            Divider()

            // SPEED
            VStack(spacing: 12) {
                HStack {
                    Text("Aktuelle Geschwindigkeit:") // current speed:
                    Spacer()
                    Text(hasSelection ? speedLabel(metrics.speed) : "—")
                }
                HStack {
                    Text("Vorgegebene Geschwindigkeit:") // predetermined speed:
                    Spacer()
                    Text(speedLabel(Targets.speed))
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)

            Divider()

            // ISSUES
            HStack {
                Text("Risiken:") // issues (changed to 'Risiken' to match the 'Risk' values)
                Spacer()
                Text(hasSelection ? issuesLabel(metrics.issues) : "—")
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)

            Divider()

            // SCORE
            Text("Aktueller Score") // current score (Headline)
                .font(.headline)
                .padding(.horizontal, 16)
                .padding(.top, 12)

            HStack {
                Text("Aktueller Score:") // current score:
                Spacer()
                Text(hasSelection ? String(format: "%.0f", score) : "—")
                    .monospacedDigit()
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)

            HStack {
                Spacer()
                Button("Fertig") { // Submit
                    let allSelected = Category.allCases.allSatisfy { workflow.selections.keys.contains($0) }
                    
                    if allSelected {
                        // Success
                        AudioServicesPlaySystemSound(1000)
                        withAnimation {
                            isTaskCompleted = true
                        }
                    } else {
                        // Error
                        AudioServicesPlaySystemSound(1053)
                        withAnimation {
                            validationMessage = "Bitte wählen Sie für jeden Building Block etwas aus."
                        }
                        
                        Task {
                            try? await Task.sleep(nanoseconds: 3 * 1_000_000_000)
                            withAnimation {
                                validationMessage = nil
                            }
                        }
                    }
                }
                .buttonStyle(.borderedProminent)
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 16)
            .padding(.top, 4)
        }
        .overlay(alignment: .bottom) {
            if let message = validationMessage {
                Text(message)
                    .font(.body.bold())
                    .padding()
                    .background(.regularMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .padding(.bottom, 60) // Check avoid overlapping with button if needed, but overlay is on top
                    .transition(.opacity)
            }
        }
        .onAppear { recompute() }
        // Update whenever the workflow’s revision changes (already bumped in your coordinator)
        // Only update when a handshake completes (signaled by successMessage being set)
        .onChange(of: workflow.successMessage) { msg in
            if msg != nil {
                recompute()
            }
        }
    }
}
