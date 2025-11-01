//
//  OptionsProvider.swift
//  SpatialGPTBuilder
//
//  Created by Steinhauer, Jan on 19.10.25.
//

import SwiftUI

enum OptionsProvider {
    @MainActor
    static func items(for category: Category) -> [OptionItem] {
        switch category {
        case .aiModel:
            return ["chatgpt", "anthropic", "gemini", "gemma", "llama"].map(OptionItem.init)
        case .interface:
            return ["standaloneWebApp", "apiIntegration", "mobileApp"].map(OptionItem.init)
        case .accessControl:
            return ["freeUse", "moderationFilter", "roleBasedAccess"].map(OptionItem.init)
        case .infrastructure:
            return ["localServer", "privateCloud", "cloud"].map(OptionItem.init)
        case .dataPrivacy:
            return ["internalStorage", "fineTuning", "rag",
                    "standardEncryption", "multiFactorAuth", "privacyByDesign"].map(OptionItem.init)
        case .integration:
            return ["microsoft365", "googleWorkspace"].map(OptionItem.init)
        case .dataSource:
            return ["internalSystems", "openData"].map(OptionItem.init)
        case .hostingCountry:
            return ["germanyHosting", "euHosting", "globalHosting"].map(OptionItem.init)
        }
    }
    
    @MainActor
    static func allItems() -> [OptionItem] {
        Category.allCases
            .flatMap { items(for: $0) }
            .reduce(into: [String: OptionItem]()) { dict, item in dict[item.id] = item }
            .values
            .sorted { $0.displayName < $1.displayName }
    }
}
