//
//  HomeVC.swift
//  MyQRCodesProject
//
//  Created by George Popkich on 3.01.26.
//

import SwiftUI

struct HomeVC: View {
    
    private enum Const {
        static let title: String = "Welcome, User!"
        static let subtitle: String = "Manage your QR codes easily"
        static let recentActivityTitle: String = "Recent Activity"
    }
    
    @Environment(TabBarState.self) private var tabState
    
    @StateObject private var vm: HomeVM
    
    init(viewModel: HomeVM) {
        self._vm = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack() {
                header
                actionCards
                resentActivity
            }
            .padding(.horizontal, 24)
            .padding(.bottom, tabState.bottomSafeAreaInset)
        }
        .background(.appPrimaryBg)
    
    }
    
    private var header: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(Const.title)
                    .inter(size: 28, style: .bold)
                Text(Const.subtitle)
                    .inter(size: 15, color: .appTextSecondary)
            }
            Spacer()
        }
        .padding(.top, 10)
        .padding(.bottom, 55)
        
    }
    
    private var actionCards: some View {
        HomeCardsAdapter(HomeCardsSection.allCases) { card in
            HomeCard(
                card: card,
                onTap: {
                    switch card {
                    case .scan:    tabState.selection = .scan
                    case .create:  tabState.selection = .create
                    case .myCodes: tabState.selection = .myQrCodes
                    case .history: tabState.selection = .history
                    }
                })
        }
        .padding(.bottom, 32)
    }
    
    private var resentActivity: some View {
           HomeRecentActivityAdapter(
            title: Const.recentActivityTitle,
            getItems())
        { model in
                HomeRecentActiviryRow(model: model)
            }
    }
    
    //FIXME: remove test funcion
    private func getItems() -> [RecentActivityModel] {
        [
            RecentActivityModel(icon: .homeFolder,
                                bgIconColor: .appAccentPrimary,
                                title: "Test",
                                subtitle: "some time ago")
        ]
    }
}

