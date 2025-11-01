//
//  RoundedBlockTile.swift
//  SpatialGPTBuilder
//
//  Created by Steinhauer, Jan on 19.10.25.
//

import SwiftUI

struct RoundedBlockTile: View {
    let title: String
    let assetName: String?
    var size: CGFloat = 112

    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .fill(.quaternary)
                    .frame(width: size, height: size)

                if let assetName, _Asset.exists(named: assetName) {
                    Image(assetName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: size * 0.58, height: size * 0.58)
                        .accessibilityLabel(Text(title))
                } else {
                    Text(title)
                        .font(.title3.weight(.semibold))
                        .multilineTextAlignment(.center)
                        .minimumScaleFactor(0.6)
                        .lineLimit(2)
                        .foregroundStyle(.secondary)
                        .padding(.horizontal, 8)
                        .frame(width: size * 0.82)
                        .accessibilityHidden(true)
                }
            }

            Text(title)
                .font(.headline)
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .minimumScaleFactor(0.8)
                .frame(maxWidth: size + 20)
        }
        .frame(maxWidth: .infinity, alignment: .center)
        .padding(.vertical, 6)
    }
}

// MARK: - Asset existence helper
private enum _Asset {
    static func exists(named name: String) -> Bool {
        #if canImport(UIKit)
        return UIImage(named: name) != nil
        #elseif canImport(AppKit)
        return NSImage(named: name) != nil
        #else
        return Image(name) != nil 
        #endif
    }
}
