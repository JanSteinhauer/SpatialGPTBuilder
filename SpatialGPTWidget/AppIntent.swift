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
    case standaloneWebApp
    case apiIntegration
    case mobileApp
    case freeUse
    case moderationFilter
    case roleBasedAccess
    case localServer
    case privateCloud
    case cloud

    
    static var typeDisplayRepresentation: TypeDisplayRepresentation = "LLM Provider"
    
    static var caseDisplayRepresentations: [LLMChoice : DisplayRepresentation] = [
        .chatgpt: "ChatGPT",
        .anthropic: "Claude (Anthropic)",
        .gemini: "Gemini (Google)",
        .gemma: "Gemma",
        .llama: "Llama",
        .standaloneWebApp: "WebApp",
        .apiIntegration: "API Integration",
        .mobileApp: "Mobile App",
        .freeUse: "Free Use",
        .moderationFilter: "Moderation Filter",
        .roleBasedAccess: "Role-Based Access",
        .localServer: "Local Server",
        .privateCloud: "Private Cloud",
        .cloud: "Cloud"
    ]
}

struct LLMConfigurationIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource { "LLM Configuration" }
    static var description: IntentDescription { "Choose which LLM to show." }

    @Parameter(title: "Provider", default: .chatgpt)
    var provider: LLMChoice
}
