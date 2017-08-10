//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import UIKit
import SDWebImage
import SVProgressHUD

class CreatePostViewController: BaseViewController, CreatePostViewInput {

    var output: CreatePostViewOutput!
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet fileprivate weak var userImageView: UIImageView!
    @IBOutlet fileprivate weak var mediaButton: UIButton!
    @IBOutlet fileprivate weak var titleTextField: UITextField!
    @IBOutlet fileprivate weak var postBodyTextViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet fileprivate weak var postBodyTextView: UITextView!
    @IBOutlet weak var mediaButtonHeightConstraint: NSLayoutConstraint!
    
    fileprivate let imagePikcer = ImagePicker()
    fileprivate var photo: Photo?
    fileprivate var postButton: UIBarButtonItem!

    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        output.viewIsReady()
    }

    // MARK: CreatePostViewInput
    func setupInitialState() {
        postButton = UIBarButtonItem(title: Button.Title.post, style: .plain,
                                     target: self, action: #selector(post))
        imagePikcer.delegate = self
        title = Titles.addPost
        postButton.isEnabled = false
        let backButton = UIBarButtonItem(image: UIImage(named:"icon_back"), style: .plain, target: self, action: #selector(back))
        navigationItem.rightBarButtonItem = postButton
        navigationItem.leftBarButtonItem = backButton
    }
    
    func topicCreated() {
        SVProgressHUD.dismiss()
    }
    
    func show(user: User) {
        userImageView.layer.cornerRadius = userImageView.bounds.size.height/2
        usernameLabel.text = "\(user.firstName!) \(user.lastName!)"
        userImageView.setPhotoWithCaching(user.photo, placeholder: UIImage(asset: .userPhotoPlaceholder))
    }
    
    func show(error: Error) {
        SVProgressHUD.dismiss()
        let alert = UIAlertController(title: error.localizedDescription, message: nil, preferredStyle: .alert)
        let action = UIAlertAction(title: Button.Title.ok, style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: Actions
    @objc fileprivate func post() {
        SVProgressHUD.show()
        output.post(photo: photo, title: titleTextField.text, body: postBodyTextView.text)
    }
    
    @IBAction fileprivate func mediaButtonPressed(_ sender: Any) {
        let options = ImagePicker.Options(title: Alerts.Titles.choose,
                                          message: nil,
                                          sourceViewController: self)
        imagePikcer.show(with: options)
    }
    
    @objc fileprivate func back() {
        if postBodyTextView.text.isEmpty && (titleTextField.text?.isEmpty)! && photo == nil {
            output.back()
        }
        
        let actionSheet = UIAlertController(title: Alerts.Titles.returnToFeed,
                                            message: Alerts.Messages.leaveNewPost, preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: Button.Title.cancel, style: .cancel, handler: nil)
        actionSheet.addAction(cancelAction)
        
        let leavePostAction = UIAlertAction(title: Button.Title.leavePost, style: .default) { (_) in
            self.output.back()
        }
        actionSheet.addAction(leavePostAction)
        
        present(actionSheet, animated: true, completion: nil)
    }
}

// MARK: ImagePickerDelegate
extension CreatePostViewController: ImagePickerDelegate {
    func selected(photo: Photo) {
        mediaButtonHeightConstraint.priority = 250
        self.photo = photo
        let image = photo.image
        let size = CGSize(width: UIScreen.main.bounds.width, height: (image?.size.height)!)
        let resizedImage = image?.scaledToFit(toSize: size)
        mediaButton.setImage(resizedImage, for: .normal)
        view.layoutIfNeeded()
    }
}

// MARK: UITextViewDelegate
extension CreatePostViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        postBodyTextViewHeightConstraint.constant = postBodyTextView.contentSize.height
        view.layoutIfNeeded()
        textView.setContentOffset(CGPoint.zero, animated:false)
        postButton.isEnabled = !textView.text.isEmpty
    }
}
