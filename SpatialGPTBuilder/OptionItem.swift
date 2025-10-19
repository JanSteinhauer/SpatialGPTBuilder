//
//  OptionItem.swift
//  SpatialGPTBuilder
//
//  Created by Steinhauer, Jan on 19.10.25.
//

import SwiftUI

struct OptionItem: Identifiable, Hashable {
    let id: String
    let displayName: String
    let assetName: String

    init(_ id: String) {
        self.id = id
        self.displayName = OptionItem.pretty(id)
        self.assetName = id
    }

    private static func pretty(_ raw: String) -> String {
        let spaced = raw
            .replacingOccurrences(of: "([a-z])([A-Z])", with: "$1 $2", options: .regularExpression)
            .replacingOccurrences(of: "_", with: " ")
        return spaced
            .replacingOccurrences(of: "eu", with: "EU", options: .caseInsensitive)
            .replacingOccurrences(of: "usa", with: "USA", options: .caseInsensitive)
            .capitalized
    }
}
