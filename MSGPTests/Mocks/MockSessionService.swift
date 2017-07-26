//
//  MockSessionService.swift
//  MSGP
//
//  Created by Vadim Bulavin on 7/25/17.
//  Copyright © 2017 Akvelon. All rights reserved.
//

@testable import MSGP

final class MockSessionService: SessionServiceType {
    private(set) var makeNewSessionCount = 0
    
    func makeNewSession(with credentials: CredentialsList, userUID: String, completion: @escaping (Result<String>) -> Void) {
        makeNewSessionCount += 1
    }
}

