//
//  TerminalBlock.swift
//  SpatialGPTBuilder
//
//  Created by Steinhauer, Jan on 19.10.25.
//

import SwiftUI

struct TerminalBlock: View {
    enum Kind { case start, finish }
    let kind: Kind
    let title: String
    let width: CGFloat
    let height: CGFloat

    var body: some View {
        let r = min(width, height) * 0.4
        let shape: some InsettableShape = {
            switch kind {
            case .start:
                return UnevenRoundedRectangle(
                    topLeadingRadius: r, bottomLeadingRadius: r,
                    bottomTrailingRadius: 0, topTrailingRadius: 0
                )
            case .finish:
                return UnevenRoundedRectangle(
                    topLeadingRadius: 0, bottomLeadingRadius: 0,
                    bottomTrailingRadius: r, topTrailingRadius: r
                )
            }
        }()

        Text(title)
            .font(.system(size: min(22, height * 0.55), weight: .bold))
            .frame(width: width, height: height)
            .background(shape.fill(Color(.tertiarySystemBackground)))
            .overlay(shape.stroke(Color.secondary.opacity(0.6), lineWidth: 1.5))
            .shadow(radius: 3, y: 2)
            .accessibilityLabel(title)
    }
}
