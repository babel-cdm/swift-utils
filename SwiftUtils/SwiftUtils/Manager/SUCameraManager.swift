//
//  SUCameraManager.swift
//  SwiftUtils
//
//  Created by alvaro.grimal.local on 14/09/2020.
//  Copyright © 2020 Babel. All rights reserved.
//

import UIKit
import AVFoundation
import Photos

@objc public protocol SUCameraManagerDelegate: class {
    @objc func pictureTaken(_ imageData: Data, tag: Int)
    @objc optional func getNameCamaraPicture(_ name: String)
}

public class SUCameraManager: NSObject {

    public weak var delegate: SUCameraManagerDelegate?
    private weak var viewController: UIViewController?
    private var compressionValue: CGFloat!
    private var maxSize: Int?
    private var tag: Int!
    private let defaultName = "IMG_"
    private let defaultExtension = "JPG"

    public func openCamera(viewController: UIViewController,
                           withCompression compressionValue: CGFloat = 0.6,
                           tag: Int = 0,
                           maxSize: Int? = nil,
                           cancelTitle: String) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            self.viewController = viewController
            self.tag = tag
            self.compressionValue = compressionValue
            self.maxSize = maxSize

            switch AVCaptureDevice.authorizationStatus(for: .video) {
            case .notDetermined:
                requestCameraPermission()
            case .authorized:
                presentCamera()
            case .restricted, .denied:
                showAlertCameraPermission(cancelTitle: cancelTitle)
            default:
                break
            }
        }
    }

    private func requestCameraPermission() {
        AVCaptureDevice.requestAccess(for: .video, completionHandler: { accessGranted in
            guard accessGranted == true else { return }
            self.presentCamera()
        })
    }

    private func presentCamera() {
        DispatchQueue.main.async {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera

            self.viewController?.present(imagePicker, animated: true, completion: nil)
        }
    }

    private func showAlertCameraPermission(cancelTitle: String) {
        let actions = [UIAlertController.getCancelAction(title: cancelTitle),
                       UIAlertController.getSettingsAction()]

        let alertController = UIAlertController(title: "",
                                                message: "",
                                                preferredStyle: .alert)

        for action in actions {
            alertController.addAction(action)
        }

        viewController?.present(alertController, animated: true, completion: nil)
    }

}

extension SUCameraManager: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {

        let defaultPhotoUrl = "\(defaultName)\(Date()).\(defaultExtension)"

        if let imageUrl = info[.imageURL] as? URL {
            delegate?.getNameCamaraPicture?(imageUrl.lastPathComponent)
        } else {
            delegate?.getNameCamaraPicture?(defaultPhotoUrl)
        }

        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage,
            let delegate = delegate {
            var imgData: Data?
            if let size = self.maxSize {
                imgData = image.compressTo(size)
            }
            if let data = imgData {
                delegate.pictureTaken(data, tag: tag)
            } else {
                if let imageData = image.jpegData(compressionQuality: compressionValue) {
                    delegate.pictureTaken(imageData, tag: tag)
                }
            }
        }

        picker.dismiss(animated: true, completion: nil)
    }

}
