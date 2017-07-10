//
//  CreateAccountViewController.swift
//  MSGP
//
//  Created by ls on 06/07/2017.
//  Copyright © 2017 Akvelon. All rights reserved.
//

import UIKit

class CreateAccountViewController: UIViewController, CreateAccountViewInput {

    var output: CreateAccountViewOutput!

    @IBOutlet fileprivate weak var createButton: UIButton!
    
    @IBOutlet fileprivate weak var emailTextField: UITextField! {
        didSet {
            emailTextField.delegate = self
            emailTextField.addTarget(self, action: #selector(self.emailDidChange(_:)), for: .editingChanged)
        }
    }
    
    @IBOutlet fileprivate weak var passwordTextField: UITextField! {
        didSet {
            passwordTextField.delegate = self
            passwordTextField.addTarget(self, action: #selector(self.passwordDidChange(_:)), for: .editingChanged)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        output.viewIsReady()
    }

    func setupInitialState() {
        emailTextField.text = ""
        passwordTextField.text = ""
    }
    
    @IBAction func onCreate(_ sender: UIButton) {
        output.onCreateTapped()
    }
    
    @objc private func passwordDidChange(_ textField: UITextField) {
        output.onPasswordChanged(textField.text)
    }
    
    @objc private func emailDidChange(_ textField: UITextField) {
        output.onEmailChanged(textField.text)
    }
}

extension CreateAccountViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
