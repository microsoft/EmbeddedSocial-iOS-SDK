//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

protocol ImagePickerDelegate: class {
    func selected(photo: Photo)
}

class ImagePicker: NSObject {
    
    weak var delegate: ImagePickerDelegate?
    
    fileprivate weak var presentingView: UIViewController?
    
    fileprivate let imagePicker = UIImagePickerController()
    
    fileprivate var onImageSelected: ((Result<UIImage>) -> Void)?
    
    func show(with options: Options) {
        presentingView = options.sourceViewController
        openSourceSelectionSheet(with: options)
    }
    
    func show(with options: Options, completion: @escaping (Result<UIImage>) -> Void) {
        presentingView = options.sourceViewController
        onImageSelected = completion
        openSourceSelectionSheet(with: options)
    }
    
    private func openSourceSelectionSheet(with options: Options) {
        let actionSheet = UIAlertController(title: options.title, message: options.message, preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: Button.Title.cancel, style: .cancel, handler: nil)
        actionSheet.addAction(cancelAction)
        
        let takeNewPhotoAction = UIAlertAction(title: Button.Title.takePhoto, style: .default) { (_) in
            self.showImagePicker(sourceType: .camera)
        }
        actionSheet.addAction(takeNewPhotoAction)
        
        let chooseExistingPhotoAction = UIAlertAction(title: Button.Title.chooseExisting, style: .default) { (_) in
            self.showImagePicker(sourceType: .photoLibrary)
        }
        actionSheet.addAction(chooseExistingPhotoAction)
        
        if let presenter = actionSheet.popoverPresentationController, let presentingView = presentingView {
            presenter.sourceView = presentingView.view
            presenter.sourceRect = CGRect(x: presentingView.view.bounds.midX,
                                          y: presentingView.view.bounds.midY,
                                          width: 0,
                                          height: 0)
        }
        
        options.sourceViewController.present(actionSheet, animated: true, completion: nil)
    }
    
    private func showImagePicker(sourceType: UIImagePickerControllerSourceType) {
        imagePicker.delegate = self
        imagePicker.sourceType = sourceType
        presentingView?.present(imagePicker, animated: true, completion: nil)
    }
}

extension ImagePicker {
    struct Options {
        let title: String?
        let message: String?
        let sourceViewController: UIViewController
        
        init(title: String? = nil, message: String? = nil, sourceViewController: UIViewController) {
            self.title = title
            self.message = message
            self.sourceViewController = sourceViewController
        }
    }
}

// MARK: UIImagePickerControllerDelegate
extension ImagePicker: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        onImageSelected?(.failure(Error.cancelled))
        presentingView?.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            let photo = Photo(uid: UUID().uuidString, url: info[UIImagePickerControllerMediaURL] as? String, image: image)
            delegate?.selected(photo: photo)
            onImageSelected?(.success(image))
        } else {
            onImageSelected?(.failure(Error.unkown))
        }
        presentingView?.dismiss(animated: true, completion: nil)
    }
}

extension ImagePicker {
    enum Error: LocalizedError {
        case cancelled
        case unkown

        public var errorDescription: String? {
            switch self {
            case .cancelled: return "Cancelled by user."
            case .unkown: return "Unknown error."
            }
        }
    }
}
