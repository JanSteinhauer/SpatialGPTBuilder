//
//  ProcessBlock.swift
//  SpatialGPTBuilder
//
//  Created by Steinhauer, Jan on 19.10.25.
//

import SwiftUI

struct ProcessBlock: View {
    let placeholderTitle: String
    let selected: OptionItem?
    let width: CGFloat
    let height: CGFloat

    // Convenience
    private var title: String { selected?.displayName ?? placeholderTitle }
    private var selectedAssetName: String? { selected?.mappedAssetName }

    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                // Background tile shape to match your style
                RoundedRectangle(cornerRadius: min(16, height * 0.28), style: .continuous)
                    .fill(Color(.secondarySystemBackground))
                    .overlay(
                        RoundedRectangle(cornerRadius: min(16, height * 0.28), style: .continuous)
                            .stroke(Color.secondary.opacity(0.5), lineWidth: 1)
                    )

                Group {
                    if let name = selectedAssetName, ImageAssetHelper.imageExists(named: name) {
                        Image(name)
                            .resizable()
                            .scaledToFit()
                            .frame(height: height * 0.45)
                            .accessibilityHidden(true)
                    } else if selected != nil {
                        Text(title)
                            .font(.title3.weight(.semibold))
                            .multilineTextAlignment(.center)
                            .minimumScaleFactor(0.6)
                            .lineLimit(2)
                            .foregroundStyle(.secondary)
                            .padding(.horizontal, 8)
                            .frame(width: width * 0.82)
                            .accessibilityHidden(true)
                    } else if ImageAssetHelper.imageExists(named: "Insert") {
                        Image("Insert")
                            .resizable()
                            .scaledToFit()
                            .frame(height: height * 0.45)
                            .accessibilityHidden(true)
                    }
                }
                .padding(.horizontal, width * 0.06)
                .padding(.vertical, height * 0.12)
            }
            .frame(width: width, height: height)
            .shadow(radius: 3, y: 2)

            Text(title)
                .font(.system(size: min(18, height * 0.35), weight: .semibold))
                .multilineTextAlignment(.center)
                .minimumScaleFactor(0.8)
        }
        .frame(width: width)
        .accessibilityLabel(title)
    }
}
