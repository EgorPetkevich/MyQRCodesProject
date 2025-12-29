//
//  OnbFourthScreenVC.swift
//  MyQRCodesProject
//
//  Created by George Popkich on 30.12.25.
//

import SwiftUI

struct OnbFourthScreenVC: View {
    
    @Environment(OnbRouter.self) private var router
    @AppStorage(.onboardingPassed) private var onboardingPassed: Bool = false
    
    private enum Const {
        static let title: String = "Manage & Share"
        static let subtitle: String = "Save, Share, and Track All\nYour QR Codes"
        static let subtitleSecondLine: String = "Access My QR Codes and History anytime"
        static let nextButtonTitle: String = "Next"
        static let currentPage: Int = 3
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            title
            heroImage
            
            Spacer(minLength: 0)
            
            bottomBlock
        }
        .background(LinearGradient.appOnbBg)
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }
    
    private var title: some View {
        Text(Const.title)
            .font(.app(.largeTitle))
            .foregroundStyle(.appTextPrimary)
            .padding(.top, 44)
            .padding(.bottom, 28)
    }
    
    private var heroImage: some View {
        Image(.onbFourth)
            .resizable()
            .scaledToFill()
            .padding(.horizontal, 76)
            .padding(.bottom, 29)
    }
    
    private var bottomBlock: some View {
        VStack(spacing: 0) {
            subtitle
            pageControl
            actions
        }
    }
    
    private var subtitle: some View {
        VStack(alignment: .center, spacing: 12) {
            Text(Const.subtitle)
                .font(.inter(size: 24, style: .semiBold))
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
                .foregroundStyle(.appTextPrimary)
            Text(Const.subtitleSecondLine)
                .font(.inter(size: 16, style: .regular))
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
                .foregroundStyle(.appTextPrimary)
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 39)
    }

    private var pageControl: some View {
        PageControl(currentPage: Const.currentPage)
            .padding(.bottom, 21)
    }
    
    private var actions: some View {
        ActionButton(
            title: Const.nextButtonTitle,
            didTap: { onboardingPassed = true }
        )
        .padding(.horizontal, 24)
        .padding(.bottom, 71)
    }
}
