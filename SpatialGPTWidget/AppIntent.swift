//
//  AppIntent.swift
//  SpatialGPTWidget
//
//  Created by Steinhauer, Jan on 12.10.25.
//

import WidgetKit
import AppIntents

enum LLMChoice: String, AppEnum {
    case chatgpt
    case anthropic
    case gemini
    case gemma
    case llama
    
    static var typeDisplayRepresentation: TypeDisplayRepresentation = "LLM Provider"
    
    static var caseDisplayRepresentations: [LLMChoice : DisplayRepresentation] = [
        .chatgpt: "ChatGPT",
        .anthropic: "Claude (Anthropic)",
        .gemini: "Gemini (Google)",
        .gemma: "Gemma",
        .llama: "Llama"
    ]
}

struct LLMConfigurationIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource { "LLM Configuration" }
    static var description: IntentDescription { "Choose which LLM to show." }

    @Parameter(title: "Provider", default: .chatgpt)
    var provider: LLMChoice
}
