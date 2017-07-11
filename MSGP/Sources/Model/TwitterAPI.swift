//
//  TwitterAPI.swift
//  MSGP
//
//  Created by Vadim Bulavin on 7/11/17.
//  Copyright © 2017 Igor Popov. All rights reserved.
//

import Foundation
import TwitterKit

final class TwitterAPI: AuthAPI {
    
    func login(from viewController: UIViewController?, handler: @escaping (Result<User>) -> Void) {

        Twitter.sharedInstance().logIn(completion: { [weak self] (session, error) in
            guard error == nil else {
                handler(.failure(error!))
                return
            }
            
            guard let session = session else {
                fatalError("Unknown result. Please investigate this case and provide proper handling.")
            }
            
            self?.requestEmail(session: session, completion: handler)
        })
    }
    
    private func requestEmail(session: TWTRSession, completion: @escaping (Result<User>) -> Void) {
        let client = TWTRAPIClient.withCurrentUser()
        
        client.requestEmail { email, error in
            if let error = error {
                print(error)
            }
            
            let user = User(name: session.userName,
                            email: email,
                            bio: nil,
                            phoneNumber: nil,
                            token: session.authToken,
                            provider: .twitter)
            completion(.success(user))
        }
    }
}
