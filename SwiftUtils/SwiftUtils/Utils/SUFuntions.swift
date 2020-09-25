//
//  SUFunctions.swift
//  SWiftUtils
//
//  Created by alvaro.grimal.local on 14/09/2020.
//  Copyright © 2020 Babel. All rights reserved.
//

import UIKit
import Foundation
import MapKit

public class SUFunctions {

    /*
     * Utils class.
     * Methods are grouped by type.
     * Types are sorted alphabetically.
     */

    // MARK: - Animations

    public static func playNotificationFeedback(_ type: UINotificationFeedbackGenerator.FeedbackType) {
        let nfg = UINotificationFeedbackGenerator()
        nfg.notificationOccurred(type)
    }

    public static func playImpactFeedback(_ style: UIImpactFeedbackGenerator.FeedbackStyle) {
        let nfg = UIImpactFeedbackGenerator(style: style)
        nfg.impactOccurred()
    }

    // MARK: - Array

    public static func sortArrayAlphabetically(_ array: [String]) -> [String] {
        return array.sorted(by: <)
    }

    // MARK: - CAShapeLayer

    public static func createCircleBezier(radius: CGFloat, overView: UIView, color: UIColor, width: CGFloat? = nil) -> CAShapeLayer {
        let shape = CAShapeLayer()
        shape.path = UIBezierPath(arcCenter: CGPoint(x: overView.frame.midX, y: overView.frame.midY),
                                  radius: radius, startAngle: -90.degreesToRadians,
                                  endAngle: 270.degreesToRadians, clockwise: true).cgPath
        shape.strokeColor = color.cgColor
        shape.fillColor = UIColor.clear.cgColor
        shape.lineWidth = width ?? 1
        return shape
    }

    // MARK: - Color

    public static func giveMeWhiteOrBlackDepending(onTextColor foregroundColor: UIColor?) -> UIColor? {
        let count = foregroundColor?.cgColor.numberOfComponents
        let componentColors = foregroundColor?.cgColor.components

        var darknessScore: CGFloat = 0
        if count == 2 {
            let aComp = ((CGFloat(componentColors?[0] ?? 0) * 255) * 299)
            let bComp = ((CGFloat(componentColors?[0] ?? 0) * 255) * 587)
            let cComp = ((CGFloat(componentColors?[0] ?? 0) * 255) * 114)
            darknessScore = (aComp + bComp + cComp) / 1000
        } else if count == 4 {
            let aComp = ((CGFloat(componentColors?[0] ?? 0) * 255) * 299)
            let bComp = ((CGFloat(componentColors?[1] ?? 0) * 255) * 587)
            let cComp = ((CGFloat(componentColors?[2] ?? 0) * 255) * 114)
            darknessScore = (aComp + bComp + cComp) / 1000
        }

        if darknessScore >= 125 {
            return UIColor.white
        }

        return UIColor.black
    }

    // MARK: - DarkMode

