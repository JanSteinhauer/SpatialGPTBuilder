//
//  PickerContentGrid.swift
//  SpatialGPTBuilder
//
//  Created by Steinhauer, Jan on 01.11.25.
//

import SwiftUI

struct PickerContentGrid: View {
    let title: String
    let options: [OptionItem]
    @Binding var selected: OptionItem?
    let onConfirm: () -> Void
    let onCancel: () -> Void

    private let columns = [GridItem(.adaptive(minimum: 140), spacing: 12, alignment: .top)]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(title).font(.headline)
                Spacer()
                Button("Cancel", role: .cancel, action: onCancel)
                Button("Confirm") {
                    onConfirm()
                }
                .buttonStyle(.borderedProminent)
                .disabled(selected == nil)
            }

            Divider()

            ScrollView {
                LazyVGrid(columns: columns, spacing: 14) {
                    ForEach(options) { item in
                        Button {
                            selected = item
                        } label: {
                            PickerTile(item: item, isSelected: selected?.id == item.id)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.top, 4)
            }
        }
        .padding(16)
    }
}
