//
//  ViewController.swift
//  Locate
//
//  Created by samarth on 16/10/20.
//

import UIKit
import Validator

struct LocateValidationError: ValidationError {

    let message: String
    
    public init(_ message: String) {
        
        self.message = message
    }
}
