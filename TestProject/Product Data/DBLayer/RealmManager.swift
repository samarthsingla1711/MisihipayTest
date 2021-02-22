//
//  RealmManager.swift
//  Locate
//
//  Created by samarth on 15/10/20.
//

import UIKit

class RealmManager {

    var storage: StorageContext?
    
    static let sharedInstance = RealmManager()
    
    init() {
        do {
            try self.storage = RealmStorageContext(configuration: ConfigurationType.basic(url:nil))
        } catch {
        }
    }
}
