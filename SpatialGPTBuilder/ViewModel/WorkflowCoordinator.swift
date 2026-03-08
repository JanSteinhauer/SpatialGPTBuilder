//
//  WorkflowCoordinator.swift
//  SpatialGPTBuilder
//
//  Created by Steinhauer, Jan on 01.11.25.
//

import SwiftUI
import Combine
import AudioToolbox

@MainActor
final class WorkflowCoordinator: ObservableObject {

    @Published var selections: [Category: OptionItem] = [:]
    @Published var pickingCategory: Category? = nil
    @Published var pendingSelection: OptionItem? = nil

    @Published var pendingHandshake: HandshakeRequest? = nil
    @Published var successMessage: String? = nil
    @Published var handshakeWarning: String? = nil

    @Published private(set) var confirmedColumns: Set<Column> = []
    @Published private(set) var revision: Int = 0
    
    // Internal tracking for handshake timeout
    private var currentHandshakeID: UUID?


    // MARK: Picking API
    func beginPicking(_ category: Category) {
        // 🧩 If user switches to another column or category while handshake pending, BLOCK it
        if pendingHandshake != nil {
            print("[Workflow] Selection blocked - pending handshake must be completed first.")
            handshakeWarning = "Bitte starten Sie zuerst den Handshake!"
            
            // Clear warning after 3 seconds
            Task { @MainActor in
                try? await Task.sleep(nanoseconds: 3 * 1_000_000_000)
                if handshakeWarning == "Bitte starten Sie zuerst den Handshake!" {
                    handshakeWarning = nil
                }
            }
            return
        }

        let was = (pickingCategory, pendingSelection)
        pickingCategory = category
        pendingSelection = selections[category]

        if was.0 != pickingCategory || was.1 != pendingSelection {
            revision &+= 1
            print("[Workflow] beginPicking(\(category.display)) -> rev \(revision)")
        } else {
            print("[Workflow] beginPicking(\(category.display)) -> no state change")
        }
    }



    func confirmSelection() {
        guard let cat = pickingCategory, let opt = pendingSelection else {
            print("[Workflow] confirmSelection() ignored — no pending selection.")
            return
        }
        let before = selections

        selections[cat] = opt
        pickingCategory = nil
        pendingSelection = nil

        if before != selections {
            revision &+= 1
            print("[Workflow] confirmSelection \(cat.display) = \(opt.displayName) -> rev \(revision)")
            NotificationCenter.default.post(name: .workflowDidChange, object: self)
            print("[Workflow] 🔄 Posted .workflowDidChange after confirming \(opt.displayName)")
        } else {
            print("[Workflow] confirmSelection made no effective change.")
        }

        let col = cat.column
        let wasCompleteBefore = before.hasAllSelected(in: col)
        let isCompleteNow     = selections.hasAllSelected(in: col)
        print("[Workflow] Column \(col.displayName) completion: \(wasCompleteBefore) -> \(isCompleteNow)")

        if confirmedColumns.contains(col) && before[cat] != selections[cat] {
            confirmedColumns.remove(col)
            print("[Workflow] Column \(col.displayName) changed — revoked previous confirmation.")
        }

        if isCompleteNow, !confirmedColumns.contains(col), pendingHandshake == nil {
            print("[Workflow] Requesting handshake for \(col.displayName)")
            requestHandshake(for: .column(col))
        }
    }

    func cancelPicking() {
        let was = (pickingCategory, pendingSelection)
        pickingCategory = nil
        pendingSelection = nil
        if was.0 != pickingCategory || was.1 != pendingSelection {
            revision &+= 1
            print("[Workflow] cancelPicking -> rev \(revision)")
        } else {
            print("[Workflow] cancelPicking -> no state change")
        }
    }

    // MARK: Handshake lifecycle
    func requestHandshake(for scope: HandshakeScope) {
        let items: [OptionItem]
        switch scope {
        case .category(let c):
            items = selections[c].map { [$0] } ?? []
        case .column(let col):
            items = col.categories.compactMap { selections[$0] }
        }
        pendingHandshake = HandshakeRequest(scope: scope, items: items)
        
        // Timeout logic: Auto-complete after 5 seconds if not handled
        let handshakeID = UUID()
        self.currentHandshakeID = handshakeID
        
        // Timeout logic is now manual via startHandshakeTimeout()
        
        print("[Workflow] Handshake requested for \(scope) with items: \(items.map{$0.displayName}.joined(separator: ", "))")
    }

