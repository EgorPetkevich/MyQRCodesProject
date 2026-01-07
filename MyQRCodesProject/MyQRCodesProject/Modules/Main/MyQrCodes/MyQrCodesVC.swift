//
//  MyQrCodesVC.swift
//  MyQRCodesProject
//
//  Created by George Popkich on 7.01.26.
//

import SwiftUI

struct MyQrCodesVC: View {
    
    private enum Const {
        static let title: String = "My QR Codes"
    }
    
    @Environment(TabBarState.self) private var tabBar
    
    @State private var showOptions: Bool = false
    
    @StateObject private var vm: MyQrCodesVM
    
    init(viewModel: MyQrCodesVM) {
        self._vm = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            
            header
            
            ScrollView(showsIndicators: false) {
                
                VStack() {
                    
                    myQrCards
                    
                }
                .padding(.horizontal, 24)
                .padding(.top, 15.5)
                .padding(.bottom, tabBar.bottomSafeAreaInset)
                
            }
            .background(.appPrimarySecondaryBg)
            
            
        }
        .ignoresSafeArea(edges: .top)
        .fullScreenCover(isPresented: $vm.showDetails) {
            if let dto = vm.selectedDTO {
                AnyView(CreatedQrPreviewAssembler.make(dto: dto))
            } else {
                AnyView(EmptyView())
            }
        }
        .sheet(isPresented: $vm.showShareSheet) {
            if !vm.shareItems.isEmpty {
                ActivityView(activityItems: vm.shareItems)
            }
        }
        
    }
    
    private var header: some View {
        VStack {
            Spacer()
            HStack {
                Text(Const.title)
                    .inter(size: 22, style: .semiBold)
                Spacer()
            }
            .padding(.bottom, 16)
            .padding(.horizontal, 24)
            
            sortSection
                .padding(.bottom, 16)
        }
       
        .frame(height: 170)
        .background(Color.appPrimaryBg)
    }
    
    private var sortSection: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(MyQrCodesSortSection.allCases) { pill in
                    SortPillView(
                        title: pill.title,
                        isSelected: vm.selectedSortPill == pill,
                        onTap: { vm.selectedSortPill = pill })
                    
                }
            }
            .padding(.horizontal, 24)
        }
    }
    
    private var myQrCards: some View {
        VStack(spacing: 16.5) {

            LazyVGrid(columns: [
                GridItem(.flexible(), spacing: 16),
                GridItem(.flexible(), spacing: 16)
            ], spacing: 16) {
                
                ForEach(vm.sortedDtos, id: \.id) { dto in
                    ZStack {
                        MyQrCardView(
                            dto: dto,
                            cardDidSelect: { vm.selectedDTO = dto },
                            onShare: { vm.share(dto) },
                            onEdit: {},
                            onDelete: { vm.delete(dto) }
                        )
                        
                    }
                }
            }
        }
    }
}
