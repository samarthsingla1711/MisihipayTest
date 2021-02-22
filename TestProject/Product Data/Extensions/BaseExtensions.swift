//
// BaseExtensions.swift
// BaseFoundation
//
//  Created by VJ on 26/08/19.
//  Copyright © 2020 VJ. All rights reserved.
//

import Foundation
import UIKit
import SDWebImage

//MARK: - UIView
public extension UIView {
    
    /// This will add same size constraint on the view
    ///
    /// - Parameter view: view which has to be of same size
    func addSameSizeConstraint(with view: UIView) {
        // Adding constraints to the background image view
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: view, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: view, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
        
        NSLayoutConstraint(item: view, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: view, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1, constant: 0).isActive = true
        
        
        NSLayoutConstraint(item: view, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: view, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
    }
    
    /// Provides rounder corner to the view with mask layer
    ///
    /// - Parameters:
    ///   - corners: Corners for which rounded is needed
    ///   - cornerRadius: Corner radius
    func roundedCorners(corners: UIRectCorner, cornerRadius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
    
    /// Add Linear gradient to the view
    ///
    /// - Parameter colors: Colors of gradient in bottom to top manner
    func addLinearGradient(colors: [CGColor]) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = colors
        layer.addSublayer(gradientLayer)
    }
    
    /// Add blur effect on the view
    ///
    /// - Parameter style: Style of the blur
    @discardableResult func addBlurEffect(style: UIBlurEffect.Style? = .dark) -> UIVisualEffectView? {
        let blurEffect = UIBlurEffect(style: style!)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        insertSubview(blurEffectView, at: 0)
        return blurEffectView
    }
    
    func dropShadow(scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.2
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowRadius = 5
//        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
      }
}

// MARK: - UITableView
public extension UITableView {
    
    /// Reload Data with completions
    ///
    /// - Parameter completion: Completion handler
    func reloadData(completion: @escaping () -> ()) {
        UIView.animate(withDuration: 0, animations: { self.reloadData() }) { _ in completion() }
    }
    
    func hideExtraLines() {
        let footerView = UIView(frame: CGRect.zero)
        self.tableFooterView = footerView
    }
}

// MARK: - UIStoryboard
extension UIStoryboard {
    
    static var errorViews : UIStoryboard {
        return UIStoryboard(name: "ErrorViews", bundle: Bundle(for: BaseErrorView.self))
    }
}

// MARK: - Error
public extension Error {
    var code: Int { return (self as NSError).code }
    var domain: String { return (self as NSError).domain }
}

// MARK: - UIButton
public extension UIButton {
    
    /// Set text for normal state
    var text : String? {
        set {
            setTitle(newValue, for: .normal)
        }
        get {
            return title(for: .normal)
        }
    }
}

// MARK: - UICollectionView
public extension UICollectionView {
    
    /// Reload Data with completions
    ///
    /// - Parameter completion: Completion handler
    func reloadData(completion: @escaping () -> ()) {
        UIView.animate(withDuration: 0, animations: { self.reloadData() }) { _ in completion() }
    }
}

// MARK: - Notification Name
public extension Notification.Name {
    static let networkChange = Notification.Name("NetworkChangeNotification")
    static let themeAndAppearanceChange = Notification.Name("ThemeAndAppearanceChangeNotification")
}

//MARK:- Int
public extension Int {
    var boolValue: Bool { return self != 0 }
}

//MARK:- Bool
public extension Bool {
    var intValue: Int {
        return self ? 1 : 0
    }
    
    var stringValue: String {
        return self ? "1" : "0"
    }
}

//MARK:- String
public extension String {
    var boolValue: Bool { return self == "1" }
}

public extension UIFont {
    
    @objc class func mediumFont(withSize fontSize: CGFloat) -> UIFont {
        return UIFont(name : "Roboto-Medium", size: fontSize)!
    }
    
    @objc class func lightFont(withSize fontSize: CGFloat) -> UIFont {
        return UIFont(name : "Roboto-Light", size: fontSize)!
    }
    
    @objc class func regularFont(withSize fontSize: CGFloat) -> UIFont {
        return UIFont(name : "Roboto-Regular", size: fontSize)!
    }
    
    @objc class func mediumItalicFont(withSize fontSize: CGFloat) -> UIFont {
        return UIFont(name : "Roboto-MediumItalic", size: fontSize)!
    }
    
    @objc class func thinItalicFont(withSize fontSize: CGFloat) -> UIFont {
        return UIFont(name : "Roboto-ThinItalic", size: fontSize)!
    }
    
    @objc class func boldItalicFont(withSize fontSize: CGFloat) -> UIFont {
        return UIFont(name : "Roboto-BoldItalic", size: fontSize)!
    }
    
