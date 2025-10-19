//
//  Arrow.swift
//  SpatialGPTBuilder
//
//  Created by Steinhauer, Jan on 19.10.25.
//

import SwiftUI

struct Arrow: Shape {
    let from: CGPoint
    let to: CGPoint
    let headSize: CGFloat
    
    func path(in rect: CGRect) -> Path {
        var p = Path()
        p.move(to: from)
        p.addLine(to: to)
        
        let dx = to.x - from.x
        let dy = to.y - from.y
        let angle = atan2(dy, dx)
        let tip = to
        let left = CGPoint(
            x: tip.x - headSize * cos(angle - .pi / 6),
            y: tip.y - headSize * sin(angle - .pi / 6)
        )
        let right = CGPoint(
            x: tip.x - headSize * cos(angle + .pi / 6),
            y: tip.y - headSize * sin(angle + .pi / 6)
        )
        p.move(to: tip);  p.addLine(to: left)
        p.move(to: tip);  p.addLine(to: right)
        return p
    }
}
