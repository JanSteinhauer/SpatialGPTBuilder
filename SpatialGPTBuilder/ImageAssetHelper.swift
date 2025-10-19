//
//  ImageAssetHelper.swift
//  SpatialGPTBuilder
//
//  Created by Steinhauer, Jan on 19.10.25.
//

import SwiftUI

enum ImageAssetHelper {
    #if canImport(UIKit)
    static func imageExists(named: String) -> Bool {
        return UIImage(named: named) != nil
    }
    #else
    static func imageExists(named: String) -> Bool { false }
    #endif
}
