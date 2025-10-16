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
            
        case (.gemini, .security):
            return LLMInfo(
                title: "Gemini",
                logoName: "Gemini",
                overviewHeader: "Overview",
                overviewBullets: [
                    "Integrated into the Google ecosystem",
                    "Strong at multimodal input",
                    "Can generate images"
                ],
                securityHeader: "Security Overview",
                securityBullets: [
                    "Medium",
                    "Google Cloud security standards",
                    "Hosting in the USA"
                ],
                footer: "Gemini is an AI chatbot that understands and generates human-like text."
            )

        case (.gemini, .finance):
            return LLMInfo(
                title: "Gemini",
                logoName: "Gemini",
                overviewHeader: "Overview",
                overviewBullets: [
                    "Integrated into the Google ecosystem",
                    "Strong at multimodal input",
                    "Can generate images"
                ],
                securityHeader: "Financial Overview",
                securityBullets: [
                    "Low",
                    "$0.002–$0.01 per 1,000 tokens",
                    "Useful if you are a Google customer"
                ],
                footer: "Gemini is an AI chatbot that understands and generates human-like text."
            )
            
        case (.llama, .security):
                    return LLMInfo(
                        title: "Llama",
                        logoName: "Llama",
                        overviewHeader: "Overview",
                        overviewBullets: [
                            "Powerful open-source LLM",
                            "Runs locally or in a private cloud",
                            "Flexible deployment and tuning"
                        ],
                        securityHeader: "Security Overview",
                        securityBullets: [
                            "High",
                            "Full data control when self-hosted",
                            "No third-party data processing by default"
                        ],
                        footer: "Llama is an open-source family of models that can be deployed on your own infrastructure."
                    )

                case (.llama, .finance):
                    return LLMInfo(
                        title: "Llama",
                        logoName: "Llama",
                        overviewHeader: "Overview",
                        overviewBullets: [
                            "Powerful open-source LLM",
                            "Runs locally or in a private cloud",
                            "Flexible deployment and tuning"
                        ],
                        securityHeader: "Financial Overview",
                        securityBullets: [
                            "Medium",
                            "No ongoing API fees; own hardware needed",
                            "Performance and cost depend on your hardware"
                        ],
                        footer: "Llama is an open-source family of models that can be deployed on your own infrastructure."
                    )

                case (.gemma, .security):
                    return LLMInfo(
                        title: "Gemma",
                        logoName: "Gemma",
                        overviewHeader: "Overview",
                        overviewBullets: [
                            "Lightweight model from Google",
                            "Can run locally or in a private cloud",
                            "Integrates well with Google Cloud"
                        ],
                        securityHeader: "Security Overview",
                        securityBullets: [
                            "High",
                            "No data sent to Google when self-hosted",
                            "Full control over data flows"
                        ],
                        footer: "Gemma is a lightweight model designed for efficient local or private-cloud deployments."
                    )

                case (.gemma, .finance):
                    return LLMInfo(
                        title: "Gemma",
                        logoName: "Gemma",
                        overviewHeader: "Overview",
                        overviewBullets: [
                            "Lightweight model from Google",
                            "Can run locally or in a private cloud",
                            "Integrates well with Google Cloud"
                        ],
                        securityHeader: "Financial Overview",
                        securityBullets: [
                            "Medium",
                            "No recurring API costs when self-hosted; hardware required",
                            "Lower quality than Gemini but cost-efficient"
                        ],
                        footer: "Gemma is a lightweight model designed for efficient local or private-cloud deployments."
                    )
        case (.standaloneWebApp, .security):
            return LLMInfo(
                title: "Standalone Web App",
                logoName: "titel",
                overviewHeader: "Overview",
                overviewBullets: [
                    "Separate platform",
                    "Easy browser access",
                    "No installation required"
                ],
                securityHeader: "Security Overview",
                securityBullets: [
                    "Medium",
                    "Few attack surfaces but limited control",
                    "Hard to embed data from other tools"
                ],
                footer: "A standalone web app runs in the browser and needs no local setup."
            )

        case (.standaloneWebApp, .finance):
            return LLMInfo(
                title: "Standalone Web App",
                logoName: "titel",
                overviewHeader: "Overview",
                overviewBullets: [
                    "Separate platform",
                    "Easy browser access",
                    "No installation required"
                ],
                securityHeader: "Financial Overview",
                securityBullets: [
                    "Low cost",
                    "Quick to deploy",
                    "Minimal setup"
                ],
                footer: "Inexpensive and fast to launch from any browser."
            )

        // --- API Integration ---
        case (.apiIntegration, .security):
            return LLMInfo(
                title: "API Integration",
                logoName: "titel",
                overviewHeader: "Overview",
                overviewBullets: [
                    "Integrates into existing tools",
                    "Seamless daily workflow",
                    "Requires integration effort"
                ],
                securityHeader: "Security Overview",
                securityBullets: [
                    "Medium",
                    "Depends on API access control",
                    "Interfaces can introduce vulnerabilities"
                ],
                footer: "Connects AI directly into enterprise tools via APIs."
            )

        case (.apiIntegration, .finance):
            return LLMInfo(
                title: "API Integration",
                logoName: "titel",
                overviewHeader: "Overview",
                overviewBullets: [
                    "Integrates into existing tools",
                    "Seamless daily workflow",
                    "Requires integration effort"
                ],
                securityHeader: "Financial Overview",
                securityBullets: [
                    "Medium",
                    "Implementation adds some cost",
                    "Long-term efficiency benefits"
                ],
                footer: "Requires dev work but streamlines workflows."
            )

        // --- Mobile App / Intranet ---
        case (.mobileApp, .security):
            return LLMInfo(
                title: "Mobile App / Intranet",
                logoName: "titel",
                overviewHeader: "Overview",
                overviewBullets: [
                    "Mobile or intranet availability",
                    "High user convenience",
                    "Accessible from anywhere"
                ],
                securityHeader: "Security Overview",
                securityBullets: [
                    "Low",
                    "Endpoint usage increases risk",
                    "More device-based vulnerabilities"
                ],
                footer: "Flexible but comes with higher endpoint security risks."
            )

        case (.mobileApp, .finance):
            return LLMInfo(
                title: "Mobile App / Intranet",
                logoName: "titel",
                overviewHeader: "Overview",
                overviewBullets: [
                    "Mobile or intranet availability",
                    "High user convenience",
                    "Accessible from anywhere"
                ],
                securityHeader: "Financial Overview",
                securityBullets: [
                    "Medium",
                    "Moderate setup & maintenance",
                    "Convenience boosts productivity"
                ],
                footer: "Cost-efficient and very convenient for daily use."
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

    private var isTitleOnly: Bool { info.logoName == "titel" }

        var body: some View {
            switch lod {
            case .simplified: simplifiedView
            default: detailedView
            }
        }

        private var simplifiedView: some View {
            Group {
                if isTitleOnly {
                    Text(info.title)
                        .font(.system(size: 30, weight: .bold))
                        .lineLimit(2)
                        .minimumScaleFactor(0.8)
                        .accessibilityLabel("\(info.title) widget")
                } else {
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
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(8)
        }

        private var detailedView: some View {
            VStack(alignment: .leading, spacing: 2) {
                Spacer(minLength: 0)

                HStack(alignment: .center, spacing: 10) {
                    if !isTitleOnly {
                        Image(info.logoName)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24, height: 24)
                            .accessibilityHidden(true)
                    }
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
        .description("Security overview for ChatGPT, Claude, or Gemini.")
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
        .description("Financial overview for ChatGPT, Claude, or Gemini.")
        .supportedFamilies([.systemSmall])
        .supportedMountingStyles([.elevated])
        .widgetTexture(.paper)
    }
}
