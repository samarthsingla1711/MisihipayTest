//
//  BaseViewModel.swift
//  BaseFoundation
//
//  Created by VJ on 11/09/19.
//  Copyright © 2020 VJ. All rights reserved.
//

import Foundation

public protocol BaseViewModelDelegate: class {
    func viewModelDidUpdate(error: Error?)
    func viewModelDidUpdate<T>(error: Error?,data: Any?,model: T.Type)
}

/// View Model Base for all view model. Supports multiple datamanger and calls
open class BaseViewModel: BaseDataManagerDelegate {
    //Delegate
    weak public var delegate: BaseViewModelDelegate?
    
    /// Data Manager assigned for View Model
    public var dataManagers: [BaseDataManager] = []
    
    public init() {
    }
    
    /// Register Data Manager for Notifications
    public func registerDataManagerForNotifications(dataManager: BaseDataManager) {
        NotificationCenter.default.addObserver(self, selector: #selector(dataManagerDidUpdate(notification:)), name: NSNotification.Name(String(describing: type(of: dataManager))), object: nil)
    }
    
    /// Delegate for Data Manager Did update
    ///
    /// - Parameters:
    ///   - dataManager: Datamanager
    ///   - data: Data or nil
    ///   - error: Error or nil
    @objc open func dataManagerDidUpdate(notification: Notification?) {
        //Remove the relevant Data Manager so that memory wont be used. Data from service is in notification . Store it in view model and update the UI
        if let identifier = notification?.userInfo?[BaseDataManagerConstants.identifierKey] as? String {
            dataManagers.removeAll(where: { (dataManager) -> Bool in
                if String(describing: type(of: dataManager)) == identifier {
                    //This will remove the observer associated with the view model
                    NotificationCenter.default.removeObserver(self, name: NSNotification.Name(String(describing: type(of: dataManager))), object: nil)
                    return true
                }
                return false
            })
        }
    }
}
