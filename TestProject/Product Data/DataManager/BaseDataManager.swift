//
//  BaseDataManager.swift
// BaseFoundation
//
//  Created by VJ on 11/09/19.
//  Copyright © 2020 VJ. All rights reserved.
//

import Foundation
import Alamofire

public protocol BaseDataManagerDelegate {
    func dataManagerDidUpdate(notification: Notification?)
}

public struct BaseDataManagerConstants {
    public static let dataKey = "Data"
    public static let errorKey = "Error"
    public static let identifierKey = "Identifier"
}

/// Base Datamanager - Once data fetch is completed or error happen then notification would be fired for the respective data manager
open class BaseDataManager {
    
    //MARK: - Service
    
    //Service Instance on which service needs to be called
    var service = BaseService()
    
    //MARK:- Public - These params can be modified and changed in the service call from the respective datamangers

    /// URL type for the service call
    open var urlType: String = ""
    
    /// URL for the Datamanager
    open var url: URL? = nil
    
    /// Http Method for the service call
    open var httpMethod: HTTPMethod = .get
    
    /// Params passed for the service call
    open var params: [String: AnyObject]?
    
    /// Http Headers for the service call. By default headers will be injected in the service.
    open var headers: HTTPHeaders?
    
    /// Completion handler of the service call
    open var serviceCompletionHandler: ((Data?, Error?) -> Void)?
    
    /// Is storage enabled or not for the url type
    open var isStorageEnabled: Bool = false
    
    /// Expiration time interval in sec
    open var expirationTimeInterval: Double = 0.5 * 60 * 60 // In sec
    
    //MARK:- Private
    
    /// Is call from network
    private var isNetworkLiveCall: Bool = false
    
    private func initializeStorageIfNeeded() {
        if fetchStorageInfo(urlType: urlType) == nil {
            let storageInfo = BaseStorageInfo()
            storageInfo.isEnabled = isStorageEnabled
            storageInfo.expirationTimeInterval = expirationTimeInterval
            storageInfo.urlType = urlType
            updateStorageInfo(storageInfo: storageInfo)
        }
    }
    
    public init() {
        
    }
    
    /// Fetch data from datamanager
    ///
    /// - Parameter forceFromNetwork: is force fetch from network
    public func fetchDataFromDataManager(forceFetchFromNetwork: Bool? = false) {
        guard urlType != "", let url = url else {
            fatalError("Url type cannot be none. Kindly assign proper value before calling this.")
        }
        initializeStorageIfNeeded()
        isNetworkLiveCall = false
        //If force network update then fetch data from network
        if let forceFetchFromNetwork = forceFetchFromNetwork , forceFetchFromNetwork {
            performServiceCall()
        } else if BaseUtilities.shouldFetchFromStorage(storageInfo: fetchStorageInfo(urlType: urlType)) {
            //If fetch from storage is enabled for the url type then only fetch from network
            if let data = ETStorageManager.fetchURLData(url: url, httpMethod: httpMethod.rawValue) {
                //If fetch from data
                serviceCompletionHandler?(data, nil)
            } else {
                //Fetch from network as there is no data in storage
                performServiceCall()
            }
        } else {
            //Else fetch from network
            performServiceCall()
        }
    }
    
    /// Upload data from datamanager
    ///
    /// - Parameter forceFromNetwork: is force fetch from network
    public func uploadDataFromDataManager(forceFetchFromNetwork: Bool? = false) {
        guard urlType != "", let url = url else {
            fatalError("Url type cannot be none. Kindly assign proper value before calling this.")
        }
        initializeStorageIfNeeded()
        isNetworkLiveCall = false
        //If force network update then fetch data from network
        if let forceFetchFromNetwork = forceFetchFromNetwork , forceFetchFromNetwork {
            uploadServiceCall()
        } else if BaseUtilities.shouldFetchFromStorage(storageInfo: fetchStorageInfo(urlType: urlType)) {
            //If fetch from storage is enabled for the url type then only fetch from network
            if let data = ETStorageManager.fetchURLData(url: url, httpMethod: httpMethod.rawValue) {
                //If fetch from data
                serviceCompletionHandler?(data, nil)
            } else {
                //Fetch from network as there is no data in storage
                uploadServiceCall()
            }
        } else {
            //Else fetch from network
            uploadServiceCall()
        }
    }
    
