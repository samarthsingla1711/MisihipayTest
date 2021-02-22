//
// BaseErrorView.swift
// BaseFoundation
//
//  Created by VJ on 10/09/19.
//  Copyright © 2020 VJ. All rights reserved.
//

import Foundation
import UIKit

class BaseErrorView {
    
    /// Get Error view for the error view type
    /// - Parameter type: Type of error view
    static func getErrorView(type: ErrorViewType) -> UIView? {
        switch type {
        case .viewControllerEmbedded:
            let view = UIStoryboard.errorViews.instantiateViewController(withIdentifier: String(describing: ErrorViewViewControllerEmbedded.self)).view
            return view
        }
    }
}

/// Error View Types in the app
enum ErrorViewType {
    case viewControllerEmbedded
}
