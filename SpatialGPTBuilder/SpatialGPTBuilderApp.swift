//
//  SpatialGPTBuilderApp.swift
//  SpatialGPTBuilder
//
//  Created by Steinhauer, Jan on 12.10.25.
//

import SwiftUI

@main
struct SpatialGPTBuilderApp: App {
    var body: some Scene {
        WindowGroup(id: "main") {
            ContentView()
        }
        
        WindowGroup(id: "building_blocks") {
            BuildingBlocksView()
        }
        .defaultSize(width: 400, height: 700)
        .windowResizability(.contentSize)
        .defaultWindowPlacement { content, context in
            
            return WindowPlacement(.leading(context.windows.first(where: { $0.id == "main" })!))
        }
        
    }
}