    @objc class func lightItalicFont(withSize fontSize: CGFloat) -> UIFont {
        return UIFont(name : "Roboto-LightItalic", size: fontSize)!
    }
    
    @objc class func italicFont(withSize fontSize: CGFloat) -> UIFont {
        return UIFont(name : "Roboto-Italic", size: fontSize)!
    }
        
    @objc class func boldFont(withSize fontSize: CGFloat) -> UIFont {
        return UIFont(name : "Roboto-Bold", size: fontSize)!
    }
    
    @objc class func thinFont(withSize fontSize: CGFloat) -> UIFont {
        return UIFont(name : "Roboto-Thin", size: fontSize)!
    }
    
    @objc class func blackFont(withSize fontSize: CGFloat) -> UIFont {
        return UIFont(name : "Roboto-Black", size: fontSize)!
    }
}

public extension UIImage {
    
    @objc static func from(color: UIColor) -> UIImage {
        let path : UIBezierPath = UIBezierPath(rect: CGRect(x: 0, y: 0, width: Screensize.screenWidth, height: 44))
        let rect = CGRect(x: 0, y: 0, width: 0.5, height: 0.5)
        UIGraphicsBeginImageContextWithOptions(rect.size,false,0)
        color.setFill()
        path.fill()
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}

import SwiftMessages
public extension UIViewController {
        
