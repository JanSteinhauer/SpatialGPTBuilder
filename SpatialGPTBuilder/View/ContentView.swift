//
//  ContentView.swift
//  SpatialGPTBuilder
//
//  Created by Steinhauer, Jan on 12.10.25.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.openWindow) private var openWindow
    @Environment(\.openImmersiveSpace) private var openImmersiveSpace
    @EnvironmentObject private var sync: FirestoreSync

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Spacer()
                Text("AI Integration Workflow")
                    .font(.system(size: 40))
                    .font(.largeTitle.bold())
                    .padding(.horizontal)
                    .padding(.top)
                Spacer()

//                Button {
//                    Task { await clearDatabase() }
//                } label: {
//                    HStack(spacing: 8) {
//                        Image(systemName: "trash")
//                        Text("Clear DB")
//                    }
//                }
//                .buttonStyle(.borderedProminent)
//                .tint(.red)
//                .padding(.trailing)
            }

            AIIntegrationWorkflowDiagram()
                .padding(.horizontal)
        }
        .onAppear {
            openWindow(id: "current_result")
            openWindow(id: "building_block_picker")
        }
    }

    // MARK: - Clear DB Action
    private func clearDatabase() async {
        do {
            let now = ISO8601DateFormatter().string(from: Date())

            // Get current snapshot
            let snap = sync.workflow.makeSnapshot()

            // Build same structure, but clear all OptionItem strings
            var clearedSelections: [String: FirestoreREST.FirestoreValue] = [:]
            for (category, option) in snap.selections {
                clearedSelections[category.rawValue] = .map([
                    "id": .string(""),
                    "displayName": .string(""),
                    "assetName": .string("")
                ])
            }

            let fields: [String: FirestoreREST.FirestoreValue] = [
                "revision": .integer(Int64(snap.revision + 1)),
                "pickingCategory": .string(""),
                "pendingSelection": .null,
                "selections": .map(clearedSelections),
                "updatedAt": .timestamp(now)
            ]

            try await sync.rest.patchDocument(fields: fields, updateMask: Array(fields.keys))
            print("🧹 [ClearDB] Cleared OptionItem values successfully.")
        } catch {
            print("❌ [ClearDB] Failed to clear OptionItem values:", error)
        }
    }

}

#Preview(windowStyle: .automatic) {
    ContentView()
}
