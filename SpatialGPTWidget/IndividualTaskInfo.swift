//
//  IndividualTaskInfo.swift
//  SpatialGPTWidgetExtension
//
//  Created by Steinhauer, Jan on 18.10.25.
//

import WidgetKit
import SwiftUI
import AppIntents


struct IndividualTaskConfigurationIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource { "Individual Task" }
    static var description: IntentDescription { "Choose Finance or Security task." }

    @Parameter(title: "Task", default: .finance)
    var task: IndividualTaskKind
}

// MARK: - Model

struct IndividualTaskInfo: Hashable {
    let title: String
    let goal: String
    let kpis: [String]
    let good: [String]
    let required: [String]
    let noGos: [String]

    static func forKind(_ kind: IndividualTaskKind) -> IndividualTaskInfo {
        switch kind {
        case .finance:
            return IndividualTaskInfo(
                title: "Finance Task",
                goal: "Minimize total cost while maintaining good-enough answer quality for business use.",
                kpis: [
                    "Blended price / 1K tokens ≤ $0.010",
                    "Avg tokens / query (in+out) ≤ 2,000",
                    "Cost / query ≤ $0.020",
                    "Monthly spend within ±10% of budget",
                    "≥ 70% requests on low-cost tier",
                    "Cache hit rate ≥ 35%",
                    "RAG pipeline cost share ≤ 25% of total",
                    "Adoption per € (MAU / monthly €) ≥ 1.5"
                ],
                good: [
                    "Route routine queries to low-cost tier; upscale only when needed",
                    "Prefer RAG for freshness vs fine-tuning cost",
                    "Enforce token caps, summaries, and batching"
                ],
                required: [
                    "Daily cost dashboard & alerts at 50/80/100%",
                    "Pricing table synced to model versions",
                    "FinOps review for fine-tuning or private/local deployments"
                ],
                noGos: [
                    "Uncapped Free Use without quotas",
                    "Defaulting batch jobs to premium tier",
                    "Ignoring residency to save costs on sensitive data"
                ]
            )
        case .security:
            return IndividualTaskInfo(
                title: "Security Task",
                goal: "Prevent data leakage and meet GDPR while keeping the system usable.",
                kpis: [
                    "Requests processed in DE/EU ≥ 98%",
                    "Sensitive-data exposure incidents: 0 per 10,000 requests",
                    "Moderation/DLP block rate: 1–5 per 1,000 (≤ 2% false positives)",
                    "MFA coverage: 100% of active users",
                    "Log/data retention ≤ 14 days for user content",
                    "Users on least-privilege RBAC ≥ 95%",
                    "Third-party processing (sensitive workloads) ≤ 5%",
                ],
                good: [
                    "Role-based access with scoped policies",
                    "Privacy-by-default (no storage of personal prompts)",
                    "Moderation on inputs and outputs"
                ],
                required: [
                    "MFA and secrets rotation; DPAs for external processing",
                    "Redacted logging with purpose-limited retention",
                    "Human-in-the-loop for high-risk actions"
                ],
                noGos: [
                    "Global hosting for regulated/sensitive data",
                    "Fine-tuning on personal/confidential data without legal sign-off",
                    "Free Use in production without moderation and RBAC"
                ]
            )
        }
    }
}

// MARK: - Timeline

struct IndividualTaskEntry: TimelineEntry {
    let date: Date
    let config: IndividualTaskConfigurationIntent
    let info: IndividualTaskInfo
}

struct IndividualTaskProvider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> IndividualTaskEntry {
        IndividualTaskEntry(date: .now,
                            config: IndividualTaskConfigurationIntent(),
                            info: .forKind(.finance))
    }

    func snapshot(for configuration: IndividualTaskConfigurationIntent, in context: Context) async -> IndividualTaskEntry {
        IndividualTaskEntry(date: .now,
                            config: configuration,
                            info: .forKind(configuration.task))
    }

    func timeline(for configuration: IndividualTaskConfigurationIntent, in context: Context) async -> Timeline<IndividualTaskEntry> {
        let start = Date()
        let entries = (0..<3).compactMap { h in
            IndividualTaskEntry(date: Calendar.current.date(byAdding: .hour, value: h, to: start)!,
                                config: configuration,
                                info: .forKind(configuration.task))
        }
        return Timeline(entries: entries, policy: .atEnd)
    }
}

// MARK: - Views

struct IndividualTaskCardView: View {
    let info: IndividualTaskInfo
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
        VStack(alignment: .leading, spacing: 8) {
            HeaderRow(title: info.title)

            Divider()
            SectionHeader(title: "Goal")
            BulletList(items: [info.goal])

            Divider()
            SectionHeader(title: "KPI Responsible For")
            BulletList(items: info.kpis)

            Divider()
            SectionHeader(title: "Good")
            BulletList(items: info.good)

            Divider()
            SectionHeader(title: "Required")
            BulletList(items: info.required)

//            Divider()
//            SectionHeader(title: "No-Gos")
//            BulletList(items: info.noGos)

            Spacer(minLength: 0)
        }
        .padding(16)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .containerBackground(.white.gradient, for: .widget)
    }

    private var detailedView: some View {
        VStack(alignment: .leading, spacing: 8) {
            HeaderRow(title: info.title)

            Divider()
            SectionHeader(title: "Goal")
            BulletList(items: [info.goal])

            Divider()
            SectionHeader(title: "KPI Responsible For")
            BulletList(items: info.kpis)

            Divider()
            SectionHeader(title: "Good")
            BulletList(items: info.good)

            Divider()
            SectionHeader(title: "Required")
            BulletList(items: info.required)

//            Divider()
//            SectionHeader(title: "No-Gos")
//            BulletList(items: info.noGos)

            Spacer(minLength: 0)
        }
        .padding(16)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .containerBackground(.white.gradient, for: .widget)
    }
}

// MARK: - Reusable UI bits (scoped)

private struct HeaderRow: View {
    let title: String
    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: "checklist")
                .imageScale(.large)
                .accessibilityHidden(true)
            Text(title)
                .font(.system(size: 22, weight: .semibold))
                .lineLimit(1)
                .minimumScaleFactor(0.8)
        }
    }
}

private struct SectionHeader: View {
    let title: String
    var body: some View {
        Text(title)
            .font(.system(size: 14, weight: .semibold))
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
                    Text("•").accessibilityHidden(true)
                    Text(items[i])
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
        }
        .font(.system(size: 12))
    }
}

// MARK: - Widget

struct IndividualTaskWidget: Widget {
    let kind = "IndividualTaskWidget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind,
                               intent: IndividualTaskConfigurationIntent.self,
                               provider: IndividualTaskProvider()) { entry in
            IndividualTaskCardView(info: entry.info)
        }
        .configurationDisplayName("Individual Task")
        .description("Focus on Finance or Security KPIs and goals.")
        .supportedFamilies([.systemExtraLargePortrait])
        .supportedMountingStyles([.elevated])
        .widgetTexture(.paper)
    }
}
