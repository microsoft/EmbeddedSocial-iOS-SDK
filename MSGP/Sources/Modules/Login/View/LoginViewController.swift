//
//  LoginLoginViewController.swift
//  MSGP
//
//  Created by ls on 06/07/2017.
//  Copyright © 2017 Akvelon. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, LoginViewInput {
    
    @IBOutlet fileprivate weak var facebookButton: UIButton!
    @IBOutlet fileprivate weak var twitterButton: UIButton!
    @IBOutlet fileprivate weak var microsoftButton: UIButton!
    @IBOutlet fileprivate weak var googleButton: UIButton!
    
    @IBOutlet fileprivate weak var loadingIndicatorView: LoadingIndicatorView!
    
    @IBOutlet fileprivate weak var buttonsContainerView: UIView!
    
    var output: LoginViewOutput!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        output.viewIsReady()
    }
    
    func setupInitialState() {
        setupColors()
    }
    
    private func setupColors() {
        loadingIndicatorView.apply(style: .standard)
        
        for button in [facebookButton, twitterButton, microsoftButton, googleButton] {
            button?.setTitleColor(Palette.darkGrey, for: .normal)
            button?.titleLabel?.font = Fonts.regular
        }
    }
    
    func showError(_ error: Error) {
        showErrorAlert(error)
    }
    
    func setIsLoading(_ isLoading: Bool) {
        loadingIndicatorView.isHidden = !isLoading
        buttonsContainerView.isHidden = isLoading
        loadingIndicatorView.isLoading = isLoading
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
