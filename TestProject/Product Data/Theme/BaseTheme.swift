//
//  BaseTheme.swift
//  BaseFoundation
//
//  Created by VJ on 11/09/19.
//  Copyright © 2020 VJ. All rights reserved.
//

import Foundation

public enum BaseTheme : String {
    case dark = "dark"
    case light = "light"
    
    public typealias RawValue = String
    init(val: String?) {
        guard let val = val else {
            self = .light
            return
        }
        switch val {
        case "dark":
            self = .dark
        case "light":
            self = .light
        default:
            self = .light
        }
    }
}

/// Theme appearance in the app
public enum BaseThemeAppearance : String {
    case dark = "dark"
    case light = "light"
    
    public typealias RawValue = String
    init(val: String?) {
        guard let val = val else {
            self = .light
            return
        }
        switch val {
        case "light":
            self = .light
        case "dark":
            self = .dark
        default:
            self = .light
        }
    }
}
