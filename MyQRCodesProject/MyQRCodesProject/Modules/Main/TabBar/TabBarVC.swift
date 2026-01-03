//
//  TabBarVC.swift
//  MyQRCodesProject
//
//  Created by George Popkich on 31.12.25.
//

import SwiftUI

@Observable
final class TabBarState {
    var selection: TabItem = .home
    var bottomSafeAreaInset: CGFloat = 112
}

struct TabBarVC: View {
    
    @State private var tabBarState = TabBarState()

    var body: some View {
        ZStack {
            Group {
                switch tabBarState.selection {
                case .home:
                    HomeVC(viewModel: HomeVM())
                case .scan:
                    ScanVC(viewModel:
                            ScanVM(cameraManger: CameraManager(), qrCodeManager: QrCodeManager())
                    )
                case .create:
                    ContentView()
                case .myQrCodes:
                    ContentView()
                case .history:
                    ContentView()
                        
                }
            }
            .environment(tabBarState)
            
            //tabBar setup

            VStack(spacing: 0) {
                Spacer()
                ZStack {
                    TabBarBackground()
                        .fill(.appPrimaryBg)
                        .setShadow(with: 8)
                        .frame(height: 92)
                    
                    tabBarItems
                    plusButton
                }
            }
        }
        .edgesIgnoringSafeArea(.bottom)

    }
    
    private var tabBarItems: some View {
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
    }
    
    private var plusButton: some View {
        Button(action: { tabBarState.selection = .create }) {
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
    
    @ViewBuilder
    private func tabButton(for item: TabItem) -> some View {
        Button(action: {
            tabBarState.selection = item
        }) {
            VStack(spacing: 8) {
                Image(item.icon)
                    .renderingMode(.template)
                Text(item.title)
                    .font(.inter(size: 10, style: .medium))
                    .frame(maxWidth: .infinity)
            }
            .foregroundColor(tabBarState.selection == item ? .appAccentPrimary : .appTextDisabled)
        }
        .frame(maxWidth: .infinity)
    }
}
