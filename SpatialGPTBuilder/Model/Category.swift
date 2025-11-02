//
//  Category.swift
//  SpatialGPTBuilder
//
//  Created by Steinhauer, Jan on 19.10.25.
//

import SwiftUI

enum Category: String, CaseIterable, Identifiable, Codable, Sendable {
    case hostingCountry
    case dataSource
    case dataPrivacy
    case accessControl
    case infrastructure
    case interface
    case aiModel
    case integration

    var id: String { rawValue }
    var display: String {
        switch self {
        case .hostingCountry: return "Hosting Country"
        case .dataSource:     return "Data Source"
        case .dataPrivacy:    return "Data Privacy"
        case .accessControl:  return "Access Control"
        case .infrastructure: return "Infrastructure"
        case .interface:      return "Interface"
        case .aiModel:        return "AI Model"
        case .integration:    return "Integration"
        }
    }
    
    var subheadline: String {
            switch self {
            case .hostingCountry: return "Hosting Countries"
            case .dataSource:     return "Data Sources"
            case .dataPrivacy:    return "Data Privacy Options"
            case .accessControl:  return "Access Control"
            case .infrastructure: return "Infrastructure Options"
            case .interface:      return "Interface Options"
            case .aiModel:        return "AI Models"
            case .integration:    return "Integrations"
            }
        }
}
