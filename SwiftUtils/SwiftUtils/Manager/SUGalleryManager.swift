//
//  SUGalleryManager.swift
//  SwiftUtils
//
//  Created by alvaro.grimal.local on 14/09/2020.
//  Copyright © 2020 Babel. All rights reserved.
//

import UIKit
import Photos

@objc public protocol SUGalleryManagerDelegate: class {
    @objc func pictureTaken(_ imageData: Data, tag: Int)
    @objc optional func getNameGalleryPicture(_ name: String)
}

public class SUGalleryManager: NSObject {

    public weak var delegate: SUGalleryManagerDelegate?
    private weak var viewController: UIViewController?
    private var compressionValue: CGFloat!
    private var maxSize: Int?
    private var tag: Int!
    let imagePicker = UIImagePickerController()

    public override init() {
        super.init()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
    }

    public func openGallery(viewController: UIViewController,
                            withCompression compressionValue: CGFloat = 0.6,
                            tag: Int = 0,
                            maxSize: Int? = 1,
                            cancelTitle: String) {
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) {
            self.viewController = viewController
            self.compressionValue = compressionValue
            self.maxSize = maxSize

            switch PHPhotoLibrary.authorizationStatus() {
            case .notDetermined:
                requestGalleryPermission()
            case .authorized:
                presentGallery()
            case .restricted, .denied:
                showAlertCameraPermission(cancelTitle: cancelTitle)
            default:
                break
            }
            self.tag = tag
        }
    }

    private func requestGalleryPermission() {
        PHPhotoLibrary.requestAuthorization { accessGranted in
            guard accessGranted == PHAuthorizationStatus.authorized else { return }
            self.presentGallery()
        }
    }

    private func presentGallery() {
        DispatchQueue.main.async {
            self.viewController?.present(self.imagePicker, animated: true, completion: nil)
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

extension SUGalleryManager: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {

        if let imageUrl = info[.imageURL] as? URL {
            delegate?.getNameGalleryPicture?(imageUrl.lastPathComponent)
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
