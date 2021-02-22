//
//  BaseSettings.swift
// BaseFoundation
//
//  Created by VJ on 26/08/19.
//  Copyright © 2020 VJ. All rights reserved.
//

import Foundation

fileprivate struct BaseSettingsKey {
    let selectedLanguageKey = "SelectedLanguage"
    let selectedThemeKey = "SelectedTheme"
    let selectedThemeAppearanceKey = "SelectedThemeAppearance"
    let storageInfoKey = "StorageInfoKey"
}

/// Settings will store all app related information in the persistent Userdefaults
open class BaseSettings {
    
    static private let settingsKey = BaseSettingsKey()
    
    //MARK:- Settings stored
    
    /// Selected language
    static public var selectedLanguage : String? {
        set {
            //We will store language if it is not nil else will remove the key
            if let selLanguage = newValue {
                setValueInUserDefault(key: settingsKey.selectedLanguageKey, value: selLanguage)
            } else {
                removeFromUserDefault(key: settingsKey.selectedLanguageKey)
            }
        }
        get {
            if let selLanguage  = getValueFromUserDefault(key: settingsKey.selectedLanguageKey) as? String {
                return selLanguage
            }
            return nil
        }
    }
    
    /// Selected theme
    static public var selectedTheme : BaseTheme {
        set {
            setValueInUserDefault(key: settingsKey.selectedThemeKey, value: newValue.rawValue)
            //Fire notification if theme is changed
            NotificationCenter.default.post(Notification(name: Notification.Name.themeAndAppearanceChange))
        }
        get {
            return BaseTheme(val: getValueFromUserDefault(key: settingsKey.selectedThemeKey) as? String)
        }
    }
    
    /// Selected theme appearance
    static public var selectedThemeAppearance : BaseThemeAppearance {
        set {
            setValueInUserDefault(key: settingsKey.selectedThemeAppearanceKey, value: newValue.rawValue)
            //Fire notification if theme appearance is changed
            NotificationCenter.default.post(Notification(name: Notification.Name.themeAndAppearanceChange))
        }
        get {
            return BaseThemeAppearance(val: getValueFromUserDefault(key: settingsKey.selectedThemeAppearanceKey) as? String)
        }
    }
    
    /// Set storage info
    ///
    /// - Parameters:
    ///   - key: Url type key for which storage  info need to be saved
    ///   - storageInfo: Storage info for the url type
    static public func setStorageInfo(key: String, storageInfo: BaseStorageInfo) {
        do {
            let archivedData = try NSKeyedArchiver.archivedData(withRootObject: storageInfo, requiringSecureCoding: true)
            if var existingStorageInfo = getValueFromUserDefault(key: settingsKey.storageInfoKey) as? [String: Data] {
                //Serialize the object to store in userdefault
                existingStorageInfo[key] = archivedData
                setValueInUserDefault(key: settingsKey.storageInfoKey, value: existingStorageInfo)
            } else {
                setValueInUserDefault(key: settingsKey.storageInfoKey, value: [key: archivedData])
            }
        } catch let error {
            BaseLogger.errorLog(message: "BaseSettings - Error archiving url storage info - \(error)")
        }
    }
    
    /// Get Storage info for key
    ///
    /// - Parameter key: Key of the storage - key should be the url type
    /// - Returns: Storage info of the url type
    static public func getStorageInfo(key: String) -> BaseStorageInfo? {
        //Deserialize the object to store in userdefault
        if let data = (getValueFromUserDefault(key: settingsKey.storageInfoKey) as? [String: Data])?[key] {
            do {
                let unarchivedObject = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? BaseStorageInfo
                return unarchivedObject
            } catch let error {
               BaseLogger.errorLog(message: "BaseSettings - Error unarchiving url storage info - \(error)")
            }
        }
        return nil
    }
    
    //MARK:- Helper
    
    //Clear BNSettings
    static public func clear() {
        let mirror = Mirror(reflecting: settingsKey)
        mirror.children.forEach { child in
            if let keyValue = child.value as? String {
                UserDefaults.standard.removeObject(forKey: keyValue)
            }
        }
    }
    
    /// Get value from Userdefaults
    ///
    /// - Parameter key: Key of the item
    /// - Returns: Value of the item for the key specified
    public static func getValueFromUserDefault(key: String) -> Any? {
        return UserDefaults.standard.object(forKey: key)
    }
    
    /// Set value for key in Userdefaults
    ///
    /// - Parameters:
    ///   - key: Key of the item
    ///   - value: Value of the item for the key specified
    public static func setValueInUserDefault(key: String, value: Any?) {
        UserDefaults.standard.set(value, forKey: key)
    }
    
    /// Remove from userdefaults
    ///
    /// - Parameter key: Key which needs to be removed
    public static func removeFromUserDefault(key: String) {
        return UserDefaults.standard.removeObject(forKey: key)
    }
}
