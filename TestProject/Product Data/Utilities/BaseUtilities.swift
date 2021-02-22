//
//  BaseUtilities.swift
// BaseFoundation
//
//  Created by VJ on 26/08/19.
//  Copyright © 2020 VJ. All rights reserved.
//

import Foundation
import Alamofire
import CommonCrypto

open class BaseUtilities {
    
    static let reachabilityManager = NetworkReachabilityManager()

    //MARK: - Error
    
    /// Create error object from message and status code
    ///
    /// - Parameters:
    ///   - msg: Message for the error
    ///   - statusCode: Status code of the error
    /// - Returns: Error
    static public func createError(msg: String? = nil, statusCode: Int? = 500) -> Error {
        let errorCode = statusCode ?? 500
        let msg = msg ?? "Some error occured. Please try later."
        return NSError(domain: "", code: errorCode, userInfo: [NSLocalizedDescriptionKey:msg]) as Error
    }
    
    //MARK:- Network Change
    
    /// Is network available
    static public var isNetworkAvailable : Bool {
        return reachabilityManager?.isReachable ?? false
    }
    
    /// Start network change listner which listen to all network changes and execute the completion handler
    ///
    /// - Parameter completionHandler: Completion handler which need to execute on network change
    static public func startNetworkChangeListener() {
//        reachabilityManager?.startListening()
//        reachabilityManager?.listener = {_ in
//            NotificationCenter.default.post(name: .networkChange, object: nil)
//        }
    }
    
    /// Stop network change listener
    static public func stopNetworkChangeListener() {
        reachabilityManager?.stopListening()
    }
    
    //MARK: - Dump Responses
    
    /// Should dump responses in documents directory
    ///
    /// - Returns: True or false
    static public var shouldDumpResponses : Bool {
        return ProcessInfo.processInfo.environment["DumpResponses"] != nil
    }
    
    /// Return md5 unique key from url
    ///
    /// - Parameter url: URL which should be converted to uniqe key
    /// - Returns: MD5 encoded string
    static public func md5UniqueKey(string: String) -> String {
        let length = Int(CC_MD5_DIGEST_LENGTH)
        var digest = [UInt8](repeating: 0, count: length)
        if let d = string.data(using: String.Encoding.utf8) {
            _ = d.withUnsafeBytes { (body: UnsafePointer<UInt8>) in
                CC_MD5(body, CC_LONG(d.count), &digest)
            }
        }
        return (0..<length).reduce("") {
            $0 + String(format: "%02x", digest[$1])
        }
    }
    
    /// Should fetch from storage
    ///
    /// - Parameter storage info: Storage info
    /// - Returns: Bool if fetch from storage of not
    static func shouldFetchFromStorage(storageInfo: BaseStorageInfo?) -> Bool {
        if let storageInfo = storageInfo, storageInfo.isEnabled, let lastModifiedDate = storageInfo.lastModifiedDate {
            //If Storage enabled then check if time of storage expires
            let difference =  Date().timeIntervalSince(lastModifiedDate)
            return difference >= 0 ? difference < storageInfo.expirationTimeInterval : false
        }
        return false
    }
}
