//
//  ProductViewModel.swift
//  TestProject
//
//  Created by samarth on 16/02/21.
//

import UIKit

class ProductViewModel: BaseViewModel {

    private var product : ProductLocal?
    private var productId: String?
    
    init(withProductId productId: String?) {
        super.init()
        self.productId = productId
    }
   
    func getProductDetails() {
        
        guard let tempProductId = self.productId else {
            self.delegate?.viewModelDidUpdate(error: nil,data:self.product,model:ProductViewModel.self)
            return
        }
        
        let resultPredicate = NSPredicate(format: "productId == %@", tempProductId)
        
        RealmManager.sharedInstance.storage?.fetch(Products.self, predicate:resultPredicate, sorted: nil, completion: { [weak self](records) in
            if records.count > 0 {
                self?.product = records.first?.toLocalProduct()
                self?.delegate?.viewModelDidUpdate(error: nil,data:self?.product,model:ProductViewModel.self)
                
            } else {
                self?.delegate?.viewModelDidUpdate(error: nil,data:self?.product,model:ProductViewModel.self)
            }
        })
    }
}
