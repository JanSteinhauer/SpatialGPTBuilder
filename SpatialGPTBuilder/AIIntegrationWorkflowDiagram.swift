//
//  AIIntegrationWorkflowDiagram.swift
//  SpatialGPTBuilder
//
//  Created by Steinhauer, Jan on 19.10.25.
//

import SwiftUI

struct AIIntegrationWorkflowDiagram: View {
    @State private var selections: [Category: OptionItem] = [:]
    @State private var showingPickerFor: Category?

    var body: some View {
        GeometryReader { geo in
            let W = geo.size.width
            let H = geo.size.height

            let margin = min(W, H) * 0.04

            let blockWidth  = min(150, min(W * 0.18, 420))
            let blockHeight = max(110, min(H * 0.16, 160))
            let termWidth   = min(100, min(W * 0.16, 360))
            let termHeight  = max(80,  min(H * 0.12, 120))

            // Horizontal positions
            let colGap = min(120, (W - 2*margin - termWidth - 3*blockWidth) / 4)
            let xStart  = margin + termWidth/2
            let xCol1   = xStart + termWidth/2 + colGap + blockWidth/2
            let xCol2   = xCol1   + blockWidth/2 + colGap + blockWidth/2
            let xCol3   = xCol2   + blockWidth/2 + colGap + blockWidth/2
            let xFinish = xCol3   + blockWidth/2 + colGap + termWidth/2

            // Vertical positions
            let availableH   = H - 2*margin
            let usedByBlocks = termHeight + 2 * blockHeight
            let freeForGaps  = max(0, availableH - usedByBlocks)

            let midY   = H * 0.5
            let step   = min(140, freeForGaps / 3.0)

            let yTop    = midY - step
            let yBottom = midY + step

            let c2Top      = midY - 2.2 * step
            let yUpperTop  = c2Top + -0.2 * step
            let yUpperMid  = c2Top +  1.3 * step
            let yLowerMid  = c2Top +  2.8 * step
            let yLowerBot  = c2Top +  4.3 * step

            let join1 = CGPoint(x: xCol1 + blockWidth/2 + 20, y: midY)
            let join2 = CGPoint(x: xCol2 + blockWidth/2 + 20, y: midY)
            let join3 = CGPoint(x: xCol3 + blockWidth/2 + 20, y: midY)
            let head  = max(10, min(16, min(W, H) * 0.02))

            ZStack {
                // === INTERACTIVE BLOCKS (Buttons) ===

                // START/FINISH are static
                TerminalBlock(kind: .start, title: "Start", width: termWidth, height: termHeight)
                    .position(x: xStart, y: midY)
                    .zIndex(1)

                // Column 1
                blockButton(category: .hostingCountry,
                            placeholder: Category.hostingCountry.display,
                            x: xCol1, y: yTop,
                            w: blockWidth, h: blockHeight)
                    .zIndex(1)

                blockButton(category: .dataSource,
                            placeholder: Category.dataSource.display,
                            x: xCol1, y: yBottom,
                            w: blockWidth, h: blockHeight)
                    .zIndex(1)

                // Column 2
                blockButton(category: .dataPrivacy,
                            placeholder: Category.dataPrivacy.display,
                            x: xCol2, y: yUpperTop,
                            w: blockWidth, h: blockHeight)
                    .zIndex(1)

                blockButton(category: .accessControl,
                            placeholder: Category.accessControl.display,
                            x: xCol2, y: yUpperMid,
                            w: blockWidth, h: blockHeight)
                    .zIndex(1)

                blockButton(category: .infrastructure,
                            placeholder: Category.infrastructure.display,
                            x: xCol2, y: yLowerMid,
                            w: blockWidth, h: blockHeight)
                    .zIndex(1)

                blockButton(category: .interface,
                            placeholder: Category.interface.display,
                            x: xCol2, y: yLowerBot,
                            w: blockWidth, h: blockHeight)
                    .zIndex(1)

                // Column 3
                blockButton(category: .aiModel,
                            placeholder: Category.aiModel.display,
                            x: xCol3, y: yTop,
                            w: blockWidth, h: blockHeight)
                    .zIndex(1)

                blockButton(category: .integration,
                            placeholder: Category.integration.display,
                            x: xCol3, y: yBottom,
                            w: blockWidth, h: blockHeight)
                    .zIndex(1)

                TerminalBlock(kind: .finish, title: "Finish", width: termWidth, height: termHeight)
                    .position(x: xFinish, y: midY)
                    .zIndex(1)

                // === NON-INTERACTIVE LINES/ARROWS ===
                Group {
                    // Start -> Col1 (top & bottom)
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

                    // Col1 -> join1
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

                    // join1 vertical
                    Path { p in
                        p.move(to: CGPoint(x: join1.x - 12, y: yTop))
                        p.addLine(to: CGPoint(x: join1.x - 12, y: yBottom))
                    }
                    .stroke(Color.secondary.opacity(0.6), style: StrokeStyle(lineWidth: 2, lineCap: .round))

                    // join1 -> Col2 (fan out)
                    ForEach([yUpperTop, yUpperMid, yLowerMid, yLowerBot], id: \.self) { y in
                        Arrow(
                            from: CGPoint(x: join1.x, y: midY),
                            to:   CGPoint(x: xCol2 - blockWidth/2 - 16, y: y),
                            headSize: head
                        )
                        .stroke(style: StrokeStyle(lineWidth: 2, lineCap: .round))
                        .foregroundStyle(.secondary)
                    }

                    // Col2 -> join2 (collect)
                    ForEach([yUpperTop, yUpperMid, yLowerMid, yLowerBot], id: \.self) { y in
                        Arrow(
                            from: CGPoint(x: xCol2 + blockWidth/2, y: y),
                            to:   CGPoint(x: join2.x - 12,         y: y),
                            headSize: head
                        )
                        .stroke(style: StrokeStyle(lineWidth: 2, lineCap: .round))
                        .foregroundStyle(.secondary)
                    }

                    // join2 vertical
                    Path { p in
                        p.move(to: CGPoint(x: join2.x - 12, y: yUpperTop))
                        p.addLine(to: CGPoint(x: join2.x - 12, y: yLowerBot))
                    }
                    .stroke(Color.secondary.opacity(0.6), style: StrokeStyle(lineWidth: 2, lineCap: .round))

                    // join2 -> Col3
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

                    // Col3 -> join3
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

                    // join3 vertical
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
                .allowsHitTesting(false)
            }
            .padding(.horizontal, margin)
            .padding(.vertical, margin * 0.7)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .background(.clear)
        .ignoresSafeArea()
        .popover(item: $showingPickerFor, attachmentAnchor: .rect(.bounds)) { category in
            PickerContent(
                title: category.display,
                options: OptionsProvider.items(for: category),
                onSelect: { item in
                    selections[category] = item
                    showingPickerFor = nil
                },
                onCancel: { showingPickerFor = nil }
            )
            .frame(minWidth: 340)
        }
    }

    // MARK: - Block helper (Button)
    @ViewBuilder
    private func blockButton(category: Category,
                             placeholder: String,
                             x: CGFloat, y: CGFloat,
                             w: CGFloat, h: CGFloat) -> some View {
        Button {
            showingPickerFor = category
        } label: {
            ProcessBlock(
                placeholderTitle: placeholder,
                selected: selections[category],
                width: w, height: h
            )
        }
        .buttonStyle(.plain)
        .position(x: x, y: y)
        .accessibilityLabel("\(placeholder) picker")
        .accessibilityAddTraits(.isButton)
    }
}

// MARK: - Popup Content
private struct PickerContent: View {
    let title: String
    let options: [OptionItem]
    let onSelect: (OptionItem) -> Void
    let onCancel: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(title).font(.headline)
                Spacer()
                Button("Cancel", role: .cancel, action: onCancel)
            }

            Divider()

            ScrollView {
                VStack(alignment: .leading, spacing: 8) {
                    ForEach(options) { item in
                        Button {
                            onSelect(item)
                        } label: {
                            HStack(spacing: 12) {
                                if ImageAssetHelper.imageExists(named: item.assetName) {
                                    Image(item.assetName)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 28, height: 28)
                                        .accessibilityHidden(true)
                                }
                                Text(item.displayName)
                                    .font(.body)
                                Spacer()
                            }
                            .padding(10)
                            .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 12))
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.vertical, 4)
            }
        }
        .padding(16)
    }
}
