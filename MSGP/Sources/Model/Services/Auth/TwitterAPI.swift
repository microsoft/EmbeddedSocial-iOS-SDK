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
    
    func login(from viewController: UIViewController?, handler: @escaping (Result<SocialUser>) -> Void) {
        Twitter.sharedInstance().logIn(with: viewController, methods: [.webBasedForceLogin]) { [weak self] session, error in
            guard error == nil else {
                handler(.failure(error!))
                return
            }
            
            guard let session = session else {
                fatalError("Unknown result. Please investigate this case and provide proper handling.")
            }
            
            self?.loadSocialUser(session: session, completion: handler)
        }
    }
    
    private func loadSocialUser(session: TWTRSession, completion: @escaping (Result<SocialUser>) -> Void) {
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
            guard let user = self.makeUser(twitterUser: twitterUser, email: email, token: session.authToken) else {
                completion(.failure(APIError.missingUserData))
                return
            }
            completion(.success(user))
        }
    }
    
    private func makeUser(twitterUser: TWTRUser?, email: String?, token: String) -> SocialUser? {
        guard let twitterUser = twitterUser else {
            return nil
        }
        
        let (firstName, lastName) = NameComponentsSplitter.split(fullName: twitterUser.name)
        return SocialUser(uid: twitterUser.userID,
                          token: token,
                          requestToken: nil,
                          firstName: firstName,
                          lastName: lastName,
                          email: email,
                          photo: Photo(url: twitterUser.profileImageURL),
                          provider: .twitter)
    }
}

extension TwitterAPI {
    
    enum APIError: LocalizedError {
        case missingUserData
        
        public var errorDescription: String? {
            switch self {
            case .missingUserData: return "User data is missing."
            }
        }
    }
}
