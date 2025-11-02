//
//  CurrentResultView.swift
//  SpatialGPTBuilder
//
//  Created by Steinhauer, Jan on 19.10.25.
//

import SwiftUI

struct CurrentResultView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack{
                Spacer()
                Text("Current Result")
                    .font(.title.bold())
                    .padding(.horizontal, 16)
                    .padding(.top, 16)

                Spacer()
            }
            
            Divider().padding(.top, 8)

            VStack(spacing: 12) {
                HStack {
                    Text("current cost:")
                    Spacer()
                    Text("20.000$")
                        .monospacedDigit()
                }
                HStack {
                    Text("predetermined cost:")
                    Spacer()
                    Text("30000$")
                        .monospacedDigit()
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)

            Divider()

            VStack(spacing: 12) {
                HStack {
                    Text("current security:")
                    Spacer()
                    Text("⭐️⭐️⭐️⭐️⭐️")
                }
                HStack {
                    Text("predetermined security:")
                    Spacer()
                    Text("⭐️⭐️⭐️")
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)

            Divider()

            VStack(spacing: 12) {
                HStack {
                    Text("current speed:")
                    Spacer()
                    Text("slow")
                }
                HStack {
                    Text("predetermined speed:")
                    Spacer()
                    Text("middle")
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)

            Divider()

            // issues
            HStack {
                Text("issues:")
                Spacer()
                Text("no issues")
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)

            Divider()

            Text("current score")
                .font(.headline)
                .padding(.horizontal, 16)
                .padding(.top, 12)

            HStack {
                Text("current score:")
                Spacer()
                Text("30283")
                    .monospacedDigit()
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)

            HStack {
                Spacer()
                Button("Submit") {
                    // TODO: Submit Message
                }
                .buttonStyle(.borderedProminent)
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 16)
            .padding(.top, 4)
        }
    }
}
