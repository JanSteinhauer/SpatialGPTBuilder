//
//  SpatialGPTWidgetBundle.swift
//  SpatialGPTWidget
//
//  Created by Steinhauer, Jan on 12.10.25.
//

import WidgetKit
import SwiftUI

@main
struct SpatialLLMWidgetBundle: WidgetBundle {
    var body: some Widget {
        SecurityLLMWidget()
        FinanceLLMWidget()
    }
}

// MARK: - Intent convenience init

private extension LLMConfigurationIntent {
    init(provider: LLMChoice) {
        self.init()
        self.provider = provider
    }
}
