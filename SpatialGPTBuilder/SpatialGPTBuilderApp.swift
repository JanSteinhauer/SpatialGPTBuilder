//
//  SpatialGPTBuilderApp.swift
//  SpatialGPTBuilder
//
//  Created by Steinhauer, Jan on 12.10.25.
//

import SwiftUI

@main
struct SpatialGPTBuilderApp: App {
    @StateObject private var workflow = WorkflowCoordinator()
    @StateObject private var sharePlay: SharePlayCoordinator
    @StateObject private var sync: FirestoreSync
    
    init() {
        let wf = WorkflowCoordinator()
        _workflow = StateObject(wrappedValue: wf)
        _sharePlay = StateObject(wrappedValue: SharePlayCoordinator(workflow: wf))
        let projectId = "hci-project-89a59"      // e.g. "spatialgptbuilder-12345"
        let apiKey    = "AIzaSyBFnoBRrLIN-EJ6Z7671WtdBGB5XVR7X-g"
        let docPath = "sessions/Session"

        _sync = StateObject(wrappedValue: FirestoreSync(projectId: projectId,
                                                        apiKey: apiKey,
                                                        documentPath: docPath,
                                                        workflow: wf))
    }


    var body: some Scene {
        WindowGroup(id: "main") {
            ContentView()
                .environmentObject(workflow)
                .environmentObject(sharePlay)
        }
        
//                WindowGroup(id: "building_blocks") {
//                    BuildingBlocksView()
//                }
//                .defaultSize(width: 400, height: 700)
//                .windowResizability(.contentSize)
//                .defaultWindowPlacement { content, context in
//                    return WindowPlacement(.leading(context.windows.first(where: { $0.id == "main" })!))
//                }
        
        WindowGroup(id: "current_result") {
            CurrentResultView()
                .environmentObject(workflow)
        }
        .defaultSize(width: 400, height: 700)
        .windowResizability(.contentSize)
        .defaultWindowPlacement { content, context in
            return WindowPlacement(.trailing(context.windows.first(where: { $0.id == "main" })!))
        }
        
        WindowGroup(id: "building_block_picker") {
            BuildingBlockPickerPlaceholderView()
                .environmentObject(workflow)
        }
        .defaultSize(width: 400, height: 700)
        .windowResizability(.contentSize)
        .defaultSize(width: 400, height: 700)
        .windowResizability(.contentSize)
        .defaultWindowPlacement { content, context in
            return WindowPlacement(.leading(context.windows.first(where: { $0.id == "main" })!))
        }
        
        ImmersiveSpace(id: "HandTrackingScene") {
            HandTrackingView()
        }
        
    }
}
