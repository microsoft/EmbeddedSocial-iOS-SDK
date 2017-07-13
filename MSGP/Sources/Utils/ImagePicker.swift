//
//  ImagePicker.swift
//  MSGP
//
//  Created by Mac User on 12.07.17.
//  Copyright © 2017 Igor Popov. All rights reserved.
//

import Foundation

protocol ImagePickerDelegate: class {
    func selected(image: UIImage)
}

class ImagePicker: NSObject {
    
    weak var delegate: ImagePickerDelegate?
    
    fileprivate weak var presentingView: UIViewController?
    fileprivate let imagePicker = UIImagePickerController()
    
    func show<T: UIViewController>(from view: T) where T: ImagePickerDelegate {
        presentingView = view
        
        let actionSheet = UIAlertController(title: Alerts.Titles.choose,
                                            message: Alerts.Messages.leaveNewPost, preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: Button.Title.cancel, style: .cancel) { (_) in
            
        }
        actionSheet.addAction(cancelAction)
        
        let takeNewPhotoAction = UIAlertAction(title: Button.Title.takePhoto, style: .default) { (_) in
            self.showImagePicker(sourceType: .camera)
        }
        actionSheet.addAction(takeNewPhotoAction)
        
        let chooseExistingPhotoAction = UIAlertAction(title: Button.Title.chooseExisting, style: .default) { (_) in
            self.showImagePicker(sourceType: .photoLibrary)
        }
        actionSheet.addAction(chooseExistingPhotoAction)
        
        view.present(actionSheet, animated: true, completion: nil)
    }
    
    private func showImagePicker(sourceType: UIImagePickerControllerSourceType) {
        imagePicker.delegate = self
        imagePicker.sourceType = sourceType
        presentingView?.present(imagePicker, animated: true, completion: nil)
    }
    
    public func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage {
        let scale = newWidth / image.size.width
        let newHeight = image.size.height * scale
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
}

// MARK: UIImagePickerControllerDelegate
extension ImagePicker: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    internal func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        presentingView?.dismiss(animated: true, completion: nil)
    }
    
    internal func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            delegate?.selected(image: pickedImage)
        }
        
        presentingView?.dismiss(animated: true, completion: nil)
    }
}
