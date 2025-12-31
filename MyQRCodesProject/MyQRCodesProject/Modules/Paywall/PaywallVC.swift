//
//  PaywallVC.swift
//  MyQRCodesProject
//
//  Created by George Popkich on 30.12.25.
//

import SwiftUI

struct PaywallVC: View {
    
    private enum Const {
        static let restoreButtonTitle: String = "Restore"
        static let continueButtonTitle: String = "Continue"
        static let title: String = "Unlock Full QR\nTools"
        static let subtitle: String = "Unlimited scans, custom QR creation, and full\nhistory access."
        static let footerDescription: String = "Auto-renewable. Cancel anytime."
        static let terms: String = "Terms of Service"
        static let privacy: String = "Privacy Policy"
    }
    
    @Environment(\.dismiss) private var dismiss
    
    @StateObject private var vm: PaywallViewModel
    
    init(viewModel: PaywallViewModel) {
        self._vm = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            
            VStack() {
               
                ZStack {
                    Image(.paywallCircleBg)
                        .resizable()
                        .scaledToFill()
                        .clipped()
                        .padding(.horizontal, -54)
                        .frame(maxHeight: 400)
                    VStack {
                        header
                        heroImage
                        subtitle
                    }
                }
                .padding(.bottom, 32)
                
                descriptionCards
                productCards
                continueButton
                footer
            }
            .padding(.horizontal, 24)
        }
        .background(LinearGradient.paywallOnbBg)
        
        .onReceive(vm.$showErrorAlert) { show in
            if show {  }
        }
        .onReceive(vm.$finish) { finish in
            if finish { dismiss() }
        }
        .alert("Ops..", isPresented: $vm.showErrorAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(vm.errorMessage)
        }
    }
    
    private var header: some View {
        HStack {
            Button(action: { dismiss() }) {
                ZStack {
                    Circle()
                        .fill(Color.appPrimaryBg)
                        .frame(width: 40, height: 40)
                    Image(.iconCross)
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundStyle(.appTextSecondary)
                }
                .contentShape(Rectangle())
            }

            Spacer()

            Button(action: { vm.restoredidTap.send() }) {
                Text(Const.restoreButtonTitle)
                    .font(.inter(size: 17, style: .semiBold))
                    .foregroundStyle(.appTextSecondary)
            }
        }
        .padding(.vertical, 24)
    }
    
    private var heroImage: some View {
        Image(.paywallMain)
            .frame(width: 217, height: 217)
            
    }

    private var subtitle: some View {
        VStack(alignment: .center, spacing: 13) {
            Text(Const.title)
                .font(.inter(size: 34, style: .bold))
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
                .foregroundStyle(.appTextPrimary)
            Text(Const.subtitle)
                .font(.inter(size: 15, style: .regular))
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
                .foregroundStyle(.appTextPrimary)
        }
    }
    
    private var descriptionCards: some View {
        ForEach(DescriptionSection.allCases, id: \.self) { card in
            PaywallDescriptionCard(card: card)
                .padding(.bottom, 8)
        }
    }
    
    private var productCards: some View {
        VStack(spacing: 16) {
            PaywallWeeklyProductCard(
                price: vm.weeklyProduct?.price ?? "$3.99",
                isTrial: true,
                isPopular: true,
                selectedPlan: $vm.selectedProduct)
            
            PaywallMonthlyProductCard(
                price: vm.monthlyProduct?.price ?? "$7.99",
                isTrial: false,
                isPopular: false,
                selectedPlan: $vm.selectedProduct)
        }
        .padding(.top, 16)
    }
    
    private var continueButton: some View {
        ActionButton(
            title: Const.continueButtonTitle,
            didTap: { vm.continueDidTap.send(()) }
        )
        .padding(.top, 32)
    }
    
    private var footer: some View {
        VStack(spacing: 8) {
            Text(Const.footerDescription)
                .inter(size: 13, color: .appTextSecondary)
            HStack(spacing: 18) {
                Button(action: { vm.termsDidTap.send() }) {
                    Text(Const.terms)
                        .underline()
                        .inter(size: 13, color: .appTextSecondary)
                }
                
                Text("•")
                    .inter(size: 13, color: .appTextSecondary)
                
                Button(action: { vm.privacyDidTap.send() }) {
                    Text(Const.privacy)
                        .underline()
                        .inter(size: 13, color: .appTextSecondary)
                }
                
            }
        }
        .padding(.top, 16)
    }
    
}
