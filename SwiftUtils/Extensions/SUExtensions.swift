//
//  SUExtensions.swift
//  SwiftUtils
//
//  Created by alvaro.grimal.local on 14/09/2020.
//  Copyright © 2020 Babel. All rights reserved.
//

import UIKit

// MARK: - UIAlertController

extension UIAlertController {

    /// This function show settings alert action.
    public static func getSettingsAction() -> UIAlertAction {

        let settingsAction = UIAlertAction(title: "",
                                           style: .cancel) { (_) -> Void in

            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }

            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, options: [:], completionHandler: nil)
            }
        }

        return settingsAction
    }

    /// This function show camera alert action.
    /// - Parameters:
    ///     - title: The text to use for the button title. The value you specify should be localized for the user’s current language. This parameter must not be nil, except in a tvOS app where a nil title may be used with UIAlertAction.Style.cancel.
    ///     - style: Additional styling information to apply to the button. Use the style information to convey the type of action that is performed by the button. For a list of possible values, see the constants in UIAlertAction.Style.
    ///     - handler: A block to execute when the user selects the action. This block has no return value and takes the selected action object as its only parameter.
    public static func getCameraActionSheet(title: String,
                                            style: UIAlertAction.Style = .default,
                                            handler: ((UIAlertAction) -> Void)? = nil) -> UIAlertAction {

        let cameraAction = UIAlertAction(title: title, style: style, handler: handler)
        return cameraAction
    }

    public static func getGalleryActionSheet(title: String,
                                             style: UIAlertAction.Style = .default,
                                             handler: ((UIAlertAction) -> Void)? = nil) -> UIAlertAction {

        let galleryAction = UIAlertAction(title: title, style: style, handler: handler)
        return galleryAction
    }

    public static func getOkAction(title: String,
                                   handler: ((UIAlertAction) -> Void)? = nil) -> UIAlertAction {

        return UIAlertAction(title: title, style: .default, handler: handler)
    }

    public static func getCancelAction(title: String,
                                       handler: ((UIAlertAction) -> Void)? = nil) -> UIAlertAction {

        return UIAlertAction(title: title, style: .default, handler: handler)
    }

    public static func getCancelActionSheet(title: String,
                                            style: UIAlertAction.Style = .cancel,
                                            handler: ((UIAlertAction) -> Void)? = nil) -> UIAlertAction {

        return UIAlertAction(title: title, style: style, handler: handler)
    }

    public static func getYesAction(title: String,
                                    handler: ((UIAlertAction) -> Void)? = nil) -> UIAlertAction {

        return UIAlertAction(title: title, style: .default, handler: handler)
    }

    public static func getNoAction(title: String,
                                   handler: ((UIAlertAction) -> Void)? = nil) -> UIAlertAction {

        return UIAlertAction(title: title, style: .default, handler: handler)
    }
}

// MARK: - UIViewContoller

extension UIViewController {

    public static var getIdentifier: String {
        return String(describing: self)
    }
}

// MARK: - Window

extension UIWindow {}

// MARK: - UIApplication

extension UIApplication {
    class func getTopViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {

        if let nav = base as? UINavigationController {
            return getTopViewController(base: nav.visibleViewController)

        } else if let tab = base as? UITabBarController, let selected = tab.selectedViewController {
            return getTopViewController(base: selected)

        } else if let presented = base?.presentedViewController {
            return getTopViewController(base: presented)
        }
        return base
    }
}

// MARK: - UIButton

extension UIButton {

    public func centerImageInButton() {

        if let imageView = imageView {
            imageView.contentMode = .scaleAspectFit
        }

        let horizontal = frame.size.width / 2
        let vertical = frame.size.height / 2
        imageEdgeInsets = UIEdgeInsets(top: vertical,
                                       left: horizontal,
                                       bottom: vertical,
                                       right: horizontal)
    }
}

// MARK: - UIView

extension UIView {

    public static var getIdentifier: String {
        return String(describing: self)
    }

    public func fadeTransition(_ duration: CFTimeInterval) {
        let animation = CATransition()
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        animation.type = CATransitionType.fade
        animation.duration = duration
        layer.add(animation, forKey: CATransitionType.fade.rawValue)
    }

