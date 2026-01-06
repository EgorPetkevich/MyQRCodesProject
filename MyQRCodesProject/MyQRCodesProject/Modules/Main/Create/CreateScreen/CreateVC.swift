//
//  CreateVC.swift
//  MyQRCodesProject
//
//  Created by George Popkich on 6.01.26.
//

import SwiftUI

struct CreateVC: View {
    
    private enum Const {
        static let title: String = "Create QR Code"
        static let actionButtonTitle: String = "Generate QR Code"
    }

    @Environment(TabBarState.self) private var tabBar
    
    @FocusState private var focusedField: CreateField?
    @StateObject private var keyboard = KeyboardObserver()
    @State private var selectedImage: UIImage? = nil
    @State private var showImagePicker = false
    
    @StateObject private var vm: CreateVM
    
    
    init(viewModel: CreateVM) {
        self._vm = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            header
            scrollContent
        }
        .ignoresSafeArea(edges: .top)
        .onTapGesture {
            UIApplication.shared.hideKeyboard()
        }
        .sheet(isPresented: $showImagePicker) {
            PhotoPicker(image: $selectedImage)
        }
    }
    
    private var scrollContent: some View {
        ScrollViewReader { proxy in
            ScrollView(showsIndicators: false) {
                contentStack
            }
            .background(.appPrimarySecondaryBg)
            .onChange(of: focusedField) { _, field in
                guard let field else { return }

                DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                    withAnimation(.easeInOut) {

                        proxy.scrollTo(field, anchor: .center)
                    }
                }
            }
        }
    }
    
    private var contentStack: some View {
        VStack(spacing: 24) {

            contentTypeSection

            CreateQRFormView(vm: vm, focusedField: $focusedField)

            designOptionsSection
            
            ActionButton(
                title: Const.actionButtonTitle,
                didTap: {
                    vm.generateButtonDidTap()
                }
            )
            
        }
        .padding(.top, 21)
        .padding(.horizontal, 24)
        .padding(.bottom, keyboard.height + tabBar.bottomSafeAreaInset)
        .animation(.easeOut(duration: 0.25), value: keyboard.height + tabBar.bottomSafeAreaInset)
    }
    
    private var contentTypeSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Content Type")
                .inter(size: 16, style: .semiBold)

            VStack(spacing: 24) {

                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ], spacing: 8) {

                    ForEach(QRContentType.allCases.filter { $0 != .wifi }) { type in
                        ContentTypeCard(
                            type: type,
                            isSelected: vm.selectedType == type
                        ) {
                            vm.selectedType = type
                        }
                    }
                }

                ContentTypeCard(
                    type: .wifi,
                    isSelected: vm.selectedType == .wifi
                ) {
                    vm.selectedType = .wifi
                }
            }
        }
    }
    
    
    private var header: some View {
        HStack {
            VStack {
                Spacer()
                Text(Const.title)
                    .inter(size: 22, style: .semiBold)
                    .padding(.bottom, 16)
            }
            
            Spacer()
            
        }
        .padding(.horizontal, 24)
        .frame(height: 100)
        .background(Color.appPrimaryBg)
    }
    
    private var designOptionsSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Design Options")
                .inter(size: 17, style: .semiBold)
            
            Button(action: {
                showImagePicker = true
            }) {
                
                VStack {
                    
                    HStack {
                        Text("Image")
                            .inter(size: 15, style: .medium)
                            .foregroundColor(.appPrimaryBg)
                        
                        Spacer()
                        if let image = selectedImage {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 40, height: 40)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        } else {
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                                .frame(width: 40, height: 40)
                                .overlay(
                                    Image(systemName: "photo")
                                        .foregroundColor(.gray)
                                )
                        }
                    }
                    
                    HStack {
                        Text("+ Add Logo")
                            .inter(size: 15, style: .medium)
                            .foregroundColor(.appPrimaryBg)
                        
                        Spacer()
                        
                        Text("Pro Feature")
                            .inter(size: 13, style: .regular, color: .appTextSecondary)
                        
                    }
                    
                }
                
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.appTextBorder, lineWidth: 1)
                        .background(Color.white.cornerRadius(12))
                )
            }
        }
    }
    
}
