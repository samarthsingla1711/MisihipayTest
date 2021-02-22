//
//  ETLoadingAnimatedView.swift
//  ETFoundation
//
//  Created by VJ on 17/09/19.
//

import Foundation
import UIKit


var associateObjectValue: Int = 0
//
public extension UIView {
    
    fileprivate var isAnimate: Bool {
        get {
            return objc_getAssociatedObject(self, &associateObjectValue) as? Bool ?? false
        }
        set {
            return objc_setAssociatedObject(self, &associateObjectValue, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    @IBInspectable var shimmerAnimation: Bool {
        get {
            return isAnimate
        }
        set {
            self.isAnimate = newValue
        }
    }
    
    func subviewsRecursive() -> [UIView] {
        return subviews + subviews.flatMap { $0.subviewsRecursive() }
    }
    
    /// Start Loading Animation
    func startLoadingAnimation() {
        clipsToBounds = true
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.white.withAlphaComponent(0.4).cgColor, UIColor.clear.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradientLayer.frame = bounds
        gradientLayer.frame.size.width =  gradientLayer.frame.size.width * 2
        layer.addSublayer(gradientLayer)
        
        let animation = CABasicAnimation(keyPath: "transform.translation.x")
        animation.duration = 2.0
        animation.fromValue = -gradientLayer.frame.size.width
        animation.toValue = gradientLayer.frame.size.width
        animation.repeatCount = .infinity
        
        gradientLayer.add(animation, forKey: "ETLoadingAnimationKey")
        
    }
    
    /// Stop loading animation
    func stopLoadingAnimation() {
        layer.removeAnimation(forKey: "ETLoadingAnimationKey")
        layer.mask = nil
    }
}