    /// This function adds a ripple effect to the view.
    /// - Parameters:
    ///     - color: It is the color for the effect.
    ///     - repeatCount: How many times do you want it to be repeated.
    ///     - Infinite: It is marked as true if it is to be repeated infinitely.
    ///     - viewHasMultipleSublayers: It is marked as true if the view layer is going to have multiple sublayers. For example, if the view layer has a shadow and you want to add this effect.
    public func rippleEffect(color: UIColor, repeatCount: Float = 2, infinite: Bool = false, viewHasMultipleSublayers: Bool = false) {
        if viewHasMultipleSublayers {
            if let animations = self.layer.animationKeys(), !animations.isEmpty {
                return
            }
        } else {
            self.layer.sublayers?.removeAll()
        }
        let path = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: bounds.size.width, height: bounds.size.height))
        let shapePosition = CGPoint(x: bounds.size.width / 2.0, y: bounds.size.height / 2.0)
        let rippleShape = CAShapeLayer()
        rippleShape.bounds = CGRect(x: 0, y: 0, width: bounds.size.width, height: bounds.size.height)
        rippleShape.path = path.cgPath
        rippleShape.fillColor = color.cgColor
        rippleShape.strokeColor = color.cgColor
        rippleShape.lineWidth = 4
        rippleShape.position = shapePosition
        rippleShape.opacity = 0

        layer.addSublayer(rippleShape)
        let scaleAnim = CABasicAnimation(keyPath: "transform.scale")
        scaleAnim.fromValue = NSValue(caTransform3D: CATransform3DIdentity)
        scaleAnim.toValue = NSValue(caTransform3D: CATransform3DMakeScale(2, 2, 1))
        let opacityAnim = CABasicAnimation(keyPath: "opacity")
        opacityAnim.fromValue = 1
        opacityAnim.toValue = nil
        let animation = CAAnimationGroup()
        animation.animations = [scaleAnim, opacityAnim]
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        animation.duration = CFTimeInterval(2.0)
        animation.repeatCount = infinite ? .infinity : repeatCount
        animation.isRemovedOnCompletion = true
        rippleShape.add(animation, forKey: "rippleEffect")
    }

    public func blink(active: Bool) {

        if active {
            let flash = CABasicAnimation(keyPath: "opacity")
            flash.fromValue = NSNumber(value: 0.01)
            flash.toValue = NSNumber(value: 1.0)
            flash.duration = 0.5
            flash.autoreverses = true
            flash.repeatCount = .infinity

            layer.add(flash, forKey: "flashAnimation")
        } else {
            layer.removeAnimation(forKey: "flashAnimation")
        }
    }

    public func shake() {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.07
        animation.repeatCount = 4
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: center.x - 10, y: center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: center.x + 10, y: center.y))

        layer.add(animation, forKey: "position")
    }

    public func rotate() {
        let rotation: CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotation.toValue = Double.pi * 2
        rotation.duration = 0.3
        rotation.isCumulative = true
        rotation.repeatCount = 1
        layer.add(rotation, forKey: "rotationAnimation")
    }

    public func baseContainer(radius: CGFloat) {
        clipsToBounds = true
        layer.cornerRadius = radius
    }

    public func circular() {
        clipsToBounds = true
        layer.cornerRadius = frame.size.height/2
    }

    public func roundedTopCorners(value: CGFloat? = nil) {
        clipsToBounds = true
        layer.cornerRadius = value ?? CGFloat(SUConstants.Corner.small)
        layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }

    public func roundedLeftCorners() {
        clipsToBounds = true
        layer.cornerRadius = CGFloat(SUConstants.Corner.small)
        layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
    }

    public func addTopBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: width)
        layer.addSublayer(border)
    }

    public func addRightBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: frame.size.width - width, y: 0, width: width, height: frame.size.height)
        layer.addSublayer(border)
    }

    public func addBottomBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0, y: frame.size.height - width, width: frame.size.width, height: width)
        layer.addSublayer(border)
    }

    public func addLeftBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0, y: 0, width: width, height: frame.size.height)
        layer.addSublayer(border)
    }

    public func setBackgroundWithShadow(shadowLayer: inout CAShapeLayer?,
                                        backgroundColor: UIColor,
                                        cornerRadius: CGFloat,
                                        backBounds: CGRect?,
                                        shadowSize: CGSize = CGSize(width: 0.0, height: 3.0),
                                        shadowColor: UIColor = .black,
                                        shadowOpacity: Float = 0.5,
                                        shadowRadius: CGFloat = 2) {
        shadowLayer != nil ? shadowLayer?.removeFromSuperlayer() : nil
        self.backgroundColor = .clear
        shadowLayer = CAShapeLayer()
        let rect = backBounds == nil ? bounds : backBounds ?? CGRect(x: 0, y: 0, width: 0, height: 0)
        shadowLayer?.path = UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius).cgPath
        shadowLayer?.fillColor = backgroundColor.cgColor

        shadowLayer?.shadowColor = shadowColor.cgColor
        shadowLayer?.shadowPath = shadowLayer?.path
        shadowLayer?.shadowOffset = shadowSize
        shadowLayer?.shadowOpacity = shadowOpacity
        shadowLayer?.shadowRadius = shadowRadius
        layer.insertSublayer(shadowLayer ?? CAShapeLayer(), at: 0)
    }

    public func setInnerShadow(color: UIColor) {
        let innerShadow = CALayer()
        innerShadow.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height)

        let spread: CGFloat = -5.0
        let radius = SUConstants.Corner.medium
        let path = UIBezierPath(roundedRect: innerShadow.bounds.insetBy(dx: spread, dy: spread), cornerRadius: radius)
        let cutout = UIBezierPath(roundedRect: innerShadow.bounds, cornerRadius: radius).reversing()

        path.append(cutout)
        innerShadow.shadowPath = path.cgPath
        innerShadow.masksToBounds = true

        innerShadow.shadowColor = color.cgColor
        innerShadow.shadowOffset = CGSize(width: 0, height: 0)
        innerShadow.shadowOpacity = 0.95
        innerShadow.shadowRadius = radius
        innerShadow.cornerRadius = radius
        layer.addSublayer(innerShadow)
    }

    public enum CDMUtilsDirectionViewType {
        case leftToRight, rightToLeft, topToBottom, bottomToTop
    }

    public func setGradients(direction: CDMUtilsDirectionViewType, firstColor: CGColor, secondColor: CGColor) {
        let gradient: CAGradientLayer = CAGradientLayer()

        gradient.colors = [firstColor, secondColor]
        gradient.locations = [0.0, 1.0]
        var axisXStart = 0.0
        var axisXEnd = 0.0
        var axisYStart = 0.0
        var axisYEnd = 0.0
        switch direction {
        case .rightToLeft:
            axisXStart = 1.0
            axisXEnd = 0.0
            axisYStart = 1.0
            axisYEnd = 1.0

        case .leftToRight:
            axisXStart = 0.0
            axisXEnd = 1.0
            axisYStart = 1.0
            axisYEnd = 1.0

        case .bottomToTop:
            axisXStart = 1.0
            axisXEnd = 1.0
            axisYStart = 1.0
            axisYEnd = 0.0

        case .topToBottom:
            axisXStart = 1.0
            axisXEnd = 1.0
            axisYStart = 0.0
            axisYEnd = 1.0
        }
        gradient.startPoint = CGPoint(x: axisXStart, y: axisYStart)
        gradient.endPoint = CGPoint(x: axisXEnd, y: axisYEnd)
        gradient.frame = CGRect(x: 0.0, y: 0.0, width: self.frame.size.width, height: self.frame.size.height)

        self.layer.insertSublayer(gradient, at: 0)
    }

    public func drawTriangle(direction: CDMUtilsDirectionViewType, fillColor: CGColor) {

        let path = UIBezierPath()
        var firstPoint = CGPoint(x: 0, y: 0)
        var secondPoint = CGPoint(x: 0, y: 0)
        var thirdPoint = CGPoint(x: 0, y: 0)

        switch direction {
        case .bottomToTop:
            firstPoint = CGPoint(x: 0, y: self.frame.height)
            secondPoint = CGPoint(x: self.frame.width/2, y: 0)
            thirdPoint = CGPoint(x: self.frame.width, y: self.frame.height)
        case .topToBottom:
            firstPoint = CGPoint(x: 0, y: 0)
            secondPoint = CGPoint(x: self.frame.width/2, y: self.frame.height)
            thirdPoint = CGPoint(x: self.frame.width, y: 0)
        case .leftToRight:
            firstPoint = CGPoint(x: 0, y: 0)
            secondPoint = CGPoint(x: self.frame.width, y: self.frame.height/2)
            thirdPoint = CGPoint(x: 0, y: self.frame.height)
        case .rightToLeft:
            firstPoint = CGPoint(x: self.frame.width, y: 0)
            secondPoint = CGPoint(x: 0, y: self.frame.height/2)
            thirdPoint = CGPoint(x: self.frame.width, y: self.frame.height)
        }

        path.move(to: firstPoint)
        path.addLine(to: secondPoint)
        path.addLine(to: thirdPoint)
        path.addLine(to: firstPoint)

        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.fillColor = fillColor

        self.layer.addSublayer(shapeLayer)
    }
}

