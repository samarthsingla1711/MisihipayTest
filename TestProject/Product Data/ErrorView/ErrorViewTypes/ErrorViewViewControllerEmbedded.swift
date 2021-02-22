//
//  ErrorViewViewControllerEmbedded.swift
// BaseFoundation
//
//  Created by VJ on 10/09/19.
//  Copyright © 2020 VJ. All rights reserved.
//

import Foundation
import UIKit

class ErrorViewViewControllerEmbedded : UIView {
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var retryButton: UIButton!
    var retryHandler: (() -> ())?
    
    func updateUI() {
        retryButton.isHidden = retryHandler != nil ? false : true
    }
    
    @IBAction func retryClicked() {
        retryHandler?()
    }
}
