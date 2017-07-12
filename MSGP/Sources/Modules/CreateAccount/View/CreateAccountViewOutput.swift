//
//  CreateAccountCreateAccountViewOutput.swift
//  MSGP
//
//  Created by ls on 06/07/2017.
//  Copyright © 2017 Akvelon. All rights reserved.
//

protocol CreateAccountViewOutput {
    func viewIsReady()
    
    func onCreateTapped()
    
    func onEmailChanged(_ text: String?)
    
    func onPasswordChanged(_ text: String?)
}