    var hasSafeArea: Bool {
        guard
            #available(iOS 11.0, tvOS 11.0, *)
            else {
                return false
            }
        return UIApplication.shared.delegate?.window??.safeAreaInsets.top ?? 0 > 20
    }

    
    @objc func leftButtonClicked() {
        if let tempViewControllers = self.navigationController?.viewControllers, tempViewControllers.count > 1{
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func backNavigationButton(withTitle title: String) -> UIBarButtonItem {
        
        let barButton:UIButton = UIButton.init(type: .custom)
        barButton.addTarget(self, action:#selector(leftButtonClicked), for: .touchUpInside)
        barButton.frame = CGRect(x: 0, y: 0, width: 200, height: 40)
        barButton.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.left
        barButton.contentVerticalAlignment = .center
        barButton.titleLabel?.lineBreakMode = .byTruncatingTail;
        barButton.imageView?.contentMode = .scaleAspectFit
        barButton.accessibilityLabel = "Acc_menu"
        
        let iconAttributedString : NSMutableAttributedString = NSMutableAttributedString();
        
        if let tempViewControllers = self.navigationController?.viewControllers, tempViewControllers.count == 1 {
                barButton.setImage(UIImage(named:"ic_singular_menu_night"), for: .normal)
        } else {
                barButton.setImage(UIImage(named:"ic_singular_back_night"), for: .normal)
        }
        
        if(!title.isEmpty ){
            let titleAttributedString = NSMutableAttributedString(string: "  \(title)")
            titleAttributedString.addAttributes([NSAttributedString.Key.font: UIFont.boldFont(withSize: 16), NSAttributedString.Key.foregroundColor: UIColor.white], range: NSMakeRange(0,title.count+2))
            iconAttributedString.append(titleAttributedString)
        }
        //Calculate dynamic width of button according to title
        let rect = iconAttributedString.boundingRect(with: CGSize(width: 1000, height: 40), options: [.usesLineFragmentOrigin, .usesFontLeading], context: nil);
        barButton.frame = CGRect(x: 0, y: 0, width: rect.size.width + 30, height: 40)
        

        barButton.setTitleColor(UIColor.white, for:.normal)
        barButton.setAttributedTitle(iconAttributedString, for:.normal)
        let barButtonItem:UIBarButtonItem = UIBarButtonItem.init(customView: barButton)
        return barButtonItem
    }
    
    func backNavigationButton(withTitle title: String, withSubTitle subTitle: String? = nil) -> UIBarButtonItem {
        
        let barButton:UIButton = UIButton.init(type: .custom)
        barButton.addTarget(self, action:#selector(leftButtonClicked), for: .touchUpInside)
        barButton.frame = CGRect(x: 0, y: 0, width: 200, height: 40)
        barButton.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.left
        barButton.contentVerticalAlignment = .center
        barButton.titleLabel?.lineBreakMode = .byTruncatingTail;
        barButton.titleLabel?.numberOfLines = 0

        barButton.imageView?.contentMode = .scaleAspectFit
        barButton.accessibilityLabel = "Acc_menu"
        
        let iconAttributedString : NSMutableAttributedString = NSMutableAttributedString();
        
        if let tempViewControllers = self.navigationController?.viewControllers, tempViewControllers.count == 1 {
                barButton.setImage(UIImage(named:"ic_singular_menu_night"), for: .normal)
        } else {
                barButton.setImage(UIImage(named:"ic_singular_back_night"), for: .normal)
        }
        
        if(!title.isEmpty ){
            let titleAttributedString = NSMutableAttributedString(string: "    \(title)")
            titleAttributedString.addAttributes([NSAttributedString.Key.font: UIFont.boldFont(withSize: 16), NSAttributedString.Key.foregroundColor: UIColor.white], range: NSMakeRange(0,titleAttributedString.length))
            iconAttributedString.append(titleAttributedString)
            
            if let tempSubTitle = subTitle, tempSubTitle.count > 0 {
                let subTitleAttributedString = NSMutableAttributedString(string: "\n    \(tempSubTitle)")
                subTitleAttributedString.addAttributes([NSAttributedString.Key.font: UIFont.regularFont(withSize:14), NSAttributedString.Key.foregroundColor: UIColor.white], range: NSMakeRange(0,subTitleAttributedString.length))
                iconAttributedString.append(subTitleAttributedString)
            }            
        }
        //Calculate dynamic width of button according to title
        let rect = iconAttributedString.boundingRect(with: CGSize(width: 1000, height: 40), options: [.usesLineFragmentOrigin, .usesFontLeading], context: nil);
        barButton.frame = CGRect(x: 0, y: 0, width: rect.size.width + 30, height: 40)
        

        barButton.setTitleColor(UIColor.white, for:.normal)
        barButton.setAttributedTitle(iconAttributedString, for:.normal)
        let barButtonItem:UIBarButtonItem = UIBarButtonItem.init(customView: barButton)
        return barButtonItem
    }
    
    func backNavigationButtonWithImage(withTitle title: String, withSubTitle subTitle: String? = nil, withImageName imageName: String? = nil, withImageUrlString urlString:String? = nil) -> UIBarButtonItem {
        
        let barButton:UIButton = UIButton.init(type: .custom)
        barButton.addTarget(self, action:#selector(leftButtonClicked), for: .touchUpInside)
        barButton.frame = CGRect(x: 0, y: 0, width: 30, height: 40)
        barButton.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.left
        barButton.contentVerticalAlignment = .center
        barButton.titleLabel?.lineBreakMode = .byTruncatingTail;
        barButton.titleLabel?.numberOfLines = 0
        barButton.imageView?.contentMode = .scaleAspectFit
        barButton.accessibilityLabel = "Acc_menu"
        if let tempViewControllers = self.navigationController?.viewControllers, tempViewControllers.count == 1 {
           barButton.setImage(UIImage(named:"ic_singular_menu_night"), for: .normal)
        } else {
           barButton.setImage(UIImage(named:"ic_singular_back_night"), for: .normal)
        }


        let label = UILabel()
        let iconAttributedString : NSMutableAttributedString = NSMutableAttributedString();
        if(!title.isEmpty ){
            let titleAttributedString = NSMutableAttributedString(string: "  \(title)")
            titleAttributedString.addAttributes([NSAttributedString.Key.font: UIFont.boldFont(withSize: 14), NSAttributedString.Key.foregroundColor: UIColor.white], range: NSMakeRange(0,titleAttributedString.length))
            iconAttributedString.append(titleAttributedString)
            
            if let tempSubTitle = subTitle, tempSubTitle.count > 0 {
                let subTitleAttributedString = NSMutableAttributedString(string: "\n  \(tempSubTitle)")
                subTitleAttributedString.addAttributes([NSAttributedString.Key.font: UIFont.regularFont(withSize:12), NSAttributedString.Key.foregroundColor: UIColor.white], range: NSMakeRange(0,subTitleAttributedString.length))
                iconAttributedString.append(subTitleAttributedString)
            }
        }
        //Calculate dynamic width of button according to title
        let rect = iconAttributedString.boundingRect(with: CGSize(width: 1000, height: 40), options: [.usesLineFragmentOrigin, .usesFontLeading], context: nil);
        label.frame = CGRect(x: 60, y: 0, width: rect.size.width, height: 40)
        label.attributedText = iconAttributedString
        label.numberOfLines = 0
        
        let imageView = UIImageView(image:UIImage(named: "ic_navigation_drop"))
        imageView.contentMode = .scaleAspectFill
        imageView.frame = CGRect(x: 30, y: 5, width: 30, height: 30)
        imageView.layer.cornerRadius = 15.0
        imageView.clipsToBounds = true
        
        if let tempImageUrlString = urlString, tempImageUrlString.count > 0, let tempImageUrl = URL(string: tempImageUrlString){
            imageView.sd_setImage(with: tempImageUrl, placeholderImage: UIImage(named: imageName ?? ""), options: SDWebImageOptions.highPriority, context: nil)
        } else if let tempImagePlaceHolderName = imageName {
            imageView.image = UIImage(named: tempImagePlaceHolderName)
        }

        let view = UIView(frame: CGRect(x: 0, y:0 , width: label.frame.origin.y + label.frame.size.width, height: 40))
        view.backgroundColor = UIColor.clear
        view.addSubview(barButton)
        view.addSubview(imageView)
        view.addSubview(label)
        
        let barButtonItem:UIBarButtonItem = UIBarButtonItem.init(customView: view)
        return barButtonItem
    }
    
    
    
    func showErrorView(withTitle title: String? = "", withMessage message: String? = ""){
        let success = MessageView.viewFromNib(layout: .messageView)
        success.configureTheme(backgroundColor: UIColor(named: "themeColor")!, foregroundColor: UIColor.white, iconImage: nil, iconText: nil)
        success.configureDropShadow()
        success.configureContent(title: title ?? "", body: message ?? "")
        success.button?.isHidden = true
        var successConfig = SwiftMessages.defaultConfig
        successConfig.presentationStyle = .top
        successConfig.presentationContext = .window(windowLevel: UIWindow.Level.normal)
        
        SwiftMessages.show(config: successConfig, view: success)
    }
    
        
    @objc func moreNavigationButton() -> UIBarButtonItem {
        
        let barButton:UIButton = UIButton.init(type: .custom)
        barButton.addTarget(self, action:#selector(moreNavigationButtonClicked), for: .touchUpInside)
        barButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        barButton.setImage(UIImage(named: "ic_more"), for: .normal)
        barButton.imageView?.contentMode = .scaleAspectFit
        
        let barButtonItem:UIBarButtonItem = UIBarButtonItem.init(customView: barButton)
        barButtonItem.width = 30
        
        return barButtonItem
    }
    
    @objc func notificationNavigationButton() -> UIBarButtonItem {
        
        let barButton:UIButton = UIButton.init(type: .custom)
        barButton.addTarget(self, action:#selector(notificationButtonClicked), for: .touchUpInside)
        barButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        barButton.setImage(UIImage(named: "ic_bell"), for: .normal)
        barButton.imageView?.contentMode = .scaleAspectFit
        
        let barButtonItem:UIBarButtonItem = UIBarButtonItem.init(customView: barButton)
        barButtonItem.width = 30.0
        
        return barButtonItem
    }
    
    @objc func notificationButtonClicked(){ 
    }
    @objc func moreNavigationButtonClicked(){}
 
    
    @IBAction func backClicked(_ sender: Any){
        self.navigationController?.popViewController(animated: true)
    }
}

struct Screensize {
    static let screenWidth : CGFloat = UIScreen.main.bounds.width
    static let screenHeight : CGFloat = UIScreen.main.bounds.height
}

extension Bundle {
    var releaseVersionNumber: String? {
        return infoDictionary?["CFBundleShortVersionString"] as? String
    }
    var buildVersionNumber: String? {
        return infoDictionary?["CFBundleVersion"] as? String
    }
}

struct ImageHeaderData{
    static var PNG: [UInt8] = [0x89]
    static var JPEG: [UInt8] = [0xFF]
    static var GIF: [UInt8] = [0x47]
    static var TIFF_01: [UInt8] = [0x49]
    static var TIFF_02: [UInt8] = [0x4D]
}

enum ImageFormat{
    case Unknown, PNG, JPEG, GIF, TIFF
    
    func toString()-> String{
        switch self {
        case .JPEG:
            return "jpeg"
        case .PNG:
            return "png"
        case .GIF:
            return "gif"
        case .TIFF:
            return "tiff"
        default:
            return "unknow"
        }
    }
}

extension NSData{
    var imageFormat: ImageFormat{
        var buffer = [UInt8](repeating: 0, count: 1)
        self.getBytes(&buffer, range: NSRange(location: 0,length: 1))
        if buffer == ImageHeaderData.PNG
        {
            return .PNG
        } else if buffer == ImageHeaderData.JPEG
        {
            return .JPEG
        } else if buffer == ImageHeaderData.GIF
        {
            return .GIF
        } else if buffer == ImageHeaderData.TIFF_01 || buffer == ImageHeaderData.TIFF_02{
            return .TIFF
        } else{
            return .Unknown
        }
    }
}
//extension KeyedDecodingContainer{
//    
//    public func decode(_ type: Bool.Type, forKey key: KeyedDecodingContainer<K>.Key) throws -> Bool
//
//        
//    }
//}

extension Date {
    func dayNumberOfWeek() -> Int? {
        return Calendar.current.dateComponents([.weekday], from: self).weekday
    }
}

