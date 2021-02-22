//
// BaseLogger.swift
// BaseFoundation
//
//  Created by VJ on 10/09/19.
//  Copyright © 2020 VJ. All rights reserved.
//

import Foundation

/// Logger class for the app - All Logs should be printed from this class
open class BaseLogger {
    
    static var loggingPrefix : String = "ET"
    
    public static func initialize(appPrefix: String? = nil) {
        if let appPrefix = appPrefix {
            loggingPrefix = appPrefix
        }
    }
    
    public static func infoLog(message: String?) {
        //Make sure all logs should be printed only in debug configuration
        // If app build in release configuration then these logs should be disabled.
        #if DEBUG
        print("\(loggingPrefix) - Info - \(message ?? "")")
        #endif
    }
    
    public static func errorLog(message: String?) {
        //Make sure all logs should be printed only in debug configuration
        // If app build in release configuration then these logs should be disabled.
        #if DEBUG
        print("ET - Error - \(message ?? "")")
        #endif
    }
    
    public static func dataLog(message: String?) {
        //Make sure all logs should be printed only in debug configuration
        // If app build in release configuration then these logs should be disabled.
        #if DEBUG
        //print("ET - Data Log - \(message ?? "")")
        #endif
    }
}
