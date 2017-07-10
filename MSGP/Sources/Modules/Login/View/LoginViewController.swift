//
//  LoginLoginViewController.swift
//  MSGP
//
//  Created by ls on 06/07/2017.
//  Copyright © 2017 Akvelon. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, LoginViewInput {

    @IBOutlet fileprivate weak var createAccountButton: UIButton!
    
    @IBOutlet fileprivate weak var loginButton: UIButton!
    
    @IBOutlet fileprivate weak var passwordTextField: UITextField! {
        didSet {
            passwordTextField.delegate = self
            passwordTextField.addTarget(self, action: #selector(self.passwordDidChange(_:)), for: .editingChanged)
        }
    }
    
    @IBOutlet fileprivate weak var emailTextField: UITextField! {
        didSet {
            emailTextField.delegate = self
            emailTextField.addTarget(self, action: #selector(self.emailDidChange(_:)), for: .editingChanged)
        }
    }
    
    var output: LoginViewOutput!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        output.viewIsReady()
    }

    func setupInitialState() {
        passwordTextField.text = ""
        emailTextField.text = ""
    }
    
    @IBAction func onCreateAccount(_ sender: UIButton) {
        output.onCreateAccountTapped()
    }
    
    @IBAction func onLogin(_ sender: UIButton) {
        output.onLoginTapped()
    }
    
    @objc private func passwordDidChange(_ textField: UITextField) {
        output.onPasswordChanged(textField.text)
    }
    
    @objc private func emailDidChange(_ textField: UITextField) {
        output.onEmailChanged(textField.text)
    }
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
