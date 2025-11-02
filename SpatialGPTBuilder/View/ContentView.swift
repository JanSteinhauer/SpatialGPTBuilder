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
    @EnvironmentObject private var sharePlay: SharePlayCoordinator

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack{
                Spacer()
                Text("AI Integration Workflow")
                    .font(.system(size: 40))
                    .font(.largeTitle.bold())
                    .padding(.horizontal)
                    .padding(.top)
                Spacer()
                Button {
                    Task { await sharePlay.startSharing() }
                } label: {
                    HStack(spacing: 8) {
                        Image(systemName: "shareplay")
                        Text(sharePlay.isSharing ? "Sharing…" : "Share")
                    }
                }
                .buttonStyle(.borderedProminent)
                .padding(.trailing)
            }
            AIIntegrationWorkflowDiagram()
                .padding(.horizontal)
            
        }
        .onAppear {
//            openWindow(id: "building_blocks")
            openWindow(id: "current_result")
            openWindow(id: "building_block_picker")
        }
    }
}

#Preview(windowStyle: .automatic) {
    ContentView()
}
