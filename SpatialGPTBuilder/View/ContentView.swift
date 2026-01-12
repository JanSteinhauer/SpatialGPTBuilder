//
//  ContentView.swift
//  SpatialGPTBuilder
//
//  Created by Steinhauer, Jan on 12.10.25.
//

import SwiftUI
import UniformTypeIdentifiers

struct ContentView: View {
    @Environment(\.openWindow) private var openWindow
    @Environment(\.openImmersiveSpace) private var openImmersiveSpace
    @EnvironmentObject private var sync: FirestoreSync
    
    @State private var showFileExporter = false
    @State private var logContent = ""

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
//                Button {
//                    Task { await downloadLogs() }
//                } label: {
//                    HStack(spacing: 8) {
//                        Image(systemName: "arrow.down.doc")
//                        Text("Download Logs")
//                    }
//                }
//                .buttonStyle(.bordered)
//                .padding(.trailing)
            }

            AIIntegrationWorkflowDiagram()
                .padding(.horizontal)
        }
        .onAppear {
            openWindow(id: "current_result")
            openWindow(id: "building_block_picker")
        }
        .fileExporter(
            isPresented: $showFileExporter,
            document: LogDocument(message: logContent),
            contentType: .json,
            defaultFilename: "firestore_logs.json"
        ) { result in
            switch result {
            case .success(let url):
                print("Saved to \(url)")
            case .failure(let error):
                print(error.localizedDescription)
            }
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



    // MARK: - Download Logs
    private func downloadLogs() async {
        do {
            let docs = try await sync.rest.listDocuments(collection: "logging")
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            let data = try encoder.encode(docs)
            logContent = String(data: data, encoding: .utf8) ?? "[]"
            showFileExporter = true
        } catch {
            print("❌ Failed to download logs: \(error)")
        }
    }
}

struct LogDocument: FileDocument {
    static var readableContentTypes: [UTType] { [.json] }
    var message: String

    init(message: String) {
        self.message = message
    }

    init(configuration: ReadConfiguration) throws {
        guard let data = configuration.file.regularFileContents,
              let string = String(data: data, encoding: .utf8)
        else {
            throw CocoaError(.fileReadCorruptFile)
        }
        message = string
    }

    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        return FileWrapper(regularFileWithContents: message.data(using: .utf8)!)
    }
}

#Preview(windowStyle: .automatic) {
    ContentView()
}
