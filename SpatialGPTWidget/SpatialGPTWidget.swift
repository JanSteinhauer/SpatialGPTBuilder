//
//  SpatialGPTWidget.swift
//  SpatialGPTWidget
//
//  Created by Steinhauer, Jan on 12.10.25.
//

import WidgetKit
import SwiftUI

enum LLMFlavor { case security, finance }

// MARK: - View Model

struct LLMInfo: Hashable {
    let id: UUID = .init()
    let title: String
    let logoName: String
    let overviewHeader: String
    let overviewBullets: [String]
    let securityHeader: String
    let securityBullets: [String]
    let footer: String

    static func forChoice(_ choice: LLMChoice, flavor: LLMFlavor) -> LLMInfo {
        switch (choice, flavor) {

        case (.chatgpt, .security):
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

        case (.chatgpt, .finance):
            return LLMInfo(
                title: "ChatGPT",
                logoName: "ChatGPT",
                overviewHeader: "Overview",
                overviewBullets: [
                    "Powerful model",
                    "Widely used",
                    "Based on US infrastructure"
                ],
                securityHeader: "Financial Overview",
                securityBullets: [
                    "High API costs",
                    "$0.01–$0.06 per 1,000 tokens",
                    "High costs for continuous use"
                ],
                footer: "ChatGPT is an AI chatbot that understands and generates human-like text."
            )

        case (.anthropic, .security):
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

        case (.anthropic, .finance):
            return LLMInfo(
                title: "Claude",
                logoName: "Anthropic",
                overviewHeader: "Overview",
                overviewBullets: [
                    "Powerful model",
                    "Very secure",
                    "Produces reliable statements"
                ],
                securityHeader: "Financial Overview",
                securityBullets: [
                    "Medium",
                    "$0.005–$0.03 per 1,000 tokens"
                ],
                footer: "Claude is an AI chatbot that understands and generates human-like text."
            )
        }
    }
}

// MARK: - Timeline Entries

struct LLMEntry: TimelineEntry {
    let date: Date
    let config: LLMConfigurationIntent
    let info: LLMInfo
}

// MARK: - Providers (one per flavor)

struct SecurityLLMProvider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> LLMEntry {
        LLMEntry(date: .now,
                 config: LLMConfigurationIntent(),
                 info: .forChoice(.chatgpt, flavor: .security))
    }

    func snapshot(for configuration: LLMConfigurationIntent, in context: Context) async -> LLMEntry {
        LLMEntry(date: .now,
                 config: configuration,
                 info: .forChoice(configuration.provider, flavor: .security))
    }

    func timeline(for configuration: LLMConfigurationIntent, in context: Context) async -> Timeline<LLMEntry> {
        let start = Date()
        let entries = (0..<5).map { h in
            LLMEntry(date: Calendar.current.date(byAdding: .hour, value: h, to: start)!,
                     config: configuration,
                     info: .forChoice(configuration.provider, flavor: .security))
        }
        return Timeline(entries: entries, policy: .atEnd)
    }
}

struct FinanceLLMProvider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> LLMEntry {
        LLMEntry(date: .now,
                 config: LLMConfigurationIntent(),
                 info: .forChoice(.chatgpt, flavor: .finance))
    }

    func snapshot(for configuration: LLMConfigurationIntent, in context: Context) async -> LLMEntry {
        LLMEntry(date: .now,
                 config: configuration,
                 info: .forChoice(configuration.provider, flavor: .finance))
    }

    func timeline(for configuration: LLMConfigurationIntent, in context: Context) async -> Timeline<LLMEntry> {
        let start = Date()
        let entries = (0..<5).map { h in
            LLMEntry(date: Calendar.current.date(byAdding: .hour, value: h, to: start)!,
                     config: configuration,
                     info: .forChoice(configuration.provider, flavor: .finance))
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
                .frame(maxWidth: 60, maxHeight: 60)
                .accessibilityHidden(true)

            Text(info.title)
                .font(.system(size: 30, weight: .bold))
                .lineLimit(1)
                .minimumScaleFactor(0.8)
                .accessibilityLabel("\(info.title) widget")
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(8)
    }

    private var detailedView: some View {
        VStack(alignment: .leading, spacing: 2) {
            Spacer(minLength: 0)

            HStack(alignment: .center, spacing: 10) {
                Image(info.logoName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                    .accessibilityHidden(true)
                
                Text(info.title)
                    .font(.system(size: 14))
                    .fontWeight(.semibold)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
            }

            Divider()

            SectionHeader(title: info.overviewHeader)
            BulletList(items: info.overviewBullets)

            Divider()

            SectionHeader(title: info.securityHeader)
            BulletList(items: info.securityBullets)

            Divider()

            Text(info.footer)
                .font(.system(size: 7))
                .fixedSize(horizontal: false, vertical: true)
                .lineLimit(3)
                .minimumScaleFactor(0.9)

            Spacer(minLength: 0)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    }
}

private struct SectionHeader: View {
    let title: String
    var body: some View {
        Text(title)
            .font(.system(size: 9))
            .fontWeight(.semibold)
            .textCase(.none)
            .accessibilityAddTraits(.isHeader)
    }
}

private struct BulletList: View {
    let items: [String]
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ForEach(items.indices, id: \.self) { i in
                HStack(alignment: .firstTextBaseline, spacing: 2) {
                    Text("•").accessibilityHidden(true)
                    Text(items[i]).fixedSize(horizontal: false, vertical: true)
                }
            }
        }
        .font(.system(size: 7))
        .padding(.top, 0)
    }
}

// MARK: - Widgets (exactly two)

struct SecurityLLMWidget: Widget {
    let kind = "SecurityLLMWidget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind,
                               intent: LLMConfigurationIntent.self,
                               provider: SecurityLLMProvider()) { entry in
            LLMCardView(info: entry.info)
                .containerBackground(.white.gradient, for: .widget)
        }
        .configurationDisplayName("LLM – Security")
        .description("Security overview for ChatGPT or Claude.")
        .supportedFamilies([.systemSmall])
        .supportedMountingStyles([.elevated])
        .widgetTexture(.paper)
    }
}

struct FinanceLLMWidget: Widget {
    let kind = "FinanceLLMWidget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind,
                               intent: LLMConfigurationIntent.self,
                               provider: FinanceLLMProvider()) { entry in
            LLMCardView(info: entry.info)
                .containerBackground(.white.gradient, for: .widget)
        }
        .configurationDisplayName("LLM – Finance")
        .description("Financial overview for ChatGPT or Claude.")
        .supportedFamilies([.systemSmall])
        .supportedMountingStyles([.elevated])
        .widgetTexture(.paper)
    }
}
