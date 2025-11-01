//
//  PickerTile.swift
//  SpatialGPTBuilder
//
//  Created by Steinhauer, Jan on 01.11.25.
//

import SwiftUI

struct PickerTile: View {
    let item: OptionItem
    let isSelected: Bool
    let width: CGFloat = 100
    let height: CGFloat = 96

    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(isSelected ? Color.accentColor.opacity(0.12) : .clear)
                    .frame(width: width, height: height)

                if let mapped = item.mappedAssetName, ImageAssetHelper.imageExists(named: mapped) {
                    Image(mapped)
                        .resizable()
                        .scaledToFit()
                        .frame(height: height * 0.52)
                        .accessibilityHidden(true)
                } else {
                    Text(item.displayName)
                        .font(.caption.weight(.semibold))
                        .multilineTextAlignment(.center)
                        .minimumScaleFactor(0.6)
                        .lineLimit(2)
                        .foregroundStyle(.secondary)
                        .padding(.horizontal, 6)
                        .frame(width: width * 0.86)
                        .accessibilityHidden(true)
                }
            }

            Text(item.displayName)
                .font(.footnote.weight(.semibold))
                .multilineTextAlignment(.center)
                .minimumScaleFactor(0.8)
                .lineLimit(2)
                .frame(width: width + 10)
        }
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(isSelected ? Color.accentColor : Color.secondary.opacity(0.3), lineWidth: isSelected ? 2 : 1)
        )
    }
}