extension UIScrollView {

    public func toTop(animated: Bool = false) {
        let offset = CGPoint(x: 0, y: -contentInset.top)
        setContentOffset(offset, animated: animated)
   }
}

// MARK: - String

extension String {

    public func color(bundle: String) -> UIColor {
        let bundle = Bundle(identifier: bundle)
        return UIColor(named: self, in: bundle, compatibleWith: nil) ?? UIColor()
    }

    public var length: Int {
        return count
    }

    public subscript (index: Int) -> String {
        return self[index ..< index + 1]
    }

    public func substring(fromIndex: Int) -> String {
        return self[min(fromIndex, length) ..< length]
    }

    public func substring(toIndex: Int) -> String {
        return self[0 ..< max(0, toIndex)]
    }

    public subscript (aRange: Range<Int>) -> String {
        let range = Range(uncheckedBounds: (lower: max(0, min(length, aRange.lowerBound)),
                                            upper: min(length, max(0, aRange.upperBound))))
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = index(start, offsetBy: range.upperBound - range.lowerBound)
        return String(self[start ..< end])
    }

    public func fromBase64() -> Data? {
        return Data(base64Encoded: self, options: .ignoreUnknownCharacters)
    }

    public func toDate(format: DateFormatter = Date.Formatter.serviceISOTime.dateFormatter) -> Date {
        return format.date(from: self) ?? Date()
    }

