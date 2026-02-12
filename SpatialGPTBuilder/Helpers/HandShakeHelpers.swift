//
//  HandShakeHelpers.swift
//  SpatialGPTBuilder
//
//  Created by Steinhauer, Jan on 02.11.25.
//

import SwiftUI

struct HandshakeRequest: Equatable, Codable, Sendable {
    let scope: HandshakeScope
    let items: [OptionItem]
}

enum HandshakeScope: Equatable, Codable, Sendable {
    case category(Category)
    case column(Column)
}
