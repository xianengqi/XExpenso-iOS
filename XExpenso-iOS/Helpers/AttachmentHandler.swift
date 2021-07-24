//
//  AttachmentHandler.swift
//  XExpenso-iOS
//
//  Created by 夏能啟 on 7/23/21.
//

import Foundation
import UIKit
import MobileCoreServices
import AVFoundation
import Photos

class AttachmentHandler: NSObject {
    
    static let shared = AttachmentHandler()
    fileprivate var currentVC: UIViewController!
    
    private override init() {
        currentVC = UIApplication.shared.windows.first!.rootViewController
    }


    // MARK: - Internal Properties
    var imagePickedBlock: ((UIImage) -> Void)?

    enum AttachmentType: String {
        case camera, photoLibrary
    }

    // MARK: - Constants
    struct Constants {
        static let camera = "相机"
        static let phoneLibrary = "相册"
        static let alertForPhotoLibraryMessage = "应用程序无权访问您的照片。 要启用访问，请点击设置并打开照片库访问。"
        static let alertForCameraAccessMessage = "应用程序无权访问您的相机。 要启用访问，请点按设置并打开相机。"
        static let settingsBtnTitle = "设置"
        static let cancelBtnTitle = "取消"
    }

    // MARK: - showAttachmentActionSheet
    // This function is used to show the attachment sheet for camera, photo.
    func showAttachmentActionSheet() {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: Constants.camera, style: .default, handler: { (action) -> Void in
            self.authorisationStatus(attachmentTypeEnum: .camera, vc: self.currentVC!)
        }))
        actionSheet.addAction(UIAlertAction(title: Constants.phoneLibrary, style: .default, handler: { (action) -> Void in
            self.authorisationStatus(attachmentTypeEnum: .photoLibrary, vc: self.currentVC!)
        }))
        actionSheet.addAction(UIAlertAction(title: Constants.cancelBtnTitle, style: .cancel, handler: nil))
        // if iPhone
        if UIDevice.current.userInterfaceIdiom == .phone { currentVC.present(actionSheet, animated: true, completion: nil) }
        else {
            // change Rect to position Popover
            actionSheet.modalPresentationStyle = UIModalPresentationStyle.popover
            actionSheet.popoverPresentationController?.sourceRect = CGRect(x: currentVC.view.frame.size.width / 2, y: currentVC.view.frame.size.height / 4, width: 0, height: 0)
            actionSheet.popoverPresentationController?.sourceView = currentVC.view
            actionSheet.popoverPresentationController?.permittedArrowDirections = .any
            currentVC.present(actionSheet, animated: true, completion: nil)
        }
    }

    // MARK: - Authorisation Status
    // This is used to check the authorisation status whether user gives access to import the image, photo library.
    // if the user gives access, then we can import the data safely
    // if not show them alert to access from settings.
    func authorisationStatus(attachmentTypeEnum: AttachmentType, vc: UIViewController) {
        currentVC = vc
        
        let cameraStatus = AVCaptureDevice.authorizationStatus(for: .video)
        let photoStatus = PHPhotoLibrary.authorizationStatus()
        
        if attachmentTypeEnum == AttachmentType.camera {
            switch cameraStatus {
            case .authorized:
                openCamera()
            case .denied:
                print("没有权限")
                self.addAlertForSettings(attachmentTypeEnum)
            case .notDetermined:
              print("权限未确认")
                AVCaptureDevice.requestAccess(for: .video) { success in
                    if success { self.openCamera() }
                    else {
                        print("受限制")
                        self.addAlertForSettings(attachmentTypeEnum)
                    }
                }
            case .restricted:
                print("权限受限")
                self.addAlertForSettings(attachmentTypeEnum)
            default: break
            }
        } else {
            switch photoStatus {
            case .authorized:
                if attachmentTypeEnum == AttachmentType.photoLibrary { openLibray() }
            case .denied:
                print("没有权限")
                self.addAlertForSettings(attachmentTypeEnum)
            case .notDetermined:
                print("权限未确定")
                PHPhotoLibrary.requestAuthorization({ (status) in
                    if status == PHAuthorizationStatus.authorized {
                        // 允许访问照片库
                        print("访问权限")
                        if attachmentTypeEnum == AttachmentType.photoLibrary { self.openLibray() }
                    } else {
                        print("restriced manually")
                        self.addAlertForSettings(attachmentTypeEnum)
                    }
                })
            case .restricted:
                print("权限受限")
                self.addAlertForSettings(attachmentTypeEnum)
            default:
                break
            }
        }
    }

    // MARK: - SETTINGS ALERT
    func addAlertForSettings(_ attachmentTypeEnum: AttachmentType) {
        DispatchQueue.global(qos: .background).async {
            DispatchQueue.main.async {
                var alertTitle: String = ""
                if attachmentTypeEnum == AttachmentType.camera {
                    alertTitle = Constants.alertForCameraAccessMessage
                }
                if attachmentTypeEnum == AttachmentType.photoLibrary {
                    alertTitle = Constants.alertForPhotoLibraryMessage
                }
                let cameraUnavailableAlertController = UIAlertController (title: alertTitle, message: nil, preferredStyle: .alert)
                let settingsAction = UIAlertAction(title: Constants.settingsBtnTitle, style: .destructive) { (_) -> Void in
                    let settingsUrl = NSURL(string: UIApplication.openSettingsURLString)
                    if let url = settingsUrl {
                        UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
                    }
                }
                let cancelAction = UIAlertAction(title: Constants.cancelBtnTitle, style: .default, handler: nil)
                cameraUnavailableAlertController .addAction(cancelAction)
                cameraUnavailableAlertController .addAction(settingsAction)
                self.currentVC?.present(cameraUnavailableAlertController, animated: true, completion: nil)
            }
        }
    }

    // MARK: - CAMERA PICKER
    // This function is used to open camera from the iphone and
    @objc func openCamera() {
        DispatchQueue.global(qos: .background).async {
            DispatchQueue.main.async {
                if UIImagePickerController.isSourceTypeAvailable(.camera) {
                    let myPickerController = UIImagePickerController()
                    myPickerController.delegate = self
                    myPickerController.sourceType = .camera
                    self.currentVC?.present(myPickerController, animated: true, completion: nil)
                }
            }
        }
    }
    
// MARK: -PHOTO LIBRARY
    @objc func openLibray() {
        DispatchQueue.global(qos: .background).async {
            DispatchQueue.main.async {
                if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                    let myPickerController = UIImagePickerController()
                    myPickerController.delegate = self
                    myPickerController.sourceType = .photoLibrary
                    myPickerController.mediaTypes = ["public.image"]
                    self.currentVC?.present(myPickerController, animated: true, completion: nil)
                }
            }
        }
    }
    
}
// MARK: - IMAGE PICKER DELEGATE
// This is responsible for image picker interface to access image and then responsible for canceling the picker
extension AttachmentHandler: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        currentVC?.dismiss(animated: true, completion: nil)
    }
    
    @objc internal func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.imagePickedBlock?(image)
        }
        currentVC?.dismiss(animated: true, completion: nil)
    }
}
