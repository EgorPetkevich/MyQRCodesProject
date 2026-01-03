//
//  HomeRecentActivityAdapter.swift
//  MyQRCodesProject
//
//  Created by George Popkich on 3.01.26.
//

import SwiftUI

struct HomeRecentActivityAdapter <Item: Hashable, ItemView: View>: View {
    
    let title: String
    let items: [Item]
    let content: (Item) -> ItemView

    private let spacing: CGFloat = 12

    init(
        title: String,
        _ items: [Item],
        @ViewBuilder content: @escaping (Item) -> ItemView
    ) {
        self.title = title
        self.items = items
        self.content = content
    }
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Text(title)
                    .inter(size: 22, style: .semiBold)
                
                Spacer()
            }
            
            ForEach(items, id: \.self) { item in
                content(item)
                    .padding(.bottom, spacing)
            }
        }
        
        
    }
}
