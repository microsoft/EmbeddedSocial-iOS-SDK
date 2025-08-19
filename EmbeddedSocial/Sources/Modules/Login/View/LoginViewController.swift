//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import UIKit

class LoginViewController: BaseViewController, LoginViewInput {
    
    @IBOutlet fileprivate weak var facebookButton: UIButton!
    @IBOutlet fileprivate weak var twitterButton: UIButton!
    @IBOutlet fileprivate weak var microsoftButton: UIButton!
    @IBOutlet fileprivate weak var googleButton: UIButton!
    
    @IBOutlet fileprivate weak var signInWithLabel: UILabel!

    @IBOutlet fileprivate weak var loadingIndicatorView: LoadingIndicatorView!
    
    @IBOutlet fileprivate weak var buttonsContainerView: UIView!
    
    var output: LoginViewOutput!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        output.viewIsReady()
        apply(theme: theme)
    }
    
    func setupInitialState() {
        setupColors()
    }
    
    private func setupColors() {
        loadingIndicatorView.apply(style: .standard)
        
        for button in [facebookButton, twitterButton, microsoftButton, googleButton] {
            button?.setTitleColor(Palette.darkGrey, for: .normal)
            button?.titleLabel?.font = AppFonts.regular
        }
    }
    
    func showError(_ error: Error) {
        showErrorAlert(error)
    }
    
    func setIsLoading(_ isLoading: Bool) {
        loadingIndicatorView.isHidden = !isLoading
        buttonsContainerView.isHidden = isLoading
        loadingIndicatorView.isLoading = isLoading
        navigationItem.leftBarButtonItem?.isEnabled = !isLoading
    }
    
    func addLeftNavigationCancelButton() {
        navigationItem.leftBarButtonItem =
            UIBarButtonItem(title: L10n.Common.cancel, style: .plain, target: self, action: #selector(self.onCancel))
    }
    
    @objc private func onCancel() {
        output.onCancel()
    }
    
    @IBAction fileprivate func onFacebookSignIn(_ sender: UIButton) {
        output.onFacebookSignInTapped()
    }
    
    @IBAction fileprivate func onTwitterSignIn(_ sender: UIButton) {
        output.onTwitterSignInTapped()
    }
    
    @IBAction fileprivate func onMicrosoftSignIn(_ sender: UIButton) {
        output.onMicrosoftSignInTapped()
    }
    
    @IBAction fileprivate func onGooglePlusSignIn(_ sender: UIButton) {
        output.onGoogleSignInTapped()
    }
}

extension LoginViewController: Themeable {
    
    func apply(theme: Theme?) {
        guard let theme = theme else {
            return
        }
        let palette = theme.palette
        view.backgroundColor = palette.contentBackground
        signInWithLabel.textColor = palette.textPrimary
        
        [facebookButton, googleButton, microsoftButton, twitterButton].forEach {
            $0?.setTitleColor(palette.textPrimary, for: .normal)
        }
    }
}
