//
//  WorkflowSharing.swift
//  SpatialGPTBuilder
//
//  Created by Steinhauer, Jan on 02.11.25.
//

import Foundation
import GroupActivities

// 1) What we send across the wire
struct WorkflowSnapshot: Codable, Sendable, Equatable {
    var selections: [Category: OptionItem]
    var pickingCategory: Category?
    var pendingSelection: OptionItem?
    var revision: Int      // monotonically increasing

    static let empty = WorkflowSnapshot(selections: [:], pickingCategory: nil, pendingSelection: nil, revision: 0)
}

// 2) Your activity (what shows in the SharePlay sheet)
struct WorkflowActivity: GroupActivity {
    static let activityIdentifier = "com.spatialgptbuilder.workflow"

    var metadata: GroupActivityMetadata {
        var m = GroupActivityMetadata()
        m.title = "SpatialGPT Builder"
        m.subtitle = "AI Integration Workflow"
        m.type = .generic
        return m
    }
}
