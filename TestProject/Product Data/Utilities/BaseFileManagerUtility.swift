//
// BaseFileManagerUtility.swift
// BaseFoundation
//
//  Created by VJ on 26/08/19.
//  Copyright © 2020 VJ. All rights reserved.
//

import Foundation

/// File manager utility
class BaseFileManagerUtility {
    
    /// Read data from file name
    ///
    /// - Parameters:
    ///   - fileName: Name of the file
    ///   - type: Type of the file
    ///   - bundle: Bundle in which the file
    /// - Returns: Data or nil
    static func dataFromBundle(fileName: String, type: String? = "json", bundle: Bundle? = Bundle.main) -> Data? {
        guard let path = bundle!.path(forResource: fileName, ofType: type!) else {
            BaseLogger.errorLog(message: "ETFileManagerUtility - Error in Forming URL")
            return nil
        }
        do {
            let url = URL(fileURLWithPath: path)
            let data = try Data(contentsOf: url)
            return data
        } catch let error {
            BaseLogger.errorLog(message: "ETFileManagerUtility - Error - \(error.localizedDescription)")
        }
        return nil
    }
    
    /// Save data in document directory with file path name provided
    ///
    /// - Parameters:
    ///   - data: Data to be written
    ///   - filePath: File Path and file name to which data should be saved in documents diectory
    /// - Returns: Status whether saved sucessfully or not
    static func saveDataInDocumentsFileSystem(data: Data, filePath: String) -> Bool {
        do {
            let fileManager = FileManager.default
            let documentsDir = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let fileUrl =  documentsDir.appendingPathComponent(filePath)
            var tempFolderUrl = fileUrl
            tempFolderUrl.deleteLastPathComponent()
            try fileManager.createDirectory(at: tempFolderUrl, withIntermediateDirectories: true, attributes: nil)
            try data.write(to: fileUrl, options: .atomicWrite)
            BaseLogger.infoLog(message: "ETFileManagerUtility - File write sucessfully at path - \(fileUrl.absoluteString)")
        } catch let error {
            BaseLogger.errorLog(message: "ETFileManagerUtility - Error - \(error.localizedDescription)")
            return false
        }
        return true
    }
    
    /// Read data from the file path from Document directory
    ///
    /// - Parameter filePath: File path of the file
    /// - Returns: Data or nil
    static func readDataFromDocumentsFileSystem(filePath: String) -> Data? {
        do {
            let fileManager = FileManager.default
            let documentsDir = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            let fileUrl =  documentsDir.appendingPathComponent(filePath)
            let data = try Data(contentsOf: fileUrl)
            return data
        } catch let error {
            BaseLogger.errorLog(message: "ETFileManagerUtility - Error - \(error.localizedDescription)")
            return nil
        }
    }
}
