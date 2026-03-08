//
//  ContentView.swift
//  SpatialGPTBuilderWidget
//
//  Created by Steinhauer, Jan on 08.03.26.
//

import SwiftUI
import RealityKit
import RealityKitContent
import AVFoundation

struct ContentView: View {
    var body: some View {
        VStack(spacing: 20) {
            Text("Indem Sie auf die weiße untere Linie unter dem Fenster und dann nach links auf das X schauen, können Sie das Fenster wieder schließen.")
                .multilineTextAlignment(.center)
                .font(.headline)
        }
        .padding()
        .onAppear {
            AudioServicesPlaySystemSound(1006)
        }
    }
}

#Preview(windowStyle: .automatic) {
    ContentView()
}
