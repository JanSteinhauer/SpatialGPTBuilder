//
//  FirestoreSync.swift
//  SpatialGPTBuilder
//
//  Created by Steinhauer, Jan on 09.11.25.
//

import SwiftUI
import Combine
import Foundation

@MainActor
final class FirestoreSync: ObservableObject {
    let rest: FirestoreREST
    let workflow: WorkflowCoordinator
    private var pollTask: Task<Void, Never>?
    private var lastUpdateTime: String?
    private var pushDebounce: AnyObject?
    
    private var pushWorkItem: DispatchWorkItem?
    private var lastRemoteHandshakeCompleted: Bool? = nil

    // Tweak this if you want faster/slower updates
    private let pollInterval: TimeInterval = 1.0

    init(projectId: String, apiKey: String, documentPath: String, workflow: WorkflowCoordinator) {
        self.rest = FirestoreREST(projectId: projectId, apiKey: apiKey, documentPath: documentPath)
        self.workflow = workflow
        
//        Task {
//            do {
//                let (json, _) = try await rest.getDocument()
//                print("🔥 [FirestoreSync] Initial Firestore document loaded:")
//                dump(json) // pretty prints structure
//            } catch {
//                print("❌ [FirestoreSync] Failed to load initial document:", error)
//            }
//        }

//        runDiagnostics()
        
        // Start polling Firestore for changes
        startPolling()

        // Observe local changes; push after debounce
        NotificationCenter.default.addObserver(forName: .workflowDidChange, object: workflow, queue: .main) { [weak self] _ in
            self?.schedulePush()
        }
    }

    deinit {
        pollTask?.cancel()
        NotificationCenter.default.removeObserver(self)
    }

    private func startPolling() {
        pollTask?.cancel()
        pollTask = Task { [weak self] in
            guard let self else { return }
            while !Task.isCancelled {
                await self.pullOnce()
                try? await Task.sleep(nanoseconds: UInt64(self.pollInterval * 1_000_000_000))
            }
        }
    }
    
    private func boolField(_ fields: [String: Any], key: String) -> Bool? {
            (fields[key] as? [String: Any])?["booleanValue"] as? Bool
        }
    
    func runDiagnostics() {
            Task { @MainActor in
                let masked = mask(rest.exposedProjectId)
                print("🔎 Firestore diagnostics…")
                print("• projectId: \(masked)")
                print("• documentPath: \(rest.exposedDocumentPath)")
                print("• base: \(rest.exposedBaseURL)")
                print("• using default database: \(rest.exposedBaseURL.contains("(default)"))")

                do {
                    print("➡️ GET \(rest.exposedBaseURL)/\(rest.exposedDocumentPath)?key=•••")
                    let (json, _) = try await rest.getDocument()
                    print("✅ GET ok — document exists.")
                    pretty("Document", json)
                } catch let ns as NSError {
                    let code = ns.code
                    let body = (ns.userInfo["body"] as? String) ?? ""
                    print("❌ GET failed — HTTP \(code)")
                    if !body.isEmpty { print("  Body:\n\(body)") }

                    switch code {
                    case 404:
                        print("👉 Classification: Document NOT FOUND (wrong path/case or not created yet).")
                        print("   Action: Attempting to create a minimal shell document…")
                        do {
                            try await createMinimalSessionIfMissing()
                            print("✅ Created shell doc. Re-GET to confirm…")
                            let (json2, _) = try await rest.getDocument()
                            print("✅ GET ok after create.")
                            pretty("Document", json2)
                        } catch let ns2 as NSError {
                            print("❌ Create failed — HTTP \(ns2.code)")
                            if let b = ns2.userInfo["body"] { print("  Body:\n\(b)") }
                            print("   Check path spelling/case and Firestore rules.")
                        }

                    case 403:
                        print("👉 Classification: PERMISSION DENIED (rules/auth).")
                        print("   With REST + apiKey only, reads/writes require permissive rules.")
                        print("   For protected docs, send an ID token in Authorization: Bearer …")

                    case 400, 401:
                        print("👉 Classification: Request/API key issue. Verify Web API Key and URL.")

                    default:
                        print("👉 Unknown HTTP error; inspect the response body above.")
                    }
                }
            }
        }

        // MARK: – helpers

        private func createMinimalSessionIfMissing() async throws {
            let now = ISO8601DateFormatter().string(from: Date())
            let shell: [String: FirestoreREST.FirestoreValue] = [
                "revision": .integer(0),
                "pickingCategory": .string(""),
                "pendingSelection": .null,
                "selections": .map([:]),
                "createdAt": .timestamp(now),
                "updatedAt": .timestamp(now)
            ]
            try await rest.patchDocument(fields: shell, updateMask: Array(shell.keys))
        }

        private func pretty(_ title: String, _ obj: Any) {
            if let data = try? JSONSerialization.data(withJSONObject: obj, options: .prettyPrinted),
               let str = String(data: data, encoding: .utf8) {
                print("📄 \(title):\n\(str)")
            } else {
                print("📄 \(title):\n\(obj)")
            }
        }

        private func mask(_ s: String) -> String {
            guard s.count > 4 else { return s }
            return String(s.prefix(2)) + String(repeating: "•", count: s.count - 4) + String(s.suffix(2))
        }
    


