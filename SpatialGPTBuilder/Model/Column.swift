//
//  Column.swift
//  SpatialGPTBuilder
//
//  Created by Steinhauer, Jan on 02.11.25.
//

import SwiftUI

enum Column: CaseIterable, Hashable {
    case col1, col2, col3

    var categories: [Category] {
        switch self {
        case .col1: return [.hostingCountry, .dataSource]
        case .col2: return [.dataPrivacy, .accessControl, .infrastructure, .interface]
        case .col3: return [.aiModel, .integration]
        }
    }
    
    var displayName: String {
        switch self {
        case .col1: return "Column 1"
        case .col2: return "Column 2"
        case .col3: return "Column 3"
        }
    }

}

extension Category {
    var column: Column {
        switch self {
        case .hostingCountry, .dataSource: return .col1
        case .dataPrivacy, .accessControl, .infrastructure, .interface: return .col2
        case .aiModel, .integration: return .col3
        }
    }
}

extension Dictionary where Key == Category, Value == OptionItem {
    func hasAllSelected(in column: Column) -> Bool {
        column.categories.allSatisfy { self[$0] != nil }
    }
}
