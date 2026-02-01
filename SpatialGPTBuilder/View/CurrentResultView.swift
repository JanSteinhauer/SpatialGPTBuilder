//
//  CurrentResultView.swift
//  SpatialGPTBuilder
//
//  Created by Steinhauer, Jan on 19.10.25.
//

import SwiftUI
import Combine

struct CurrentResultView: View {
    @EnvironmentObject private var workflow: WorkflowCoordinator

    // If you want to let the user switch weighting, expose this as a @State var
    private let profile: ScoreProfile = .security

    @State private var metrics: Metrics = .init(costEURPer1K: Base.costEURPer1K,
                                                security: Base.security,
                                                speed: Base.speed,
                                                issues: Base.issues)
    @State private var score: Double = 0

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
                Text("Aktuelles Ergebnis") // Current Result
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
                    Text(currency(metrics.costEURPer1K))
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
                    Text(stars(from: metrics.security))
                        .accessibilityLabel("\(metrics.security) von 100") // out of 100
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
                    Text(speedLabel(metrics.speed))
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
                Text(issuesLabel(metrics.issues))
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
                Text(String(format: "%.0f", score))
                    .monospacedDigit()
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)

            HStack {
                Spacer()
                Button("Fertig") { // Submit
                    // TODO: Submit Message
                }
                .buttonStyle(.borderedProminent)
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 16)
            .padding(.top, 4)
        }
        .onAppear { recompute() }
        // Update whenever the workflow’s revision changes (already bumped in your coordinator)
        .onChange(of: workflow.revision) { _ in
            recompute()
        }
        // Also react instantly if the selections dictionary object identity changes
        .onChange(of: workflow.selections) { _ in
            recompute()
        }
        // And when a handshake completes (optional — often coincides with revision bump)
        .onReceive(NotificationCenter.default.publisher(for: .workflowDidChange)) { _ in
            recompute()
        }
    }
}
