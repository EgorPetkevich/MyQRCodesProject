//
//  HistoryVC.swift
//  MyQRCodesProject
//
//  Created by George Popkich on 8.01.26.
//

import SwiftUI

struct HistoryVC: View {
    
    private enum Const {
        static let title: String = "History"
    }
    
    @Environment(TabBarState.self) private var tabBar
    @State private var showOptions: Bool = false
    @StateObject private var vm: HistoryVM
    
    init(viewModel: HistoryVM) {
        self._vm = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            header
            historyList
                .listStyle(PlainListStyle())
                
        }
        
        .padding(.bottom, tabBar.bottomSafeAreaInset)
        .background(.appPrimarySecondaryBg)
        .ignoresSafeArea(edges: .top)
        .overlay(alignment: .bottom) {
            VStack(spacing: 8) {
                if vm.showCopiedToast {
                    ToastView(text: "Copied", icon: "doc.on.doc")
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                }
            }
            .padding(.bottom, tabBar.bottomSafeAreaInset + 32)
            .animation(.easeInOut(duration: 0.25), value: vm.showCopiedToast)
        }
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
                ForEach(HistorySortSection.allCases) { pill in
                    SortPillView(
                        title: pill.title,
                        isSelected: vm.selectedSortPill == pill,
                        onTap: { vm.selectedSortPill = pill }
                    )
                }
            }
            .padding(.horizontal, 24)
        }
    }

    private var historyList: some View {
        List {
            ForEach(vm.groupedDtos.keys.sorted(), id: \.self) { dateTitle in
                Section(
                    header:
                        HStack {
                            Text(dateTitle)
                                .inter(size: 17, style: .semiBold)
                                .foregroundStyle(.appPrimarySecondaryBg)
                            Spacer()
                        }
                        .padding(.horizontal, 24)
                        .padding(.vertical, 8)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.appPrimarySecondaryBg)
                        .listRowInsets(EdgeInsets())
                ) {
                    ForEach(vm.groupedDtos[dateTitle]!, id: \.id) { dto in
                        ZStack {
                            HistoryRow(
                                dto: dto,
                                cardDidSelect: { vm.selectedDTO = dto },
                                onCopie: { vm.copy(dto) },
                                onShare: { vm.share(dto) }
                            )
                            .padding(.horizontal, 24)
                            .padding(.vertical, 6)
                        }
                        .listRowInsets(EdgeInsets())
                        .listRowBackground(Color.appPrimarySecondaryBg)
                        .listRowSeparator(.hidden)
                    }
                    .onDelete(perform: { indexSet in
                        deleteItems(at: indexSet, for: dateTitle)
                    })
                }
                .background(Color.appPrimarySecondaryBg)
            }
            
        }
        .background(.appPrimarySecondaryBg)
    }
    
    // Function to delete the selected items
    private func deleteItems(at offsets: IndexSet, for dateTitle: String) {
        guard let dtosToDelete = vm.groupedDtos[dateTitle] else { return }
        
        for index in offsets {
            let dto = dtosToDelete[index]
            vm.delete(dto)
        }
    
//        vm.groupDtosByDate()
    }
}