    func startHandshakeTimeout() {
        guard let handshakeID = self.currentHandshakeID else { return }
        print("[Workflow] 5s handshake timeout disabled by user request.")
        
        /*
        Task {
            try? await Task.sleep(nanoseconds: 5 * 1_000_000_000)
            if self.currentHandshakeID == handshakeID && self.pendingHandshake != nil {
                print("[Workflow] Handshake timed out - automatically completing.")
                self.completeHandshake()
            }
        }
        */
    }

    func completeHandshake() {
        guard let request = pendingHandshake else {
            print("[Workflow] completeHandshake ignored — no pending handshake.")
            return
        }

        if case .column(let col) = request.scope {
            confirmedColumns.insert(col)
            print("[Workflow] Handshake completed for \(col.displayName). Confirmed columns: \(confirmedColumns.map{$0.displayName})")
        }

        // Play success sound (e.g. Fanfare or similar system sound)
        AudioServicesPlaySystemSound(1025)

        let list = request.items.map(\.displayName).joined(separator: ", ")
        successMessage = list.isEmpty
            ? "Selection successfully confirmed."
            : "Building block(s) confirmed: \(list)"
        print("[Workflow] successMessage -> \(successMessage ?? "nil")")

        pendingHandshake = nil

        // 🔁 push new state to Firestore
        revision &+= 1
        NotificationCenter.default.post(name: .workflowDidChange, object: self)
        print("[Workflow] 🔄 Posted .workflowDidChange after handshake completion (rev \(revision))")

        Task { @MainActor in
            try? await Task.sleep(nanoseconds: 5_000_000_000)
            successMessage = nil
            print("[Workflow] successMessage cleared.")
        }
    }

    // MARK: Snapshot I/O
    func makeSnapshot() -> WorkflowSnapshot {
        let snap = WorkflowSnapshot(
            selections: selections,
            pickingCategory: pickingCategory,
            pendingSelection: pendingSelection,
            pendingHandshake: pendingHandshake,
            revision: revision
        )
        // Lightweight log (don’t spam options list)
        print("[Workflow] makeSnapshot -> rev \(snap.revision), selections=\(selections.count)")
        return snap
    }

    func apply(snapshot: WorkflowSnapshot) {
        // Only apply if newer
        guard snapshot.revision >= self.revision else {
            print("[Workflow] apply(snapshot rev=\(snapshot.revision)) skipped; local rev=\(self.revision) is newer.")
            return
        }
        let oldHandshake = self.pendingHandshake
        
        self.selections = snapshot.selections
        self.pickingCategory = snapshot.pickingCategory
        self.pendingSelection = snapshot.pendingSelection
        self.pendingHandshake = snapshot.pendingHandshake
        self.revision = snapshot.revision
        print("[Workflow] ⬅︎ Applied snapshot rev \(snapshot.revision). selections=\(selections.count)")
        
        // 🔔 Sound Logic for Remote Handshake
        // 1. Handshake STARTED remotely (nil -> some)
        if oldHandshake == nil, let newHandshake = self.pendingHandshake {
            print("[Workflow] Remote handshake STARTED: \(newHandshake.scope)")
            // Play "Tock" / Start sound
            AudioServicesPlaySystemSound(1057)
        }
        
        // 2. Handshake COMPLETED remotely (some -> nil)
        // Note: checking `snapshot.revision > self.revision` at the top ensures we only process *new* states.
        // If we just completed it locally, our local state is already nil, so oldHandshake is nil, so this won't fire.
        // This correctly targets the case where we were pending (oldHandshake != nil) and now it's done (newHandshake == nil).
        if oldHandshake != nil, self.pendingHandshake == nil {
            print("[Workflow] Remote handshake COMPLETED/CANCELLED.")
            // Play Success sound
            AudioServicesPlaySystemSound(1025)
        }
    }
}
