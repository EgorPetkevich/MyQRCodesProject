//
//  PaywallProduct.swift
//  MyQRCodesProject
//
//  Created by George Popkich on 8.01.26.
//

import StoreKit
import ApphudSDK

struct PaywallProduct: Identifiable {
    let id: String
    let price: String?
    let period: Product.SubscriptionPeriod.Unit.FormatStyle?
    let apphudProduct: ApphudProduct?

    init(product: ApphudProduct) async {
        self.id = product.productId
        self.price = product.skProduct?.formattedPrice
        self.period = try? await product.product()?.subscriptionPeriodUnitFormatStyle
        self.apphudProduct = product
    }
}
