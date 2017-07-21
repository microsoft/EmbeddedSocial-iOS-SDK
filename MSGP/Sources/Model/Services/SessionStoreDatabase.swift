//
//  SessionStoreDatabase.swift
//  MSGP
//
//  Created by Vadim Bulavin on 7/20/17.
//  Copyright © 2017 Akvelon. All rights reserved.
//

import Foundation

protocol SessionStoreDatabase {
    func saveUser(_ user: User)
    
    func loadLastUser() -> User?
    
    func saveSessionToken(_ token: String)
    
    func loadLastSessionToken() -> String?
}
