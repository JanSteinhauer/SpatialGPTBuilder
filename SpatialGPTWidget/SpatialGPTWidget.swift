//
//  SpatialGPTWidget.swift
//  SpatialGPTWidget
//
//  Created by Steinhauer, Jan on 12.10.25.
//

import WidgetKit
import SwiftUI

struct LLMInfo: Hashable {
    let id: UUID = .init()
    let title: String
    let logoName: String
    let overviewHeader: String
    let overviewBullets: [String]
    let securityHeader: String
    let securityBullets: [String]
    let footer: String
    
    static func forChoice(_ choice: LLMChoice) -> LLMInfo {
        switch choice {
        case .chatgpt:
            return LLMInfo(
                title: "ChatGPT",
                logoName: "ChatGPT",
                overviewHeader: "Overview",
                overviewBullets: [
                    "Powerful model",
                    "Widely used",
                    "Based on US infrastructure"
                ],
                securityHeader: "Security Overview",
                securityBullets: [
                    "Medium",
                    "Data processing occurs outside the EU"
                ],
                footer: "ChatGPT is an AI chatbot that understands and generates human-like text."
            )
        case .anthropic:
            return LLMInfo(
                title: "Claude",
                logoName: "Anthropic",
                overviewHeader: "Overview",
                overviewBullets: [
                    "Powerful model",
                    "Very secure",
                    "Produces reliable statements"
                ],
                securityHeader: "Security Overview",
                securityBullets: [
                    "High",
                    "Withholds sensitive data",
                    "GDPR-friendly"
                ],
                footer: "Claude is an AI chatbot that understands and generates human-like text."
            )
        }
    }
}

// MARK: - Timeline

struct LLMEntry: TimelineEntry {
    let date: Date
    let config: LLMConfigurationIntent
    let info: LLMInfo
}

struct LLMProvider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> LLMEntry {
        // Use any demo choice here; config itself can be default-inited
        let demoChoice: LLMChoice = .chatgpt
        return LLMEntry(date: .now,
                        config: LLMConfigurationIntent(),
                        info: .forChoice(demoChoice))
    }

    func snapshot(for configuration: LLMConfigurationIntent, in context: Context) async -> LLMEntry {
        LLMEntry(date: .now, config: configuration, info: .forChoice(configuration.provider))
    }

    func timeline(for configuration: LLMConfigurationIntent, in context: Context) async -> Timeline<LLMEntry> {
        let start = Date()
        let entries = (0..<5).map { h in
            LLMEntry(date: Calendar.current.date(byAdding: .hour, value: h, to: start)!,
                     config: configuration,
                     info: .forChoice(configuration.provider))
        }
        return Timeline(entries: entries, policy: .atEnd)
    }
}

// MARK: - Views

struct LLMCardView: View {
    let info: LLMInfo
    @Environment(\.levelOfDetail) private var lod
    
    var body: some View {
        switch lod {
        case .simplified:
            simplifiedView
        default:
            detailedView
        }
    }
    
    private var simplifiedView: some View {
        VStack(spacing: 8) {
            Image(info.logoName)
                .resizable()
                .scaledToFit()
                .frame(maxWidth: 48, maxHeight: 48)
                .accessibilityHidden(true)
            
            Text(info.title)
                .font(.headline)
                .lineLimit(1)
                .minimumScaleFactor(0.8)
                .accessibilityLabel("\(info.title) widget")
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        .padding(8)
    }
    
    private var detailedView: some View {
        VStack(alignment: .leading, spacing: 10) {
            // HStack with logo then title
            HStack(alignment: .center, spacing: 10) {
                Image(info.logoName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 28, height: 28)
                    .accessibilityHidden(true)
                
                Text(info.title)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
            }
            
            Divider()
            
            // Overview
            SectionHeader(title: info.overviewHeader)
            BulletList(items: info.overviewBullets)
            
            Divider()
            
            // Security
            SectionHeader(title: info.securityHeader)
            BulletList(items: info.securityBullets)
            
            Divider()
            
            // Footer text
            Text(info.footer)
                .font(.footnote)
                .fixedSize(horizontal: false, vertical: true)
                .lineLimit(3)
                .minimumScaleFactor(0.9)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .padding(12)
    }
}

private struct SectionHeader: View {
    let title: String
    var body: some View {
        Text(title)
            .font(.subheadline)
            .fontWeight(.semibold)
            .textCase(.none)
            .accessibilityAddTraits(.isHeader)
    }
}

private struct BulletList: View {
    let items: [String]
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            ForEach(items.indices, id: \.self) { i in
                HStack(alignment: .firstTextBaseline, spacing: 6) {
                    Text("•")
                        .font(.body)
                        .accessibilityHidden(true)
                    Text(items[i])
                        .font(.body)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
        }
    }
}

// MARK: - Widget

struct SpatialLLMWidget: Widget {
    let kind: String = "SpatialLLMWidget"
    
    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: LLMConfigurationIntent.self, provider: LLMProvider()) { entry in
            LLMCardView(info: entry.info)
                .containerBackground(.white.gradient, for: .widget)
        }
        .configurationDisplayName("LLM Overview")
        .description("At a glance LLM + security overview.")
        .supportedFamilies([.systemSmall])
        .supportedMountingStyles([.elevated])
        .widgetTexture(.paper)
    }
}
