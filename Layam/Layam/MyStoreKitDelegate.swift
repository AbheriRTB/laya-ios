//
//  MyStoreKitDelegate.swift
//  Layam
//
//  Created by Prasanna Ramaswamy on 17/12/18.
//  Copyright © 2018 Abheri. All rights reserved.
//

import Foundation
import StoreKit

class MyStoreKitDelegate: NSObject {
    
    let monthlySubID = "mpnthly_subscription"
    //let yearlySubID = "MyApp.sub.allaccess.yearly"
    var products: [String: SKProduct] = [:]
    
    func fetchProducts() {
        let productIDs = Set([monthlySubID])
        let request = SKProductsRequest(productIdentifiers: productIDs)
        request.delegate = self
        request.start()
    }
    
    func purchase(productID: String) {
        if let product = products[productID] {
            let payment = SKPayment(product: product)
            SKPaymentQueue.default().add(payment)
        }
    }
    
    func restorePurchases() {
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
}

extension MyStoreKitDelegate: SKProductsRequestDelegate {
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        response.invalidProductIdentifiers.forEach { product in
            print("Invalid: \(product)")
        }
        
        response.products.forEach { product in
            print("Valid: \(product)")
            products[product.productIdentifier] = product
        }
    }
    
    func request(_ request: SKRequest, didFailWithError error: Error) {
        print("Error for request: \(error.localizedDescription)")
    }
    
}