    private func pullOnce() async {
        do {
            let (json, updateTime) = try await rest.getDocument()
            guard let fields = json["fields"] as? [String: Any] else { return }

            // --- 🔁 Remote handshake completion handling ---
            if let remoteFlag = boolField(fields, key: "handshakeCompleted") {
                if let last = lastRemoteHandshakeCompleted {
                    // Detect rising edge: false -> true
                    if remoteFlag && !last && workflow.pendingHandshake != nil {
                        print("[FirestoreSync] Remote handshakeCompleted=true → posting .handshakeDetected")
                        
                        // Same event shape the HandTrackingSystem uses; "isLeft" is arbitrary here
                        NotificationCenter.default.post(
                            name: .handshakeDetected,
                            object: nil,
                            userInfo: [
                                "isLeft": false,
                                "source": "firestore"
                            ]
                        )
                    }
                }
                lastRemoteHandshakeCompleted = remoteFlag
            }
            // --- end remote handshake completion handling ---

            // Existing updateTime logic
            if updateTime != nil && updateTime == self.lastUpdateTime { return }
            self.lastUpdateTime = updateTime

            if let snapshot = decodeSnapshot(from: fields) {
                workflow.apply(snapshot: snapshot)
            }
        } catch {
            // Optional log
            // print("Pull error: \(error)")
        }
    }



    private func schedulePush() {
        pushWorkItem?.cancel()
        let work = DispatchWorkItem { [weak self] in self?.pushNow() }
        pushWorkItem = work
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15, execute: work)
    }

    private func pushNow() {
        Task {
            let snap = workflow.makeSnapshot()
            let fields = encodeSnapshot(snap)
            do {
                try await rest.patchDocument(fields: fields, updateMask: Array(fields.keys))
            } catch {
                print("Push error: \(error)")
            }
        }
    }

    // MARK: - Firestore fields <-> WorkflowSnapshot

    private func encodeOption(_ o: OptionItem?) -> FirestoreREST.FirestoreValue {
        guard let o = o else { return .null }
        return .map([
            "id": .string(o.id),
            "displayName": .string(o.displayName),
            "assetName": .string(o.assetName)
        ])
    }

    private func encodeSelections(_ dict: [Category: OptionItem]) -> FirestoreREST.FirestoreValue {
        var m: [String: FirestoreREST.FirestoreValue] = [:]
        for (k, v) in dict {
            m[k.rawValue] = encodeOption(v)
        }
        return .map(m)
    }

    private func encodeSnapshot(_ s: WorkflowSnapshot) -> [String: FirestoreREST.FirestoreValue] {
        var fields: [String: FirestoreREST.FirestoreValue] = [
            "revision": .integer(Int64(s.revision)),
            "pickingCategory": s.pickingCategory != nil
                ? .string(s.pickingCategory!.rawValue)
                : .string(""),
            "pendingSelection": encodeOption(s.pendingSelection),
            "selections": encodeSelections(s.selections),
            "updatedAt": .timestamp(ISO8601DateFormatter().string(from: Date()))
        ]

        fields["handshakeCompleted"] = .boolean(workflow.pendingHandshake == nil)

        return fields
    }


    private func decodeOption(_ v: Any?) -> OptionItem? {
        guard let m = (v as? [String: Any])?["mapValue"] as? [String: Any],
              let fields = m["fields"] as? [String: Any] else { return nil }
        
        func str(_ key: String) -> String? {
            (fields[key] as? [String: Any])?["stringValue"] as? String
        }
        
        guard let id = str("id"),
              let dn = str("displayName"),
              let an = str("assetName") else { return nil }

        // 🧠 Skip if all values are empty — means Firestore placeholder
        if id.isEmpty && dn.isEmpty && an.isEmpty {
            return nil
        }

        return OptionItem(id, displayName: dn, assetName: an)
    }


    private func decodeSelections(_ v: Any?) -> [Category: OptionItem] {
        guard let mm = (v as? [String: Any])?["mapValue"] as? [String: Any],
              let fields = mm["fields"] as? [String: Any] else { return [:] }
        var out: [Category: OptionItem] = [:]
        for (k, val) in fields {
            if let cat = Category(rawValue: k), let item = decodeOption(val) {
                out[cat] = item
            }
        }
        return out
    }

    private func decodeSnapshot(from fields: [String: Any]) -> WorkflowSnapshot? {
        let revStr = (fields["revision"] as? [String: Any])?["integerValue"] as? String
        let rev = revStr.flatMap(Int.init) ?? 0

        let pick = (fields["pickingCategory"] as? [String: Any])?["stringValue"] as? String
        let picking = pick.flatMap { Category(rawValue: $0) }

        let pending = decodeOption(fields["pendingSelection"])
        let selections = decodeSelections(fields["selections"])

        return WorkflowSnapshot(
            selections: selections,
            pickingCategory: picking,
            pendingSelection: pending,
            revision: rev
        )
    }
}

extension OptionItem {
    init(_ id: String, displayName: String, assetName: String) {
        self.id = id
        self.displayName = displayName
        self.assetName = assetName
    }
}

