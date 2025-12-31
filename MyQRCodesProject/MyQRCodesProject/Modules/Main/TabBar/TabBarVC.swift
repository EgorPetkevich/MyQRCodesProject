//
//  TabBarVC.swift
//  MyQRCodesProject
//
//  Created by George Popkich on 31.12.25.
//

import SwiftUI

struct TabBarVC: View {
    
    @State private var selection: TabItem = .home

    var body: some View {
        ZStack {
            Group {
                switch selection {
                case .home:
                    ContentView()
                case .scan:
                    ContentView()
                case .myQrCodes:
                    ContentView()
                case .history:
                    ContentView()
                        
                }
            }

            VStack(spacing: 0) {
                Spacer()
                ZStack {
                    TabBarBackground()
                        .fill(.appPrimaryBg)
                        .shadow(color: .black.opacity(0.05), radius: 8, y: -4)
                        .frame(height: 92)
                    
                    HStack {
                        ForEach(
                            [
                                TabItem.home,
                                TabItem.scan
                            ],
                            id: \.self
                        ) { item in
                            tabButton(for: item)
                        }
                        
                        Spacer().frame(width: 80)
                        
                        ForEach(
                            [
                                TabItem.myQrCodes,
                                TabItem.history
                            ],
                            id: \.self
                        ) { item in
                            tabButton(for: item)
                        }
                    }
                    .padding(.horizontal)
                    
                    Button(action: {
                        
                    }) {
                        Image(.iconAdd)
                            .scaledToFit()
                            .background(
                                Circle()
                                    .fill(.appAccentSuccess)
                                    .frame(width: 52, height: 52)
                                    .setShadow(with: 24, color: .appAccentSuccess)
                            )
                        
                    }
                    .offset(y: -32)
                }
            }
        }
        .edgesIgnoringSafeArea(.bottom)
    }

    @ViewBuilder
    private func tabButton(for item: TabItem) -> some View {
        Button(action: {
            selection = item
        }) {
            VStack(spacing: 8) {
                Image(item.icon)
                    .renderingMode(.template)
                Text(item.title)
                    .font(.inter(size: 10, style: .medium))
                    .frame(maxWidth: .infinity)
            }
            .foregroundColor(selection == item ? .appAccentPrimary : .appTextDisabled)
        }
        .frame(maxWidth: .infinity)
    }
}
