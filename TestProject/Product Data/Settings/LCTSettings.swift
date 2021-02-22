//
// BaseMSettings.swift
//  Locate
//
//  Created by VJ on 26/08/19.
//  Copyright © 2020 VJ. All rights reserved.
//

import Foundation

struct LCTSettingsKey {
    let isEUUserKey = "IsEUUserKey"
}

/// Settings will store all app related information in the persistent Userdefaults
class LCTSettings: BaseSettings {
    
    static private let settingsKey = LCTSettingsKey()
    
    /// Is EU user
    static var isEUUser : Bool {
        set {
            setValueInUserDefault(key: settingsKey.isEUUserKey, value: newValue)
        }
        get {
            return getValueFromUserDefault(key: settingsKey.isEUUserKey) as? Bool ?? true
        }
    }

}
