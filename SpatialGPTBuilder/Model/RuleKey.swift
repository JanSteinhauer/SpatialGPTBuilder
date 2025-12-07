//
//  RuleKey.swift
//  SpatialGPTBuilder
//
//  Created by Steinhauer, Jan on 09.11.25.
//

import SwiftUI
import Combine

struct Deltas {
    var cost: Double      // € per 1K tokens (additive)
    var security: Int     // 0..100 additive then clamped
    var speed: Int        // 0..100 additive then clamped
    var issues: Int       // 0..100 additive then clamped
}

enum RuleKey: String, Hashable {
    // Categories & options as produced by OptionsProvider IDs
    // Model
    case chatgpt, anthropic, gemini, gemma, llama
    // Hosting Country / Residency
    case germanyHosting, euHosting, globalHosting
    // Data Source
    case internalSystems, openData
    // Data Privacy (strategy + controls are all in this bucket per your OptionsProvider)
    case internalStorage, fineTuning, rag
    case standardEncryption, multiFactorAuth, privacyByDesign
    // Access Control (separate category, same ID space)
    case freeUse, moderationFilter, roleBasedAccess
    // Infrastructure (deployment target)
    case localServer, privateCloud, cloud
    // Interface (integration surface)
    case standaloneWebApp, apiIntegration, mobileApp
    // Integration (ecosystem)
    case microsoft365, googleWorkspace
}

// Individual option deltas
let RULES: [RuleKey: Deltas] = [
    // Models
    .chatgpt:        .init(cost: 0.020, security: -5,  speed: +10, issues: -5),
    .anthropic:      .init(cost: 0.012, security: +5,  speed: +8,  issues: -8),
    .gemini:         .init(cost: 0.006, security: -2,  speed: +8,  issues: -5),
    .llama:          .init(cost: 0.004, security: +10, speed: -5,  issues: +8),
    .gemma:          .init(cost: 0.003, security: +8,  speed: -2,  issues: +6),

    // Infrastructure (deployment target)
    .cloud:          .init(cost: 0.000, security: -10, speed: +15, issues: -5),
    .privateCloud:   .init(cost: 0.004, security: +5,  speed: +5,  issues: +2),
    .localServer:    .init(cost: 0.010, security: +15, speed: -10, issues: +10),

    // Hosting Country / Residency
    .germanyHosting: .init(cost: 0.002, security: +15, speed: -2,  issues: -2),
    .euHosting:      .init(cost: 0.001, security: +10, speed:  0,  issues: -1),
    .globalHosting:  .init(cost: 0.000, security: -10, speed: +2,  issues: +2),

    // Data Strategy (in your project this lives under .dataPrivacy category)
    .internalStorage:.init(cost: 0.000, security: +5,  speed: +10, issues: +8),
    .rag:            .init(cost: 0.004, security: +3,  speed: -5,  issues: -8),
    .fineTuning:     .init(cost: 0.010, security: -5,  speed: +8,  issues: -5),

    // Access / Governance (multiple can apply)
    .multiFactorAuth:.init(cost: 0.002, security: +15, speed: -2,  issues: -5),
    .roleBasedAccess:.init(cost: 0.003, security: +12, speed: -1,  issues: -6),
    .moderationFilter:.init(cost: 0.002, security: +10, speed: -3, issues: -8),
    .privacyByDesign:.init(cost: 0.003, security: +15, speed: -1,  issues: -6),
    .standardEncryption:.init(cost: 0.000, security: -8, speed: +1, issues: +4),

    // Interface (integration surface)
    .standaloneWebApp:.init(cost: 0.001, security: -2, speed: +8,  issues: +2),
    .apiIntegration:  .init(cost: 0.003, security: +3, speed: +5,  issues: -3),
    .mobileApp:       .init(cost: 0.004, security: -5, speed: +5,  issues: +5),

    // Integration ecosystem
    .microsoft365:   .init(cost: 0.003, security: +8,  speed: +3,  issues: -2),
    .googleWorkspace:.init(cost: 0.002, security: -2,  speed: +5,  issues: -1),

    // Data Source
    .internalSystems:.init(cost: 0.006, security: +12, speed: -3,  issues: -4),
    .openData:       .init(cost: 0.000, security: -10, speed: +2,  issues: +6)
]

// MARK: - Calculator

struct Metrics {
    var costEURPer1K: Double
    var security: Int // 0...100
    var speed: Int    // 0...100
    var issues: Int   // 0...100
}

struct Weights {
    var costScore: Double
    var security: Double
    var speed: Double
    var issuesInverse: Double
}

enum ScoreProfile {
    case finance, security
    var weights: Weights {
        switch self {
        case .finance:  return .init(costScore: 0.40, security: 0.30, speed: 0.20, issuesInverse: 0.10)
        case .security: return .init(costScore: 0.15, security: 0.45, speed: 0.15, issuesInverse: 0.25)
        }
    }
}

