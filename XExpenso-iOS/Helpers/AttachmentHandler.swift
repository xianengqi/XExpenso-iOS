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
        
    }))
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
            
        case .restricted:
            <#code#>
        
        
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