    public var dateFormatter: DateFormatter {
        return DateFormatter(dateFormat: self)
    }

    public func fileExtension() -> String {
        return URL(fileURLWithPath: self).pathExtension
    }

    public func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }

    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }

}

// MARK: - UIImage

extension UIImage {

    public func compressTo(_ expectedSizeInMb: Int) -> Data? {
        let sizeInBytes = expectedSizeInMb * 1024 * 1024
        var needCompress: Bool = true
        var imgData: Data?
        var compressingValue: CGFloat = 1.0
        while needCompress && compressingValue > 0.0 {
            if let data: Data = self.jpegData(compressionQuality: compressingValue) {
                if data.count < sizeInBytes {
                    needCompress = false
                    imgData = data
                } else {
                    compressingValue -= 0.1
                }
            }
        }

        return imgData
    }

    public func toBase64() -> String {
        guard let imageData = self.pngData() else { return "" }
        return imageData.base64EncodedString(options: Data.Base64EncodingOptions.lineLength64Characters)
    }

    public func imageWith(color otherColor: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        let context = UIGraphicsGetCurrentContext()! as CGContext
        context.translateBy(x: 0, y: self.size.height)
        context.scaleBy(x: 1.0, y: -1.0)
        context.setBlendMode(.normal)
        let rect = CGRect(x: 0, y: 0,
                          width: self.size.width, height: self.size.height) as CGRect
        context.clip(to: rect, mask: self.cgImage!)
        otherColor.setFill()
        context.fill(rect)
        let imageColor = UIGraphicsGetImageFromCurrentImageContext()! as UIImage
        UIGraphicsEndImageContext()
        return imageColor
    }

}

// MARK: - UIFont

extension UIFont {

    private static func registerFont(withName name: String, fileExtension: String, bundleIdenfier: String = SUConstants.Framework.name) {

        guard let frameworkBundle = Bundle(identifier: bundleIdenfier) else {
            return
        }

        if let pathForResourceString = frameworkBundle.path(forResource: name,
                                                            ofType: fileExtension),
            let fontData = NSData(contentsOfFile: pathForResourceString),
            let dataProvider = CGDataProvider(data: fontData),
            let fontRef = CGFont(dataProvider) {

            var errorRef: Unmanaged<CFError>?

            if CTFontManagerRegisterGraphicsFont(fontRef, &errorRef) == false {
                SUFunctions.print("❌ Error registering font: \(name).\(fileExtension) with error: \(String(describing: errorRef))")
            } else {
                SUFunctions.print("✅ Font registered successfully: \(name).\(fileExtension)")
            }
        } else {
            SUFunctions.print("❌ Error registering font: \(name).\(fileExtension)")
        }
    }
}

// MARK: - TimeInterval

extension TimeInterval {

    var time: String {
        return String(format: "%02d", Int(ceil(truncatingRemainder(dividingBy: 60))))
    }
}

// MARK: - Int

extension Int {

    var degreesToRadians: CGFloat {
        return CGFloat(self) * .pi / 180
    }
}

// MARK: - Numeric

extension Numeric {

    public var formattedWithSeparator: String { Formatter.withSeparator.string(for: self) ?? "" }
}

// MARK: - Formatter

extension Formatter {

    static let withSeparator: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = "."
        return formatter
    }()
}