    public static func isDarkMode() -> Bool {
        if #available(iOS 13.0, *) {
            return UITraitCollection.current.userInterfaceStyle == .dark
        } else {
            return false
        }
    }

    // MARK: - Date

    public static func convertDateFormater(date: String, originFormat: String, finalFormat: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = originFormat
        let realDate = dateFormatter.date(from: date)
        dateFormatter.dateFormat = finalFormat
        if let realDate = realDate {
            return dateFormatter.string(from: realDate)
        } else {
            return ""
        }
    }

    // MARK: - Device

    public static func isIpad() -> Bool {
        return UIDevice.current.userInterfaceIdiom == .pad
    }

    public static func getFreeSpaceInfo() -> (String, Int64) {
        var remainingSpaceString = NSLocalizedString("Unknown", comment: "The remaining free disk space on this device is unknown.")
        var remainingSpaceInt: Int64 = 0
        if let attributes = try? FileManager.default.attributesOfFileSystem(forPath: NSHomeDirectory()),
            let freeSpaceSize = attributes[FileAttributeKey.systemFreeSize] as? Int64 {
            remainingSpaceString = ByteCountFormatter.string(fromByteCount: freeSpaceSize, countStyle: .file)
            remainingSpaceInt = freeSpaceSize
        }
        return (remainingSpaceString, remainingSpaceInt)
    }

    // MARK: - Image

    public static func resizeImage(with image: UIImage?, scaledToFill size: CGSize) -> UIImage? {
        let scale: CGFloat = max(size.width / (image?.size.width ?? 0.0), size.height / (image?.size.height ?? 0.0))
        let width: CGFloat = (image?.size.width ?? 0.0) * scale
        let height: CGFloat = (image?.size.height ?? 0.0) * scale
        let imageRect = CGRect(x: (size.width - width) / 2.0, y: (size.height - height) / 2.0, width: width, height: height)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        image?.draw(in: imageRect)
        let newImage: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }

    // MARK: - Orientation

    public static func statusBarOrientation() -> UIInterfaceOrientation {
        return UIApplication.shared.statusBarOrientation
    }

    public static func isLandscapeStatusBarOrientation() -> Bool {
        return UIApplication.shared.statusBarOrientation == .landscapeLeft || UIApplication.shared.statusBarOrientation == .landscapeRight
    }

    // MARK: - Print

    public enum PrintMode: String {
        case basic
        case full
    }

    public static func print(_ items: Any..., separator: String = " ", terminator: String = "\n", mode: PrintMode = .basic) {
        #if DEBUG
        if mode == .basic {
            Swift.print(items.first ?? "")
        } else {
            Swift.print(items, separator: separator, terminator: terminator)
        }
        #endif
    }

    // MARK: - NavigationBar

    public static func setupNavigationBar(navigationController: UINavigationController,
                                          isTransparent: Bool = false,
                                          backgroundColor: UIColor = .white,
                                          foregroundColor: UIColor = .black) {
        navigationController.navigationBar.barTintColor = isTransparent ? .clear : backgroundColor
        navigationController.navigationBar.tintColor = foregroundColor
        navigationController.navigationBar.isTranslucent = false
        navigationController.navigationBar.topItem?.title = ""
        navigationController.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController.navigationBar.shadowImage = UIImage()
        if isTransparent {
            navigationController.navigationBar.isTranslucent = true
        }
        navigationController.interactivePopGestureRecognizer?.isEnabled = false

    }

    // MARK: - SafeArea

    @available(iOS, deprecated: 13.0)
    public static func getSafeArea() -> UIEdgeInsets {
        let window = UIApplication.shared.keyWindow
        return window?.safeAreaInsets ?? UIEdgeInsets()
    }

    // MARK: - String

    public static func applyAttributes(text: String, fontName: String, fontSize: CGFloat, backgroundColor: UIColor) -> NSMutableAttributedString {

        let attributedString = NSMutableAttributedString(string: text)

        text.enumerateSubstrings(in: text.startIndex..<text.endIndex, options: .byComposedCharacterSequences) { ( _, substringRange, _, _) in
            attributedString.addAttribute(.font, value: UIFont(name: fontName, size: fontSize)!, range: NSRange(substringRange, in: text))
            var color = UIColor.white
            if backgroundColor == UIColor.white {
                color = UIColor.black
            }
            attributedString.addAttribute(.foregroundColor, value: color, range: NSRange(substringRange, in: text))
        }

        return attributedString
    }

    public static func countWords(in string: String) -> Int {
        let components = string.components(separatedBy: .whitespacesAndNewlines)
        let words = components.filter { !$0.isEmpty }
        return words.count
    }

    // MARK: - Window

    @available(iOS, deprecated: 13.0)
    public static func backgroundWindow<T>(type: T.Type) -> UIWindow? {
        return UIApplication.shared.keyWindow
    }

    // MARK: - Location

    public static func getAddressFromCoordinates(lat: Double, withLongitude lon: Double,
                                                 completion: @escaping (String?, Error?) -> Void) {

        var center: CLLocationCoordinate2D = CLLocationCoordinate2D()
        let geocoder: CLGeocoder = CLGeocoder()
        center.latitude = lat
        center.longitude = lon

        let loc: CLLocation = CLLocation(latitude: center.latitude, longitude: center.longitude)

        geocoder.reverseGeocodeLocation(loc, completionHandler: { (placemarks, error) in

            if let error = error {
                completion(nil, error)
                return
            }

            let addressSeparator = ", "

            if let placemarks = placemarks, let placemark = placemarks.first {
                var addressString: String = ""
                if let thoroughfare = placemark.thoroughfare { addressString += thoroughfare + addressSeparator }
                if let sublocality = placemark.subLocality { addressString += sublocality + addressSeparator }
                if let subThoroughfare = placemark.subThoroughfare { addressString += subThoroughfare + addressSeparator }
                if let locality = placemark.locality { addressString += locality + addressSeparator }
                if let postalCode = placemark.postalCode { addressString += postalCode + addressSeparator }
                if let country = placemark.country { addressString += country }
                completion(addressString, nil)
            }
        })
    }

    public static func getCoordinatesFromAddress(address: String, completion: @escaping (Double, Double) -> Void) {

        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(address) { (placemarks, _) in
            guard let placemarks = placemarks, let location = placemarks.first?.location else {
                completion(0.0, 0.0)
                return
            }
            completion(location.coordinate.latitude, location.coordinate.longitude)
        }
    }
}
