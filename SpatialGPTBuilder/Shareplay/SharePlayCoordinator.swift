//
//  SharePlayCoordinator.swift
//  SpatialGPTBuilder
//
//  Created by Steinhauer, Jan on 02.11.25.
//

import Foundation
import Combine
import GroupActivities

@MainActor
final class SharePlayCoordinator: ObservableObject {

    @Published private(set) var isSharing = false
    @Published private(set) var session: GroupSession<WorkflowActivity>?
    @Published private(set) var isEligibleForGroupSession = false

    private let workflow: WorkflowCoordinator
    private var stateObserver = GroupStateObserver()
    private var cancellables = Set<AnyCancellable>()
    private var messenger: GroupSessionMessenger?
    private var outboundDebounce: AnyCancellable?
    
    init(workflow: WorkflowCoordinator) {
        self.workflow = workflow

        // observe eligibility
        Task { @MainActor in
            self.isEligibleForGroupSession = stateObserver.isEligibleForGroupSession
            print("[SharePlay] Eligibility initial = \(self.isEligibleForGroupSession)")
            stateObserver.$isEligibleForGroupSession
                .receive(on: RunLoop.main)
                .sink { eligible in
                    print("[SharePlay] Eligibility changed -> \(eligible)")
                    self.isEligibleForGroupSession = eligible
                }
                .store(in: &cancellables)
        }

        observeIncomingSessions()
        observeLocalChanges()
    }
    
    private func observeIncomingSessions() {
        Task {
            print("[SharePlay] Observe sessions started")
            for await session in WorkflowActivity.sessions() {
                print("[SharePlay] Session discovered (state=\(session.state)) — configuring…")
                configureSession(session)
            }
        }
    }

    // Start a new activity or join an existing one
    func startSharing() async {
        do {
            print("[SharePlay] Activating WorkflowActivity…")
            try await WorkflowActivity().activate()
            print("[SharePlay] Activation requested; waiting for system to form a session.")
        } catch {
            print("[SharePlay] Failed to activate WorkflowActivity: \(error)")
        }
    }

    func stopSharing() {
        print("[SharePlay] Stop sharing requested.")
        session?.leave()
        session = nil
        isSharing = false
        messenger = nil
        print("[SharePlay] Left session and cleared messenger.")
    }

    // (Kept for parity; observeIncomingSessions already handles this)
    private func observeGroupState() {
        Task {
            for await session in WorkflowActivity.sessions() {
                print("[SharePlay] (observeGroupState) Session discovered — configuring…")
                configureSession(session)
            }
        }
    }

    private func configureSession(_ session: GroupSession<WorkflowActivity>) {
        self.session = session
        self.isSharing = true
        print("[SharePlay] Configuring session; state=\(session.state) participants=\(session.activeParticipants.count)")

        // Set up messaging
        let messenger = GroupSessionMessenger(session: session)
        self.messenger = messenger
        print("[SharePlay] Messenger created.")

        // When others join, send them our current snapshot
        session.$activeParticipants
            .sink { [weak self] participants in
                guard let self, let messenger = self.messenger else { return }
                let pCount = participants.count
                print("[SharePlay] Active participants changed -> \(pCount). Broadcasting current snapshot to all.")
                Task { [snapshot = self.workflow.makeSnapshot()] in
                    do {
                        try await messenger.send(snapshot)
                        print("[SharePlay] ✅ Sent snapshot (rev=\(snapshot.revision)) to all participants.")
                    } catch {
                        print("[SharePlay] ❌ Failed sending snapshot to all: \(error)")
                    }
                }
            }
            .store(in: &cancellables)

        // Receive snapshots
        Task {
            print("[SharePlay] Begin receiving snapshots…")
            for await (snapshot, context) in messenger.messages(of: WorkflowSnapshot.self) {
                print("[SharePlay] ⬇️ Received snapshot (rev=\(snapshot.revision)) from \(context.source.id)")
                self.workflow.apply(snapshot: snapshot)
            }
        }

        // Observe invalidation
        session.$state
            .sink { [weak self] state in
                print("[SharePlay] Session state -> \(state)")
                if case .invalidated = state {
                    print("[SharePlay] Session invalidated. Cleaning up.")
                    self?.messenger = nil
                    self?.session = nil
                    self?.isSharing = false
                }
            }
            .store(in: &cancellables)

        // Join / start session
        print("[SharePlay] Joining session…")
        session.join()
    }

    // Debounced outbound sending so we don’t spam messages per keystroke/tap
    private func observeLocalChanges() {
        outboundDebounce = workflow.objectWillChange
            .debounce(for: .milliseconds(120), scheduler: RunLoop.main)
            .sink { [weak self] in
                guard let self,
                      let messenger = self.messenger,
                      self.session?.state == .joined else {
                    print("[SharePlay] (debounce) Skipped send — no messenger or session not joined.")
                    return
                }
                let snap = self.workflow.makeSnapshot()
                print("[SharePlay] ⬆️ Sending snapshot (rev=\(snap.revision)) due to local change.")
                Task {
                    do {
                        try await messenger.send(snap)
                        print("[SharePlay] ✅ Snapshot sent (rev=\(snap.revision)).")
                    } catch {
                        print("[SharePlay] ❌ Snapshot send failed: \(error)")
                    }
                }
            }
    }
}
