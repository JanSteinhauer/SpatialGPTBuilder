//
//  OverallTaskInfo.swift
//  SpatialGPTWidgetExtension
//
//  Created by Steinhauer, Jan on 18.10.25.
//

import WidgetKit
import SwiftUI

// MARK: - Model

private struct OverallTaskInfo: Hashable {
    let title: String
    let goal: String
    let important: [String]

    static let common: OverallTaskInfo = .init(
        title: "Overall Task",
        goal: "Bereitstellung eines vollständigen, zuverlässigen AI Integration Workflows, der Nutzeranforderungen, Sicherheitsvorgaben und Budgetziele erfüllt.",
        important: [
            "Use all building blocks: model, data strategy, hosting, access control, and UX, none can stand alone.",
            "Work together as one team: security, finance, data, and engineering align decisions and trade-offs.",
            "Integrate every layer: Model & Data (internal storage or RAG, refresh cadence); Hosting & Residency (Local, DE/EU, Global, SLAs); Access & Governance (MFA, RBAC, Moderation, logging/audit); Finance & Monitoring (budgets, usage tracking, monthly reviews).",
            "Success = cohesion: each block must operate as one shared architecture, not isolated tasks."
        ]
    )
}

// MARK: - Timeline

private struct OverallTaskEntry: TimelineEntry {
    let date: Date
    let info: OverallTaskInfo
}

private struct OverallTaskProvider: TimelineProvider {
    func placeholder(in context: Context) -> OverallTaskEntry {
        OverallTaskEntry(date: .now, info: .common)
    }

    func getSnapshot(in context: Context, completion: @escaping (OverallTaskEntry) -> Void) {
        completion(OverallTaskEntry(date: .now, info: .common))
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<OverallTaskEntry>) -> Void) {
        let start = Date()
        let entries = (0..<3).compactMap { h in
            OverallTaskEntry(date: Calendar.current.date(byAdding: .hour, value: h, to: start)!, info: .common)
        }
        completion(Timeline(entries: entries, policy: .atEnd))
    }
}

// MARK: - Views

private struct OverallTaskCardView: View {
    let info: OverallTaskInfo
    @Environment(\.levelOfDetail) private var lod

    var body: some View {
        switch lod {
        case .simplified:
            simplifiedView
        default:
            detailedView
        }
    }

    // Far-away: just the label
    private var simplifiedView: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .fill(.clear)
                .accessibilityHidden(true)
            Text(info.title)
                .font(.system(size: 40, weight: .bold))
                .minimumScaleFactor(0.6)
                .multilineTextAlignment(.center)
                .accessibilityLabel("Overall Task")
        }
        .padding(16)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .containerBackground(.white.gradient, for: .widget)
    }

    // Close-up: Goal + Task Important
    private var detailedView: some View {
        GeometryReader { geo in
            let isPortraitish = geo.size.height >= geo.size.width
            Group {
                if isPortraitish {
                    OverallTaskDetailColumn(info: info)
                } else {
                    HStack(alignment: .top, spacing: 16) {
                        VStack(alignment: .leading, spacing: 8) {
                            OverallHeaderRow(title: info.title)
                            Divider()
                            OverallSectionHeader(title: "Goal")
                            OverallBulletList(items: [info.goal])
                        }
                        VStack(alignment: .leading, spacing: 8) {
                            OverallSectionHeader(title: "Task Important")
                            OverallBulletList(items: info.important)
                        }
                        Spacer(minLength: 0)
                    }
                    .padding(16)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            .containerBackground(.white.gradient, for: .widget)
        }
    }
}

private struct OverallTaskDetailColumn: View {
    let info: OverallTaskInfo
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            OverallHeaderRow(title: info.title)
            Divider()
            OverallSectionHeader(title: "Goal")
            OverallBulletList(items: [info.goal])
            Divider()
            OverallSectionHeader(title: "Task Important")
            OverallBulletList(items: info.important)
            Spacer(minLength: 0)
        }
        .padding(16)
    }
}

// MARK: - Reusable bits (namespaced to avoid clashes)

private struct OverallHeaderRow: View {
    let title: String
    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: "cube.box.fill")
                .imageScale(.large)
                .accessibilityHidden(true)
            Text(title)
                .font(.system(size: 22, weight: .semibold))
                .lineLimit(1)
                .minimumScaleFactor(0.8)
        }
    }
}

private struct OverallSectionHeader: View {
    let title: String
    var body: some View {
        Text(title)
            .font(.system(size: 14, weight: .semibold))
            .textCase(.none)
            .accessibilityAddTraits(.isHeader)
    }
}

private struct OverallBulletList: View {
    let items: [String]
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            ForEach(items.indices, id: \.self) { i in
                HStack(alignment: .firstTextBaseline, spacing: 6) {
                    Text("•").accessibilityHidden(true)
                    Text(items[i]).fixedSize(horizontal: false, vertical: true)
                }
            }
        }
        .font(.system(size: 12))
    }
}

// MARK: - Widget

struct OverallTaskInfoWidget: Widget {
    let kind = "OverallTaskInfoWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: OverallTaskProvider()) { entry in
            OverallTaskCardView(info: entry.info)
        }
        .configurationDisplayName("Overall Task Info")
        .description("Common task: Goal and Task Important for building the GPT.")
        .supportedFamilies([.systemExtraLargePortrait])
        .supportedMountingStyles([.elevated])
        .widgetTexture(.paper)
    }
}
