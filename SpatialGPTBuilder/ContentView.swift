//
//  ContentView.swift
//  SpatialGPTBuilder
//
//  Created by Steinhauer, Jan on 12.10.25.
//

import SwiftUI

struct ContentView: View {
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
    }
}

#Preview(windowStyle: .automatic) {
    ContentView()
}