enum Targets {
    static let costEURPer1K: Double = 0.030
    static let security: Int = 80
    static let speed: Int = 60
    static let issues: Int = 20
}

enum Base {
    static let costEURPer1K: Double = 0.010
    static let security: Int = 50
    static let speed: Int = 50
    static let issues: Int = 50
}

func clamp<T: Comparable>(_ v: T, _ lo: T, _ hi: T) -> T { max(lo, min(hi, v)) }

func costScore(_ cost: Double) -> Double {
    // Map €0.002 → 100, €0.040 → 0
    let lo = 0.002, hi = 0.040
    if cost <= lo { return 100 }
    if cost >= hi { return 0 }
    let t = (cost - lo) / (hi - lo)
    return 100.0 * (1.0 - t)
}

func finalScore(_ m: Metrics, profile: ScoreProfile) -> Double {
    let w = profile.weights
    let cs = costScore(m.costEURPer1K)
    let invIssues = 100.0 - Double(m.issues)
    return w.costScore*cs + w.security*Double(m.security) + w.speed*Double(m.speed) + w.issuesInverse*invIssues
}

// Pull deltas from current selections and compute metrics
func computeMetrics(from selections: [Category: OptionItem]) -> Metrics {
    // If everything is cleared, return zero metrics
    if selections.isEmpty {
        return Metrics(costEURPer1K: 0,
                       security: 0,
                       speed: 0,
                       issues: 0)
    }

    var cost = Base.costEURPer1K
    var sec  = Base.security
    var spd  = Base.speed
    var iss  = Base.issues

    let selectedKeys = selections.values.compactMap { RuleKey(rawValue: $0.id) }
    let effectiveRules = applyConditionalAdjustments(RULES, chosen: selectedKeys)

    for key in selectedKeys {
        if let d = effectiveRules[key] {
            cost += d.cost
            sec  += d.security
            spd  += d.speed
            iss  += d.issues
        }
    }

    return Metrics(costEURPer1K: max(0, cost),
                   security: clamp(sec, 0, 100),
                   speed: clamp(spd, 0, 100),
                   issues: clamp(iss, 0, 100))
}


func applyConditionalAdjustments(
    _ rules: [RuleKey: Deltas],
    chosen: [RuleKey]
) -> [RuleKey: Deltas] {

    var out = rules
    func bump(_ key: RuleKey, security: Int = 0, speed: Int = 0, issues: Int = 0, cost: Double = 0) {
        guard out[key] != nil else { return }
        out[key]!.security += security
        out[key]!.speed    += speed
        out[key]!.issues   += issues
        out[key]!.cost     += cost
    }

    func has(_ key: RuleKey) -> Bool { chosen.contains(key) }

    if has(.fineTuning) && has(.globalHosting) {
        bump(.fineTuning, security: -10, issues: +5)
    }

    if has(.llama) && has(.localServer) {
        bump(.llama, speed: +5)
    }

    if has(.rag) && has(.openData) {
        bump(.rag, security: -5, issues: +10)
    }

    if has(.internalStorage) && has(.privacyByDesign) {
        bump(.internalStorage, security: +5, issues: -5)
    }

    if has(.cloud) && has(.standardEncryption) {
        bump(.standardEncryption, security: -10, issues: +8)
    }

    if has(.multiFactorAuth) &&
        (has(.roleBasedAccess) || has(.moderationFilter) || has(.freeUse)) {
        bump(.multiFactorAuth, security: +5)
    }

    if has(.microsoft365) && has(.internalSystems) {
        bump(.microsoft365, speed: +3, issues: -3)
    }

    if has(.roleBasedAccess) && has(.rag) {
        bump(.rag, security: +5)
    }

    if has(.localServer) && has(.germanyHosting) {
        bump(.localServer, security: +10)
    }

    if has(.apiIntegration) && (has(.gemini) || has(.chatgpt)) {
        bump(.apiIntegration, speed: +3)
    }

    if has(.gemini) && has(.googleWorkspace) {
        bump(.gemini, speed: +5, issues: -5)
        bump(.googleWorkspace, speed: +5, issues: -3)
    }

    if has(.openData) {
        bump(.openData, security: -15, issues: +10)
    }

    if has(.standaloneWebApp) && has(.privacyByDesign) {
        bump(.privacyByDesign, security: -8, issues: +5)
    }

    if has(.globalHosting) && has(.internalSystems) {
        bump(.internalSystems, security: -15, issues: +10)
    }

    if has(.fineTuning) && has(.openData) {
        bump(.fineTuning, security: -5, issues: +10)
    }

    return out
}


