//
// BaseMAppInitializer.swift
//  Locate
//
//  Created by VJ on 26/08/19.
//  Copyright © 2020 VJ. All rights reserved.
//

import RealmSwift

/// All the initializations related to the app would be done in this class like analytics, any sdk initialization etc
class AppInitializer {
    
    /// Initialization of the app
    static func initializeApp() {
        self.addDummyDataInDB()
    }
    
    static func addDummyDataInDB(){
        
        RealmManager.sharedInstance.storage?.fetch(Products.self, predicate: nil, sorted: nil, completion: {(records) in
            if records.count < 1 {
                AppInitializer.product1()
                AppInitializer.product2()
            }
        })
        
    }

    static func product1(){
        do {
            let product = Products()
            product.title = "Handbag"
            product.price = NSNumber(value:100.15)
            product.productId = "12345"
            product.image = "https://images-na.ssl-images-amazon.com/images/I/71bdgYfofhL._UL1500_.jpg"
            
            try RealmManager.sharedInstance.storage?.save(object: product)
            
        } catch _ as NSError {
        }
    }
    
    static func product2(){
        do {
            let product = Products()
            product.title = "Wallet"
            product.price = NSNumber(value:120.15)
            product.productId = "12346"
            product.image = "https://staticimg.titan.co.in/Titan/Catalog/TW226LM1TN_1.jpg?pView=pdp"
            
            try RealmManager.sharedInstance.storage?.save(object: product)
            
        } catch _ as NSError {
        }
    }
    
}
