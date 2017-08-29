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
    
    fileprivate let imagePicker = ImagePicker()
    fileprivate var photo: Photo?
    fileprivate var postButton: UIBarButtonItem!

    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        output.viewIsReady()
    }
    
    // MARK: CreatePostViewInput
    func setupInitialState() {
        let backButton = UIBarButtonItem(asset: .iconBack, title: "", font: nil, color: .black) { [weak self] in
            self?.back()
        }
        navigationItem.leftBarButtonItem = backButton
    }
    
    func configTitlesForExistingPost() {
        postButton = UIBarButtonItem(title: L10n.CreatePost.save, style: .plain,
                                     target: self, action: #selector(post))
        title = L10n.CreatePost.Button.updatePost
        navigationItem.rightBarButtonItem = postButton
    }
    
    func configTitlesWithoutPost() {
        postButton = UIBarButtonItem(title: L10n.CreatePost.post, style: .plain,
                                     target: self, action: #selector(post))
        postButton.isEnabled = false
        imagePicker.delegate = self
        title = L10n.CreatePost.Button.addPost
        navigationItem.rightBarButtonItem = postButton
    }
    
    func topicCreated() {
        SVProgressHUD.dismiss()
    }
    
    func topicUpdated() {
        SVProgressHUD.dismiss()
    }
    
    func show(user: User) {
        userImageView.layer.cornerRadius = userImageView.bounds.size.height/2
        usernameLabel.text = "\(user.firstName!) \(user.lastName!)"
        userImageView.setPhotoWithCaching(user.photo, placeholder: UIImage(asset: .userPhotoPlaceholder))
    }
    
    func show(post: Post) {
        postBodyTextView.text = post.text
        titleTextField.text = post.title
        postBodyTextViewHeightConstraint.constant = postBodyTextView.contentSize.height
        mediaButton.setPhotoWithCaching(Photo(url: post.imageUrl), placeholder: UIImage(asset: .placeholderPostNoimage))
        mediaButton.isEnabled = false
        postButton.isEnabled = true
        view.layoutIfNeeded()
    }
    
    func show(error: Error) {
        SVProgressHUD.dismiss()
        let alert = UIAlertController(title: error.localizedDescription, message: nil, preferredStyle: .alert)
        let action = UIAlertAction(title: L10n.Common.ok, style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: Actions
    @objc fileprivate func post() {
        SVProgressHUD.show()
        output.post(photo: photo, title: titleTextField.text, body: postBodyTextView.text)
    }
    
    @IBAction fileprivate func mediaButtonPressed(_ sender: Any) {
        let options = ImagePicker.Options(title: L10n.ImagePicker.choosePlease,
                                          message: nil,
                                          sourceViewController: self)
        imagePicker.show(with: options)
    }
    
    fileprivate func back() {
        if postBodyTextView.text.isEmpty && (titleTextField.text?.isEmpty)! && photo == nil {
            output.back()
        }
        
        let actionSheet = UIAlertController(title: L10n.CreatePost.returnToFeed,
                                            message: L10n.CreatePost.leaveNewPost, preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: L10n.Common.cancel, style: .cancel, handler: nil)
        actionSheet.addAction(cancelAction)
        
        let leavePostAction = UIAlertAction(title: L10n.CreatePost.leavePost, style: .default) { (_) in
            self.output.back()
        }
        actionSheet.addAction(leavePostAction)
        
        present(actionSheet, animated: true, completion: nil)
    }
}

// MARK: ImagePickerDelegate
extension CreatePostViewController: ImagePickerDelegate {
    
    func removePhoto() {
        photo = nil
        mediaButton.setImage(nil, for: .normal)
        mediaButton.setTitle(L10n.CreatePost.Button.addPicture, for: .normal)
        postButton.isEnabled = !postBodyTextView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

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
        postButton.isEnabled = !textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}
