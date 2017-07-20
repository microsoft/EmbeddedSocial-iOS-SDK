//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import UIKit

class CreatePostViewController: BaseViewController, CreatePostViewInput {

    var output: CreatePostViewOutput!
    
    @IBOutlet fileprivate weak var usernameLabel: UILabel!
    @IBOutlet fileprivate weak var userImageView: UIImageView!
    @IBOutlet fileprivate weak var mediaButton: UIButton!
    @IBOutlet fileprivate weak var titleTextField: UITextField!
    @IBOutlet fileprivate weak var postBodyTextViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet fileprivate weak var postBodyTextView: UITextView!
    @IBOutlet fileprivate weak var bodyPlaceholderLabel: UILabel!
    
    fileprivate let imagePikcer = ImagePicker()
    fileprivate var originImage: UIImage?
    fileprivate var postButton: UIBarButtonItem!

    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        output.viewIsReady()
    }

    // MARK: CreatePostViewInput
    func setupInitialState() {
        postButton = UIBarButtonItem(title: Button.Title.post, style: .plain,
                                     target: self, action: #selector(CreatePostViewController.post))
        imagePikcer.delegate = self
        title = Titles.addPost
        postButton.isEnabled = false
        let backButton = UIBarButtonItem(image: #imageLiteral(resourceName: "icon_back"), style: .plain, target: self, action: #selector(CreatePostViewController.back))
        navigationItem.rightBarButtonItem = postButton
        navigationItem.leftBarButtonItem = backButton
        // TODO: config user data (avatar + name)
    }
    
    func showError(error: Error) {
        let alert = UIAlertController(title: error.localizedDescription, message: nil, preferredStyle: .alert)
        let action = UIAlertAction(title: Button.Title.ok, style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: Actions
    @objc fileprivate func post() {
        output.post(image: originImage, title: titleTextField.text, body: postBodyTextView.text)
    }
    
    @IBAction fileprivate func mediaButtonPressed(_ sender: Any) {
        let options = ImagePicker.Options(title: Alerts.Titles.choose,
                                          message: Alerts.Messages.leaveNewPost,
                                          sourceViewController: self)
        imagePikcer.show(with: options)
    }
    
    @objc fileprivate func back() {
        if postBodyTextView.text.isEmpty && (titleTextField.text?.isEmpty)! && originImage == nil {
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
    func selected(image: UIImage) {
        let size = CGSize(width: UIScreen.main.bounds.width, height: image.size.height)
        let resizedImage = image.scaledToFit(toSize: size)
        mediaButton.setImage(resizedImage, for: .normal)
        view.layoutIfNeeded()
    }
}

// MARK: UITextViewDelegate
extension CreatePostViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        bodyPlaceholderLabel.isHidden = textView.text.isEmpty
        postBodyTextViewHeightConstraint.constant = postBodyTextView.contentSize.height
        view.layoutIfNeeded()
        textView.setContentOffset(CGPoint.zero, animated:false)
        postButton.isEnabled = !textView.text.isEmpty
    }
}
