//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import UIKit

class BaseViewController: UIViewController {
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        SocialPlus.shared.networkTracker.addListener(self)
        configNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        view.endEditing(true)
        SocialPlus.shared.networkTracker.removeListener(self)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
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
                                               name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)),
                                               name: UIResponder.keyboardWillHideNotification, object: nil)
    }

}

// MARK: keyboard notifications
extension BaseViewController {
    @objc func keyboardWillShow(notification: Notification) {
        guard let value = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
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
    
    @objc func keyboardWillHide(notification: Notification) {
        bottomConstraint?.constant = CGFloat(0)
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.view.layoutIfNeeded()
        }
    }
}

extension BaseViewController: NetworkStatusListener {
    func networkStatusDidChange(_ isReachable: Bool) {
            
        guard let vc =  self.navigationController?.viewControllers.last else {
            return
        }
        
        if !isReachable {
            OfflineView.show(in: vc)
        } else {
            OfflineView.hide()
        }
        
    }
}
