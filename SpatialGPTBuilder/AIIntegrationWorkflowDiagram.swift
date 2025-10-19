//
//  AIIntegrationWorkflowDiagram.swift
//  SpatialGPTBuilder
//
//  Created by Steinhauer, Jan on 19.10.25.
//

import SwiftUI

struct AIIntegrationWorkflowDiagram: View {
    var body: some View {
        GeometryReader { geo in
            let W = geo.size.width
            let H = geo.size.height
            
            let margin = min(W, H) * 0.04
            
            let blockWidth  = min(150, min(W * 0.18, 420))
            let blockHeight = max(110, min(H * 0.16, 160))
            let termWidth   = min(100, min(W * 0.16, 360))
            let termHeight  = max(80,  min(H * 0.12, 120))
            
            // Horizontal spacing
            let colGap = min(120, (W - 2*margin - termWidth - 3*blockWidth) / 4) // 5 columns: Start | C1 | C2 | C3 | Finish
            let xStart  = margin + termWidth/2
            let xCol1   = xStart + termWidth/2 + colGap + blockWidth/2
            let xCol2   = xCol1   + blockWidth/2 + colGap + blockWidth/2
            let xCol3   = xCol2   + blockWidth/2 + colGap + blockWidth/2
            let xFinish = xCol3   + blockWidth/2 + colGap + termWidth/2
            
            // Vertical grid
            let availableH   = H - 2*margin
            let usedByBlocks = termHeight + 2 * blockHeight
            let freeForGaps  = max(0, availableH - usedByBlocks)

            let midY   = H * 0.5

            let step   = min(140, freeForGaps / 3.0)

            // Column 1/3 anchors
            let yTop    = midY - step
            let yBottom = midY + step

            // Column 2: EVENLY spaced
            let c2Top      = midY - 2.2 * step
            let yUpperTop  = c2Top + -0.2 * step
            let yUpperMid  = c2Top + 1.3 * step
            let yLowerMid  = c2Top + 2.8 * step
            let yLowerBot  = c2Top + 4.3 * step
            
            let join1 = CGPoint(x: xCol1 + blockWidth/2 + 20, y: midY)
            let join2 = CGPoint(x: xCol2 + blockWidth/2 + 20, y: midY)
            let join3 = CGPoint(x: xCol3 + blockWidth/2 + 20, y: midY)
            let head  = max(10, min(16, min(W, H) * 0.02))
            
            ZStack {
                // START
                TerminalBlock(kind: .start, title: "Start", width: termWidth, height: termHeight)
                    .position(x: xStart, y: midY)
                
                // COLUMN 1
                ProcessBlock(title: "Hosting Country", imageName: "Insert", width: blockWidth, height: blockHeight)
                    .position(x: xCol1, y: yTop)
                ProcessBlock(title: "Data Source", imageName: "Insert", width: blockWidth, height: blockHeight)
                    .position(x: xCol1, y: yBottom)
                
                // COLUMN 2
                ProcessBlock(title: "Dataprivacy",    imageName: "Insert", width: blockWidth, height: blockHeight)
                    .position(x: xCol2, y: yUpperTop)
                ProcessBlock(title: "Access Control", imageName: "Insert", width: blockWidth, height: blockHeight)
                    .position(x: xCol2, y: yUpperMid)
                ProcessBlock(title: "Infrastructure", imageName: "Insert", width: blockWidth, height: blockHeight)
                    .position(x: xCol2, y: yLowerMid)
                ProcessBlock(title: "Interface",      imageName: "Insert", width: blockWidth, height: blockHeight)
                    .position(x: xCol2, y: yLowerBot)
                
                // COLUMN 3
                ProcessBlock(title: "AI Model",     imageName: "Insert", width: blockWidth, height: blockHeight)
                    .position(x: xCol3, y: yTop)
                ProcessBlock(title: "Integration",  imageName: "Insert", width: blockWidth, height: blockHeight)
                    .position(x: xCol3, y: yBottom)
                
                // FINISH
                TerminalBlock(kind: .finish, title: "Finish", width: termWidth, height: termHeight)
                    .position(x: xFinish, y: midY)
                
                // --- ARROWS ---
                
                // Start -> Hosting & Data Source
                Arrow(
                    from: CGPoint(x: xStart + termWidth/2, y: midY),
                    to:   CGPoint(x: xCol1 - blockWidth/2 - 16, y: yTop),
                    headSize: head
                )
                .stroke(style: StrokeStyle(lineWidth: 2, lineCap: .round))
                .foregroundStyle(.secondary)
                
                Arrow(
                    from: CGPoint(x: xStart + termWidth/2, y: midY),
                    to:   CGPoint(x: xCol1 - blockWidth/2 - 16, y: yBottom),
                    headSize: head
                )
                .stroke(style: StrokeStyle(lineWidth: 2, lineCap: .round))
                .foregroundStyle(.secondary)
                
                // Column 1 -> join1 (both rows)
                Arrow(
                    from: CGPoint(x: xCol1 + blockWidth/2, y: yTop),
                    to:   CGPoint(x: join1.x - 12,         y: yTop),
                    headSize: head
                )
                .stroke(style: StrokeStyle(lineWidth: 2, lineCap: .round))
                .foregroundStyle(.secondary)
                
                Arrow(
                    from: CGPoint(x: xCol1 + blockWidth/2, y: yBottom),
                    to:   CGPoint(x: join1.x - 12,         y: yBottom),
                    headSize: head
                )
                .stroke(style: StrokeStyle(lineWidth: 2, lineCap: .round))
                .foregroundStyle(.secondary)
                
                // Vertical collector at join1
                Path { p in
                    p.move(to: CGPoint(x: join1.x - 12, y: yTop))
                    p.addLine(to: CGPoint(x: join1.x - 12, y: yBottom))
                }
                .stroke(Color.secondary.opacity(0.6), style: StrokeStyle(lineWidth: 2, lineCap: .round))
                
                // join1 -> Column 2 (fan out to 4 blocks)
                ForEach([yUpperTop, yUpperMid, yLowerMid, yLowerBot], id: \.self) { y in
                    Arrow(
                        from: CGPoint(x: join1.x, y: midY),
                        to:   CGPoint(x: xCol2 - blockWidth/2 - 16, y: y),
                        headSize: head
                    )
                    .stroke(style: StrokeStyle(lineWidth: 2, lineCap: .round))
                    .foregroundStyle(.secondary)
                }
                
                // Column 2 -> join2 (collect)
                ForEach([yUpperTop, yUpperMid, yLowerMid, yLowerBot], id: \.self) { y in
                    Arrow(
                        from: CGPoint(x: xCol2 + blockWidth/2, y: y),
                        to:   CGPoint(x: join2.x - 12,         y: y),
                        headSize: head
                    )
                    .stroke(style: StrokeStyle(lineWidth: 2, lineCap: .round))
                    .foregroundStyle(.secondary)
                }
                
                Path { p in
                    p.move(to: CGPoint(x: join2.x - 12, y: yUpperTop))
                    p.addLine(to: CGPoint(x: join2.x - 12, y: yLowerBot))
                }
                .stroke(Color.secondary.opacity(0.6), style: StrokeStyle(lineWidth: 2, lineCap: .round))
                
                // join2 -> Column 3 (AI Model & Integration)
                Arrow(
                    from: CGPoint(x: join2.x, y: midY),
                    to:   CGPoint(x: xCol3 - blockWidth/2 - 16, y: yTop),
                    headSize: head
                )
                .stroke(style: StrokeStyle(lineWidth: 2, lineCap: .round))
                .foregroundStyle(.secondary)
                
                Arrow(
                    from: CGPoint(x: join2.x, y: midY),
                    to:   CGPoint(x: xCol3 - blockWidth/2 - 16, y: yBottom),
                    headSize: head
                )
                .stroke(style: StrokeStyle(lineWidth: 2, lineCap: .round))
                .foregroundStyle(.secondary)
                
                // Column 3 -> join3
                Arrow(
                    from: CGPoint(x: xCol3 + blockWidth/2, y: yTop),
                    to:   CGPoint(x: join3.x - 12,         y: yTop),
                    headSize: head
                )
                .stroke(style: StrokeStyle(lineWidth: 2, lineCap: .round))
                .foregroundStyle(.secondary)
                
                Arrow(
                    from: CGPoint(x: xCol3 + blockWidth/2, y: yBottom),
                    to:   CGPoint(x: join3.x - 12,         y: yBottom),
                    headSize: head
                )
                .stroke(style: StrokeStyle(lineWidth: 2, lineCap: .round))
                .foregroundStyle(.secondary)
                
                // Vertical collector at join3
                Path { p in
                    p.move(to: CGPoint(x: join3.x - 12, y: yTop))
                    p.addLine(to: CGPoint(x: join3.x - 12, y: yBottom))
                }
                .stroke(Color.secondary.opacity(0.6), style: StrokeStyle(lineWidth: 2, lineCap: .round))
                
                // join3 -> Finish
                Arrow(
                    from: CGPoint(x: join3.x, y: midY),
                    to:   CGPoint(x: xFinish - termWidth/2, y: midY),
                    headSize: head
                )
                .stroke(style: StrokeStyle(lineWidth: 2, lineCap: .round))
                .foregroundStyle(.secondary)
            }
            .padding(.horizontal, margin)
            .padding(.vertical, margin * 0.7)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .background(.clear)
        .ignoresSafeArea()
    }
}
