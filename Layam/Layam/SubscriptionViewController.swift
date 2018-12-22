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


class SubscriptionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, SKProductsRequestDelegate, SKPaymentTransactionObserver {
    
    
    
    @IBOutlet weak var tblProducts: UITableView!
    
    
    var delegate: SubscriptionViewControllerDelegate!
    
    var productIDs: Array<String?> = []
    
    var productsArray: Array<SKProduct?> = []
    
    var selectedProductIndex: Int!
    
    var transactionInProgress = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        tblProducts.delegate = self
        tblProducts.dataSource = self
        
        
        // Replace the product IDs with your own values if needed.
        productIDs.append("iapdemo_extra_colors_col1")
        productIDs.append("iapdemo_extra_colors_col2")
        
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
    
    @IBAction func dismiss(sender: AnyObject) {
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "idCellProduct", for: indexPath) as! UITableViewCell
        
        let product = productsArray[indexPath.row]
        cell.textLabel?.text = product?.localizedTitle
        cell.detailTextLabel?.text = product?.localizedDescription
        
        return cell
    }
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80.0
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
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
        
        let actionSheetController = UIAlertController(title: "IAPDemo", message: "What do you want to do?", preferredStyle: UIAlertControllerStyle.actionSheet)
        
        let buyAction = UIAlertAction(title: "Buy", style: UIAlertActionStyle.default) { (action) -> Void in
            let payment = SKPayment(product: self.productsArray[self.selectedProductIndex] as! SKProduct)
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
            
            tblProducts.reloadData()
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