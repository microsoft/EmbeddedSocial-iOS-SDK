//
//  CreateAccountCreateAccountViewOutput.swift
//  MSGP
//
//  Created by ls on 06/07/2017.
//  Copyright © 2017 Akvelon. All rights reserved.
//

protocol CreateAccountViewOutput {
    func viewIsReady()
    
    func onFirstNameChanged(_ text: String?)
    
    func onLastNameChanged(_ text: String?)
    
    func onBioChanged(_ text: String?)
    
    func onSelectPhoto()
    
    func onCreateAccount()
}
