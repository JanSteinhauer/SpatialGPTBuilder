//
//  CategoryHeader.swift
//  SpatialGPTWidgetExtension
//
//  Created by Steinhauer, Jan on 20.10.25.
//

import WidgetKit
import SwiftUI
import AppIntents

enum CategoryKind: String, AppEnum {
    case hostingCountry
    case dataSource
    case interface
    case accessControl
    case infrastructure
    case dataPrivacy
    case integration
    case aiModel

    static var typeDisplayRepresentation: TypeDisplayRepresentation = "Category"

    static var caseDisplayRepresentations: [CategoryKind : DisplayRepresentation] = [
        .hostingCountry: "Hosting Country",
        .dataSource: "Data Source",
        .interface: "Interface",
        .accessControl: "Access Control",
        .infrastructure: "Infrastructure",
        .dataPrivacy: "Data Privacy",
        .integration: "Integration",
        .aiModel: "AI Model"
    ]
}

// MARK: - Intent

struct CategoryHeaderConfigurationIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource { "Category Header" }
    static var description: IntentDescription { "Choose a category label to display." }

    @Parameter(title: "Category", default: .hostingCountry)
    var category: CategoryKind
}

// MARK: - Model

struct CategoryHeaderInfo: Hashable {
    let title: String

    static func forKind(_ kind: CategoryKind) -> CategoryHeaderInfo {
        switch kind {
        case .hostingCountry: return .init(title: "Hosting Country")
        case .dataSource:     return .init(title: "Data Source")
        case .interface:      return .init(title: "Interface")
        case .accessControl:  return .init(title: "Access Control")
        case .infrastructure: return .init(title: "Infrastructure")
        case .dataPrivacy:    return .init(title: "Data Privacy")
        case .integration:    return .init(title: "Integration")
        case .aiModel:        return .init(title: "AI Model")
        }
    }
}

// MARK: - Timeline

struct CategoryHeaderEntry: TimelineEntry {
    let date: Date
    let config: CategoryHeaderConfigurationIntent
    let info: CategoryHeaderInfo
}

struct CategoryHeaderProvider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> CategoryHeaderEntry {
        CategoryHeaderEntry(date: .now,
                            config: CategoryHeaderConfigurationIntent(),
                            info: .forKind(.hostingCountry))
    }

    func snapshot(for configuration: CategoryHeaderConfigurationIntent, in context: Context) async -> CategoryHeaderEntry {
        CategoryHeaderEntry(date: .now,
                            config: configuration,
                            info: .forKind(configuration.category))
    }

    func timeline(for configuration: CategoryHeaderConfigurationIntent, in context: Context) async -> Timeline<CategoryHeaderEntry> {
        let now = Date()
        let entries = [CategoryHeaderEntry(date: now,
                                           config: configuration,
                                           info: .forKind(configuration.category))]
        return Timeline(entries: entries, policy: .never)
    }
}

// MARK: - View (same for close-up and far-away)

struct CategoryHeaderCardView: View {
    let info: CategoryHeaderInfo
    @Environment(\.widgetFamily) private var family

    var body: some View {
        ZStack {
            Rectangle()
                .fill(.white.gradient)
                .opacity(0.98)

            VStack(spacing: 8) {
                Text(info.title)
                    .font(.system(size: preferredFontSize, weight: .semibold))
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .minimumScaleFactor(0.6)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.horizontal, 8)
            }
            .padding(16)
        }
        .containerBackground(.white.gradient, for: .widget)
    }

    private var preferredFontSize: CGFloat {
        switch family {
        case .systemSmall: return 22
        case .systemMedium: return 26
        case .systemLarge: return 30
        case .systemExtraLarge, .systemExtraLargePortrait: return 34
        default: return 28
        }
    }
}

// MARK: - Widget

struct CategoryHeaderWidget: Widget {
    let kind = "CategoryHeaderWidget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind,
                               intent: CategoryHeaderConfigurationIntent.self,
                               provider: CategoryHeaderProvider()) { entry in
            CategoryHeaderCardView(info: entry.info)
        }
        .configurationDisplayName("Category Header")
        .description("Displays the selected category title (same near/far view).")
        .supportedFamilies([.systemSmall])
        .supportedMountingStyles([.elevated])
        .widgetTexture(.paper)
    }
}
