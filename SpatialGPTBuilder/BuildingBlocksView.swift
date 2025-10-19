//
//  BuildingBlocksView.swift
//  SpatialGPTBuilder
//
//  Created by Steinhauer, Jan on 19.10.25.
//

import SwiftUI

@MainActor
struct BuildingBlocksView: View {
    @State private var sections: [(Category, [OptionItem])] = []

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack{
                Spacer()
                Text("Building Blocks")
                    .font(.title.bold())
                    .padding(.horizontal, 16)
                    .padding(.top, 16)
                Spacer()
            }
           

            Divider()
                .padding(.top, 8)

            ScrollView {
                LazyVStack(alignment: .leading, spacing: 0) {
                    ForEach(Array(sections.enumerated()), id: \.offset) { idx, section in
                        Text(section.0.subheadline)
                            .font(.subheadline.weight(.semibold))
                            .textCase(.uppercase)
                            .foregroundStyle(.secondary)
                            .padding(.top, idx == 0 ? 12 : 20)
                            .padding(.horizontal, 16)

                        ScrollView(.horizontal) {
                            LazyHStack(alignment: .top, spacing: 16) {
                                ForEach(section.1) { item in
                                    RoundedBlockTile(title: item.displayName, size: 112)
                                }
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 12)
                        }
                        .scrollIndicators(.hidden)

                        Divider()
                            .padding(.horizontal, 16)
                    }

                    Spacer(minLength: 12)
                }
            }
        }
        .onAppear {
            sections = Category.allCases.map { cat in (cat, OptionsProvider.items(for: cat)) }
        }
    }
}
