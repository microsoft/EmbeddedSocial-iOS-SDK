//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation
import TwitterKit

final class TwitterAPI: AuthAPI {
        
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
        
        group.notify(queue: DispatchQueue.main) {
            guard let twitterUser = twitterUser else {
                completion(.failure(APIError.missingUserData))
                return
            }
            
            let (firstName, lastName) = NameComponentsSplitter.split(fullName: twitterUser.name)
            let credentials = CredentialsList(provider: .twitter,
                                              accessToken: session.authTokenSecret,
                                              requestToken: session.authToken,
                                              socialUID: twitterUser.userID)
            let user = SocialUser(credentials: credentials,
                                  firstName: firstName,
                                  lastName: lastName,
                                  email: email,
                                  photo: Photo(url: twitterUser.profileImageURL))
            completion(.success(user))
        }
    }
}
