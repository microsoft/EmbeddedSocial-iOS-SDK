//
//  TwitterAPI.swift
//  MSGP
//
//  Created by Vadim Bulavin on 7/11/17.
//  Copyright © 2017 Akvelon. All rights reserved.
//

import Foundation
import TwitterKit

final class TwitterAPI: AuthAPI {
    
    private let accessToken = "884682909340315649-clk3svGPZRWDjJdmKWNpUQtQr0euBx2"
    
    func login(from viewController: UIViewController?, handler: @escaping (Result<User>) -> Void) {
        Twitter.sharedInstance().logIn(with: viewController, methods: [.webBasedForceLogin]) { [weak self] session, error in
            guard error == nil else {
                handler(.failure(error!))
                return
            }
            
            guard let session = session else {
                fatalError("Unknown result. Please investigate this case and provide proper handling.")
            }
            
            self?.loadUser(session: session, completion: handler)
        }
    }
    
    private func loadUser(session: TWTRSession, completion: @escaping (Result<User>) -> Void) {
        let client = TWTRAPIClient(userID: session.userID)
        let group = DispatchGroup()
        
        var email: String?
        var twitterUser: TWTRUser?
        
        group.enter()
        client.requestEmail { fetchedEmail, _ in
            email = fetchedEmail
            group.leave()
        }
        
        group.enter()
        client.loadUser(withID: session.userID) { user, _ in
            twitterUser = user
            group.leave()
        }
        
        group.notify(queue: DispatchQueue.main) { [unowned self] in
            let user = self.makeUser(twitterUser: twitterUser, email: email, token: session.authToken)
            completion(.success(user))
        }
    }
    
    private func makeUser(twitterUser: TWTRUser?, email: String?, token: String) -> User {
        let (firstName, lastName) = NameComponentsSplitter.split(fullName: twitterUser?.name ?? "")
        return User(firstName: firstName,
                    lastName: lastName,
                    email: email,
                    token: token,
                    photo: Photo(url: twitterUser?.profileImageURL),
                    provider: .twitter)
    }
}
