//
//  BaseViewController.swift
//  MSGP
//
//  Created by Mac User on 12.07.17.
//  Copyright © 2017 Igor Popov. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configNotifications()
        self.view.setNeedsLayout()
        self.view.layoutIfNeeded()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Public
    class func identifier() -> String {
        return NSStringFromClass(self)
    }
    
    // MARK: - Private
    func configNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)),
                                               name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)),
                                               name: .UIKeyboardWillHide, object: nil)
    }

}

// MARK: keyboard notifications
extension BaseViewController {
    func keyboardWillShow(notification: Notification) {
        guard let value = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue else {
            return
        }
        
        let rawFrame = value.cgRectValue
        let keyboardFrame = view.convert(rawFrame, from: nil)
        let keyboardheight = keyboardFrame.size.height
        bottomConstraint?.constant = keyboardheight
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.view.layoutIfNeeded()
        }
    }
    
    func keyboardWillHide(notification: Notification) {
        bottomConstraint?.constant = CGFloat(0)
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.view.layoutIfNeeded()
        }
    }
}
