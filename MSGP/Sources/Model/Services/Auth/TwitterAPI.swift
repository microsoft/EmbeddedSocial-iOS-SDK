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
        Twitter.sharedInstance().logIn(completion: { [weak self] session, error in
            guard error == nil else {
                handler(.failure(error!))
                return
            }
            
            guard let session = session else {
                fatalError("Unknown result. Please investigate this case and provide proper handling.")
            }
            
            self?.loadUser(session: session, completion: handler)
        })
    }
    
    private func loadUser(session: TWTRSession, completion: @escaping (Result<User>) -> Void) {
        let client = TWTRAPIClient(userID: session.userID)
        let group = DispatchGroup()
        
        var email: String?
        var twitterUser: TWTRUser?
        
        group.enter()
        client.requestEmail { fetchedEmail, error in
            if let error = error {
                print(error)
            }
            email = fetchedEmail
            group.leave()
        }
        
        group.enter()
        client.loadUser(withID: session.userID) { user, error in
            if let error = error {
                print(error)
            }
            twitterUser = user
            group.leave()
        }
        
        group.notify(queue: DispatchQueue.main) {
            let user = User(name: twitterUser?.name,
                            email: email,
                            bio: nil,
                            phoneNumber: nil,
                            token: session.authToken,
                            photo: Photo(url: twitterUser?.profileImageURL),
                            provider: .twitter)
            completion(.success(user))
        }
    }
}
