//
//  PaywallWeeklyProductCard.swift
//  MyQRCodesProject
//
//  Created by George Popkich on 31.12.25.
//

import SwiftUI

struct PaywallWeeklyProductCard: View {
    
    private enum Const {
        static let title: String = "Weekly Plan"
        static let priceSlash: String = "/ week"
        static let cancelAnyTime: String = "Cancel anytime"
        static let trialPeriod: String = "3-day free trial"
        static let cardRadius: CGFloat = 18
    }
    
    var price: String
    var isTrial: Bool
    var isPopular: Bool
    @Binding var selectedPlan: ProductType
    
    var body: some View {
        
        VStack(alignment: .center) {
            Text(Const.title)
                .inter(size: 22, style: .semiBold)
             
            HStack {
                Text(price)
                    .inter(size: 28, style: .semiBold)
                VStack {
                    Spacer()
                    Text(Const.priceSlash)
                        .inter(size: 17, color: .appTextSecondary)
                }
                
            }
            .padding(.top, 8)
            .padding(.bottom, 16)
            
            Text(isTrial ? Const.trialPeriod : Const.cancelAnyTime)
                .inter(size: 15, color: .appTextSecondary)
            
        }
        .padding(.vertical, 24.0)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: Const.cardRadius)
                .fill(.appPrimaryBg)
                .setShadow(
                    with: Const.cardRadius,
                    color: selectedPlan == .weekly ? .appAccentPrimary.opacity(0.45) : .black.opacity(0.06)
                )
        )
        .overlay(
            RoundedRectangle(cornerRadius: Const.cardRadius)
                .stroke(selectedPlan == .weekly ? .appAccentPrimary : .appTextBorder, lineWidth: 1)
        )
        .onTapGesture {
            selectedPlan = .weekly
        }
    }
    
}
