//
//  ProcessBlock.swift
//  SpatialGPTBuilder
//
//  Created by Steinhauer, Jan on 19.10.25.
//

import SwiftUI

struct ProcessBlock: View {
    let title: String
    let imageName: String
    let width: CGFloat
    let height: CGFloat
    
    var body: some View {
        VStack(spacing: 8) {
            Image(imageName)
                .resizable()
                .scaledToFit()
                .frame(height: height * 0.45)
                .accessibilityHidden(true)
            Text(title)
                .font(.system(size: min(18, height * 0.35), weight: .semibold))
                .multilineTextAlignment(.center)
                .minimumScaleFactor(0.8)
        }
        .padding(.horizontal, width * 0.06)
        .padding(.vertical, height * 0.12)
        .frame(width: width, height: height)
        .background(
            RoundedRectangle(cornerRadius: min(16, height * 0.28), style: .continuous)
                .fill(Color(.secondarySystemBackground))
        )
        .overlay(
            RoundedRectangle(cornerRadius: min(16, height * 0.28), style: .continuous)
                .stroke(Color.secondary.opacity(0.5), lineWidth: 1)
        )
        .shadow(radius: 3, y: 2)
        .accessibilityLabel(title)
    }
}
