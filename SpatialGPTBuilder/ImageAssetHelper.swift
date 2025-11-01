//
//  ImageAssetHelper.swift
//  SpatialGPTBuilder
//
//  Created by Steinhauer, Jan on 19.10.25.
//

import SwiftUI

enum ImageAssetHelper {
    static func imageExists(named name: String) -> Bool {
        #if canImport(UIKit)
        return UIImage(named: name) != nil
        #elseif canImport(AppKit)
        return NSImage(named: name) != nil
        #else
        return false
        #endif
    }
}
