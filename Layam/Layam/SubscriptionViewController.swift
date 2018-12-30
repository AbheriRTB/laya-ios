//
//  SubscriptionViewController.swift
//  Layam
//
//  Created by Prasanna Ramaswamy on 19/12/18.
//  Copyright © 2018 Abheri. All rights reserved.
//

import Foundation
import UIKit
import StoreKit


protocol SubscriptionViewControllerDelegate {
    
    func didBuyColorsCollection(collectionIndex: Int)
    
}

class SubscriptionTableViewCell: UITableViewCell {
    @IBOutlet weak var cellLabel: UILabel!
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var detailCellLabel: UILabel!
    
}


class SubscriptionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, SKProductsRequestDelegate, SKPaymentTransactionObserver {
    
    
    @IBOutlet weak var tblProducts1: UITableView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    var delegate: SubscriptionViewControllerDelegate!
    
    var productIDs: Array<String?> = []
    
    var productsArray: Array<SKProduct?> = []
    
    var selectedProductIndex: Int!
    
    var transactionInProgress = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        tblProducts1.delegate = self
        tblProducts1.dataSource = self
        
        tblProducts1.layer.borderWidth = 1.0
        tblProducts1.layer.borderColor = UIColor.lightGray.cgColor
        tblProducts1.backgroundColor=UIColor.clear
        
        
        // Replace the product IDs with your own values if needed.
        //productIDs.append("iapdemo_extra_colors_col1")
        //productIDs.append("iapdemo_extra_colors_col2")
        
        productIDs.append("weekly_renewable")
        productIDs.append("monthly_renewable")
        productIDs.append("buy_layam")
        productIDs.append("monthly_subscription")
        
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.startAnimating()
        requestProductInfo()
        
        SKPaymentQueue.default().add(self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    
    // MARK: IBAction method implementation
    
    
    @IBAction func dismiss(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: UITableView method implementation
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productsArray.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "idCellProduct", for: indexPath) as! SubscriptionTableViewCell
        
        let product = productsArray[indexPath.row]
        cell.cellLabel?.backgroundColor=UIColor.clear
        cell.cellLabel?.text = product?.localizedTitle
        let detail = (product?.localizedDescription)! + " @ " + (product?.price.stringValue)! + " " + (product?.priceLocale.currencyCode)!
        cell.detailCellLabel?.text = detail
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
    
    
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedProductIndex = indexPath.row
        showActions()
        tableView.cellForRow(at: indexPath as IndexPath)?.isSelected = false
    }
    
   
    
    // MARK: Custom method implementation
    
    func requestProductInfo() {
        if SKPaymentQueue.canMakePayments() {
            let productIdentifiers = NSSet(array: productIDs as [Any])
            let productRequest = SKProductsRequest(productIdentifiers: productIdentifiers as Set<NSObject> as! Set<String>)
            
            productRequest.delegate = self
            productRequest.start()
        }
        else {
            print("Cannot perform In App Purchases.")
        }
    }
    
    
    func showActions() {
        if transactionInProgress {
            return
        }
        
        let actionSheetController = UIAlertController(title: "Layam Purchase", message: "What do you want to do?", preferredStyle: UIAlertControllerStyle.actionSheet)
        
        let buyAction = UIAlertAction(title: "Buy", style: UIAlertActionStyle.default) { (action) -> Void in
            let payment = SKPayment(product: self.productsArray[self.selectedProductIndex] as! SKProduct!)
            SKPaymentQueue.default().add(payment)
            self.transactionInProgress = true
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) { (action) -> Void in
            
        }
        
        actionSheetController.addAction(buyAction)
        actionSheetController.addAction(cancelAction)
        
        present(actionSheetController, animated: true, completion: nil)
    }
    
    
    // MARK: SKProductsRequestDelegate method implementation
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        if response.products.count != 0 {
            for product in response.products {
                productsArray.append(product)
            }
            
            tblProducts1.reloadData()
            loadingIndicator.stopAnimating()
        }
        else {
            print("There are no products.")
        }
        
        if response.invalidProductIdentifiers.count != 0 {
            print(response.invalidProductIdentifiers.description)
        }
    }
    
    
    // MARK: SKPaymentTransactionObserver method implementation

    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case SKPaymentTransactionState.purchased:
                print("Transaction completed successfully.")
                SKPaymentQueue.default().finishTransaction(transaction)
                transactionInProgress = false
                delegate.didBuyColorsCollection(collectionIndex: selectedProductIndex)
                
                
            case SKPaymentTransactionState.failed:
                print("Transaction Failed");
                SKPaymentQueue.default().finishTransaction(transaction)
                transactionInProgress = false
                
            default:
                print(transaction.transactionState.rawValue)
            }
        }
    }
    
}
