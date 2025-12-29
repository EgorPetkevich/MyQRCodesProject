//
//  OnbSecondScreenVC.swift
//  MyQRCodesProject
//
//  Created by George Popkich on 29.12.25.
//

import SwiftUI

struct OnbSecondScreenVC: View {
    
    @Environment(OnbRouter.self) private var router
    @AppStorage(.onboardingPassed) private var onboardingPassed: Bool = false
    
    private enum Const {
        static let title: String = "Scan QR Codes"
        static let subtitle: String = "Quickly Scan Any QR Code"
        static let subtitleSecondLine: String = "Align QR codes in frame and get instant\nresults"
        static let nextButtonTitle: String = "Next"
        static let skipButtonTitle: String = "Skip"
        static let currentPage: Int = 1
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
            .padding(.bottom, 43)
    }
    
    private var heroImage: some View {
        Image(.onbSecond)
            .resizable()
            .scaledToFill()
            .padding(.horizontal, 47)
            .padding(.bottom, 43)
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
            .padding(.bottom,21)
    }
    
    private var actions: some View {
        VStack(spacing: 13) {
            ActionButton(
                title: Const.nextButtonTitle,
                didTap: { router.openThird() }
            )
            TextButton(
                title: Const.skipButtonTitle,
                didTap: { onboardingPassed = true }
            )
        }
        .padding(.horizontal, 24)
        .padding(.bottom, 33)
    }
}
