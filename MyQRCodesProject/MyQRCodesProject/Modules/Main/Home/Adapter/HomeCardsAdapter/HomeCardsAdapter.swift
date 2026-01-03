//
//  HomeCardsAdapter.swift
//  MyQRCodesProject
//
//  Created by George Popkich on 3.01.26.
//

import SwiftUI

struct HomeCardsAdapter<Item: Hashable, ItemView: View>: View {

    let items: [Item]
    let content: (Item) -> ItemView

    private let spacing: CGFloat = 16

    init(
        _ items: [Item],
        @ViewBuilder content: @escaping (Item) -> ItemView
    ) {
        self.items = items
        self.content = content
    }

    var body: some View {
        LazyVGrid(
            columns: [
                GridItem(.flexible(), spacing: spacing),
                GridItem(.flexible(), spacing: spacing)
            ],
            spacing: spacing
        ) {
            ForEach(items, id: \.self) { item in
                content(item)
            }
        }
    }
}
