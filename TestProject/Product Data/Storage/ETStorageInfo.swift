//
// BaseStorageInfo.swift
// BaseFoundation
//
//  Created by VJ on 30/08/19.
//  Copyright © 2020 VJ. All rights reserved.
//

import Foundation

public class BaseStorageInfo : NSObject, NSSecureCoding {
    
    /// Url Type for which storage properties should be applied
    public var urlType: String?
    
    /// Whether storage should be enabled or not
    public var isEnabled = false
    
    /// Default expiration time - in seconds
    public var expirationTimeInterval: Double = 0.5 * 60 * 60  //In Seconds - 30 min
    
    /// Last time this api was hit and stored
    public var lastModifiedDate: Date?
    
    required override init() {
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(urlType, forKey: "urlType")
        aCoder.encode(isEnabled, forKey: "isEnabled")
        aCoder.encode(expirationTimeInterval, forKey: "expirationTimeInterval")
        aCoder.encode(lastModifiedDate, forKey: "lastModifiedDate")
    }
    
    required public init?(coder aDecoder: NSCoder) {
        urlType = aDecoder.decodeObject(forKey: "urlType") as? String
        isEnabled = aDecoder.decodeBool(forKey: "isEnabled")
        expirationTimeInterval = aDecoder.decodeDouble(forKey: "expirationTimeInterval")
        lastModifiedDate = aDecoder.decodeObject(forKey: "lastModifiedDate") as? Date
    }
    
    public static var supportsSecureCoding: Bool {
        return true
    }
}
