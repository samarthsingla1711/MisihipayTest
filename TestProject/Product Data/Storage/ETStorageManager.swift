//
// BaseStorage.swift
// BaseFoundation
//
//  Created by VJ on 30/08/19.
//  Copyright © 2020 VJ. All rights reserved.
//

import Foundation

struct BaseStorageManagerConstants {
    static let baseDirectoryPathForStoringWebServiceCallsData = "WebServiceCallsData"
}

/// Storage manager to store data in documents directory - Base path is document directory
class ETStorageManager {
    
    /// Store data for specific url in document directory
    ///
    /// - Parameters:
    ///   - data: Data which needs to be stored
    ///   - url: Url from which data comes from
    ///   - httpMethod: Http method of the url
    ///   - fileExtension: File extension in which data needs to be stored. By default json should be stored
    static func storeURLData(data: Data, url: URL?, httpMethod: String?, fileExtension: String? = "json") {
        guard let url = url else {
            BaseLogger.errorLog(message: "ETStorageManager - Url is nil")
            return
        }
        var urlStr = url.absoluteString
        
        /// Append method in the url so that md5 would be generated incorporating the method as well
        if let httpMethod = httpMethod {
            urlStr.append(httpMethod)
        }
        
        /// Generate unique md5 file name
        let md5UniqueFileName = BaseUtilities.md5UniqueKey(string: urlStr)
        let filePath = "\(BaseStorageManagerConstants.baseDirectoryPathForStoringWebServiceCallsData)/\(md5UniqueFileName).\(fileExtension ?? "json")"
        storeData(data: data, filePath: filePath)
    }
    
    /// Read data for specific url from document directory
    ///
    /// - Parameters:
    ///   - url: Url from which data comes from
    ///   - httpMethod: Http method of the url
    ///   - fileExtension: File extension in which data needs to be stored. By default json should be stored
    static func fetchURLData(url: URL?, httpMethod: String?, fileExtension: String? = "json") -> Data? {
        BaseLogger.infoLog(message: "ETStorageManager - DataFetch from ETMStorage - URL - \(url?.absoluteString ?? "")")
        
        guard let url = url else {
            BaseLogger.errorLog(message: "ETStorageManager - Url is nil")
            return nil
        }
        
        var urlStr = url.absoluteString
        
        /// Append method in the url so that md5 would be generated incorporating the method as well
        if let httpMethod = httpMethod {
            urlStr.append(httpMethod)
        }
        
        /// Generate unique md5 file name
        let md5UniqueFileName = BaseUtilities.md5UniqueKey(string: urlStr)
        let filePath = "\(BaseStorageManagerConstants.baseDirectoryPathForStoringWebServiceCallsData)/\(md5UniqueFileName).\(fileExtension ?? "json")"
        return fetchData(filePath: filePath)
    }
    
    
    //MARK: - Helper
    
    /// Store data in documents
    ///
    /// - Parameters:
    ///   - data: Data to be stored in document directory
    ///   - filePath: File path including file name and extension
    private static func storeData(data: Data, filePath: String) {
        if !BaseFileManagerUtility.saveDataInDocumentsFileSystem(data: data, filePath: filePath) {
            BaseLogger.errorLog(message: "ETStorageManager - Error in saving data")
        }
    }
    
    /// Fetch data from file path
    ///
    /// - Parameter filePath: File path including file name and extension
    /// - Returns: Data in the file
    private static func fetchData(filePath: String) -> Data? {
        return BaseFileManagerUtility.readDataFromDocumentsFileSystem(filePath: filePath)
    }
}
