//
//  CreatePostCreatePostViewController.swift
//  MSGP-Framework
//
//  Created by generamba setup on 12/07/2017.
//  Copyright © 2017 akvelon. All rights reserved.
//

import UIKit

class CreatePostViewController: BaseViewController, CreatePostViewInput {

    var output: CreatePostViewOutput!
    
    @IBOutlet fileprivate weak var usernameLabel: UILabel!
    @IBOutlet fileprivate weak var userImageView: UIImageView!
    @IBOutlet fileprivate weak var mediaButton: UIButton!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet fileprivate weak var postBodyTextViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet fileprivate weak var postBodyTextView: UITextView!
    @IBOutlet fileprivate weak var bodyPlaceholderLabel: UILabel!
    
    fileprivate let imagePikcer = ImagePicker()
    fileprivate var originImage: UIImage?

    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        output.viewIsReady()
    }

    // MARK: CreatePostViewInput
    func setupInitialState() {
        imagePikcer.delegate = self
        title = Titles.addPost
        
        let postButton = UIBarButtonItem(title: Button.Title.post, style: .plain,
                                         target: self, action: #selector(CreatePostViewController.post))
        let backButton = UIBarButtonItem(image: #imageLiteral(resourceName: "icon_back"), style: .plain, target: self, action: #selector(CreatePostViewController.back))
        navigationItem.rightBarButtonItem = postButton
        navigationItem.leftBarButtonItem = backButton
    }
    
    func showError(error: Error) {
        // TODO: Handle
    }
    
    // MARK: Actions
    @objc fileprivate func post() {
        if !postBodyTextView.text.isEmpty {
            output.post(image: originImage, title: titleTextField.text, body: postBodyTextView.text)
        } else {
            //TODO: Handle
        }
        
    }
    
    @IBAction fileprivate func mediaButtonPressed(_ sender: Any) {
        imagePikcer.show(from: self)
    }
    
    @objc fileprivate func back() {
        let actionSheet = UIAlertController(title: Alerts.Titles.returnToFeed,
                                            message: Alerts.Messages.leaveNewPost, preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: Button.Title.cancel, style: .cancel) { (_) in
            
        }
        actionSheet.addAction(cancelAction)
        
        let leavePostAction = UIAlertAction(title: Button.Title.leavePost, style: .default) { (_) in
            self.navigationController?.popViewController(animated: true)
        }
        actionSheet.addAction(leavePostAction)
        
        present(actionSheet, animated: true, completion: nil)
    }
}

// MARK: ImagePickerDelegate
extension CreatePostViewController: ImagePickerDelegate {
    func selected(image: UIImage) {
        mediaButton.setImage(imagePikcer.resizeImage(image: image, newWidth: UIScreen.main.bounds.width), for: .normal)
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
    }
}
