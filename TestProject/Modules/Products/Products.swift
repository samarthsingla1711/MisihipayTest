//
//  Products.swift
//  TestProject
//
//  Created by samarth on 16/02/21.
//

import Foundation
import RealmSwift

public class Products: Object {
    
    @objc dynamic var title: String? = ""
    @objc dynamic var price: NSNumber? = NSNumber(value:0.0)
    @objc dynamic var image : String? = ""
    @objc dynamic var productId : String? = ""

    override public static func primaryKey() -> String? {
        return "productId"
    }
    
    override public var description: String {
        return title ?? ""
    }
    
    func toLocalProduct()->ProductLocal {
        
        var productLocal = ProductLocal()
        productLocal.title = self.title
        productLocal.image = self.image
        productLocal.price = self.price
        productLocal.productId = self.productId
        
        return productLocal
    }
    
}

struct ProductLocal {
    var title: String? = ""
    var price: NSNumber? = NSNumber(value:0.0)
    var image : String? = ""
    var productId : String? = ""
}
