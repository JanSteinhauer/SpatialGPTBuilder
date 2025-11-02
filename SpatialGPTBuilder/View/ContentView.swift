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