    /// Perform Network Service Call to the url
    private func performServiceCall() {
        isNetworkLiveCall = true
        service.fetchData(url: url, method: httpMethod, headers: headers, params: params, completionHandler: serviceCompletionHandler)
    }

    /// Perform Upload Service Call to the url
    private func uploadServiceCall() {
        isNetworkLiveCall = true
        service.uploadData(url: url, method: httpMethod, headers: headers, params: params, completionHandler: serviceCompletionHandler)
    }

    //MARK: - Notify Observer
    
    /// Notify to the view models about the data manager updation
    ///
    /// - Parameters:
    ///   - data: Data get from the response
    ///   - error: Error or nil
    internal func notify(data: Any?, error: Error?) {
        var userInfo : [String: Any] = [:]
        
        if let error = error {
            //Error
            userInfo = [BaseDataManagerConstants.errorKey : error, BaseDataManagerConstants.identifierKey : String(describing: type(of: self))]
            //Post Notification
            NotificationCenter.default.post(name: NSNotification.Name(String(describing: type(of: self))), object: nil, userInfo: userInfo)
        } else {
            if let data = data {
                userInfo[BaseDataManagerConstants.dataKey] = data
            }
            userInfo[BaseDataManagerConstants.identifierKey] = String(describing: type(of: self))
            //Success
            NotificationCenter.default.post(name: NSNotification.Name(String(describing: type(of: self))), object: nil, userInfo: userInfo)
        }
    }
    
    //MARK:- Storage
    
    /// Update storage info in the dictionary
    ///
    /// - Parameter storageInfo: StorageInfo that needs to be updated.
    private func updateStorageInfo(storageInfo: BaseStorageInfo?) {
        //Update in Settings
        if let storageInfo = storageInfo , let urlType = storageInfo.urlType {
            BaseSettings.setStorageInfo(key: urlType, storageInfo: storageInfo)
        }
    }
    
    /// Fetch storage info
    ///
    /// - Parameter urlType: Url Type
    /// - Returns: Storage Information
    private func fetchStorageInfo(urlType: String) ->  BaseStorageInfo? {
        //Fetch from Setting
        return BaseSettings.getStorageInfo(key: urlType)
    }
    
    /// Store data
    private func storeData(data: Data) {
        //Store Data in ETMStorage
        ETStorageManager.storeURLData(data: data, url: url, httpMethod: httpMethod.rawValue)
        //Update storage info as well
        if let storageInfo = fetchStorageInfo(urlType: urlType) {
            storageInfo.lastModifiedDate = Date()
            updateStorageInfo(storageInfo: storageInfo)
        }
    }
    
    /// Parse Data
    ///
    /// - Parameters:
    ///   - data: Data to be parsed
    ///   - error: Error
    public func parseDataAndNotify<T: Decodable>(data: Data? , error: Error?, model: T.Type) {
        
        if let tempData = data, let tempString = String(data: tempData, encoding: .utf8){
            print("tempData")
        }
        
        
        if let error = error {
            notify(data: nil, error: error)
        } else {
            if  let data = data {
                
                //Parse response
                do {
                    let response = try JSONDecoder().decode(model.self, from: data)
                    //Once data is parsed success then update the storage
                    //Store data if enabled
                    if let storageInfo = fetchStorageInfo(urlType: urlType), storageInfo.isEnabled, isNetworkLiveCall {
                        //if storage is enabled
                        storeData(data: data)
                    }
                    notify(data: response, error: nil)
                } catch let error {
                    BaseLogger.errorLog(message: "ETDataManager - Error Parsing Data - \(error)")
                    notify(data: nil, error: error)
                }
            } else {
                BaseLogger.errorLog(message: "ETDataManager - Error No Data)")
                notify(data: nil, error: BaseUtilities.createError(msg: "Data is nil", statusCode: 500))
            }
        }
    }
}
