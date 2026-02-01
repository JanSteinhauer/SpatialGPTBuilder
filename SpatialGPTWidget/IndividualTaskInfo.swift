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
                title: "Finance Aufgabe",
                goal: "Wir wollen die Kosten so niedrig wie möglich halten, ohne dass die Antworten für den Arbeitsalltag zu schlecht werden.",
                kpis: [
                    "Kosten sollen planbar und stabil bleiben",
                    "Günstige Optionen werden so oft wie möglich genutzt",
                    "Teure Optionen nur, wenn sie wirklich notwendig sind",
                ],
                good: [
                    "Einfache und wiederkehrende Anfragen zuerst über günstige Modelle abwickeln",
                    "Teurere Modelle nur bei höherem Qualitätsbedarf einsetzen",
                    "Aktuelle Informationen lieber über Dokumentenabruf (RAG) holen statt über teures Training",
                ],
                required: [
                    "Tägliche Übersicht über die laufenden Kosten",
                    "Frühe Warnungen bei steigenden Ausgaben",
                    "Klare Regeln, wer kostenintensive Optionen nutzen darf",
                    "Kostenprüfung vor größeren technischen Entscheidungen"
                ],
                noGos: [
                    "Automatischer Einsatz teurer Modelle für einfache Aufgaben",
                    "Kosteneinsparungen auf Kosten von Datenschutz oder Compliance"
                ]
            )
            
        case .security:
            return IndividualTaskInfo(
                title: "Security Task",
                goal: "Wir wollen verhindern, dass Daten nach außen gelangen, und gleichzeitig die DSGVO einhalten, ohne das System unnötig kompliziert zu machen.",
                kpis: [
                  "Daten und Anfragen bleiben überwiegend innerhalb von Deutschland oder der EU",
                  "Keine Vorfälle, bei denen sensible Daten unbeabsichtigt offengelegt werden",
                  "Alle aktiven Nutzer sind durch eine zusätzliche Anmeldungssicherung geschützt",
                  "Zugriffsrechte sind auf das absolut notwendige Minimum beschränkt",
                ],
                good: [
                  "Zugriffe sind rollenbasiert und klar eingeschränkt",
                  "Datenschutz ist standardmäßig aktiviert (keine unnötige Speicherung von Eingaben)",
                ],
                required: [
                  "Mehrstufige Anmeldung und regelmäßiger Austausch von Zugangsdaten",
                  "Protokolle enthalten nur anonymisierte oder gekürzte Daten und werden zeitlich begrenzt gespeichert",
                  "Kritische oder risikoreiche Aktionen werden zusätzlich von Menschen geprüft"
                ],
                noGos: [
                  "Weltweites Hosting für regulierte oder sensible Daten",
                  "Training oder Nachschärfen von Modellen mit personenbezogenen oder vertraulichen Daten ohne rechtliche Freigabe",
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
            SectionHeader(title: "Ziel")
            BulletList(items: [info.goal])

            Divider()
            SectionHeader(title: "Erfolgskennzahlen")
            BulletList(items: info.kpis)

            Divider()
            SectionHeader(title: "Gut")
            BulletList(items: info.good)

            Divider()
            SectionHeader(title: "Erforderlich")
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
