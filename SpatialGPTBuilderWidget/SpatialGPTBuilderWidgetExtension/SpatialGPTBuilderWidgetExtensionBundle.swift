//
//  SpatialGPTBuilderWidgetExtensionBundle.swift
//  SpatialGPTBuilderWidgetExtension
//
//  Created by Steinhauer, Jan on 08.03.26.
//

import WidgetKit
import SwiftUI

@main
struct SpatialGPTBuilderWidgetExtensionBundle: WidgetBundle {
    var body: some Widget {
        SecurityLLMWidget()
        FinanceLLMWidget()
        IndividualTaskWidget()
        OverallTaskInfoWidget()
        CategoryHeaderWidget()
    }
}

// MARK: - Intent convenience init

private extension LLMConfigurationIntent {
    init(provider: LLMChoice) {
        self.init()
        self.provider = provider
    }
}
