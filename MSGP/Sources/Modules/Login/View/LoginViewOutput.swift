//
//  LoginLoginViewOutput.swift
//  MSGP
//
//  Created by ls on 06/07/2017.
//  Copyright © 2017 Akvelon. All rights reserved.
//

import Foundation

protocol LoginViewOutput {
    func viewIsReady()
    
    func onCreateAccountTapped()
    
    func onEmailChanged(_ text: String?)
    
    func onPasswordChanged(_ text: String?)
    
    func onLoginTapped()
}
