//
//  TwitterWebBasedAPI.swift
//  MSGP
//
//  Created by Vadim Bulavin on 7/18/17.
//  Copyright © 2017 Akvelon. All rights reserved.
//

import OAuthSwift
import UIKit
import SafariServices
import TwitterKit

final class TwitterWebBasedAPI: AuthAPI {
    
    fileprivate let authenticator = OAuth1Swift(
        consumerKey: "2dw07dxA952U3QmEcT3TruHbd",
        consumerSecret: "c1eoCNGZP0hJ3UHiB50qIh9Y0TMSDq8LOYZ3gJO8blsql9sRB5",
        requestTokenUrl: "https://api.twitter.com/oauth/request_token",
        authorizeUrl: "https://api.twitter.com/oauth/authorize",
        accessTokenUrl: "https://api.twitter.com/oauth/access_token"
    )
    
    private lazy var internalWebViewController: WebViewController = {
        let controller = WebViewController()
        controller.view = UIView(frame: UIScreen.main.bounds) // needed if no nib or not loaded from storyboard
        controller.delegate = self
        controller.urlScheme = "twitterkit-2dw07dxA952U3QmEcT3TruHbd"
        controller.viewDidLoad()
        return controller
    }()
    
    fileprivate var request: OAuthSwiftRequestHandle?
    
    func login(from viewController: UIViewController?, handler: @escaping (Result<SocialUser>) -> Void) {
        authenticator.authorizeURLHandler = urlHandler(withType: .safari, sourceViewController: viewController)
        
        authenticator.authorize(
            withCallbackURL: URL(string: "msgp://oauth-callback/twitter")!,
            success: { [weak self] credential, _, parameters in
                guard let userID = parameters["user_id"] as? String else {
                    handler(.failure(APIError.missingUserData))
                    return
                }
                self?.loadSocialUser(userID: userID,
                                     requestToken: credential.oauthToken,
                                     accessToken: credential.oauthVerifier,
                                     completion: handler)
            },
            failure: { _ in handler(.failure(APIError.generic)) }
        )
    }
    
    private func loadSocialUser(userID: String,
                                requestToken: String,
                                accessToken: String,
                                completion: @escaping (Result<SocialUser>) -> Void) {
        let client = TWTRAPIClient(userID: userID)
        let group = DispatchGroup()
        
        var email: String?
        var twitterUser: TWTRUser?
        
        group.enter()
        client.requestEmail { fetchedEmail, _ in
            email = fetchedEmail
            group.leave()
        }
        
        group.enter()
        client.loadUser(withID: userID) { user, _ in
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
                                              accessToken: accessToken,
                                              requestToken: requestToken,
                                              socialUID: twitterUser.userID)
            let user = SocialUser(credentials: credentials,
                                  firstName: firstName,
                                  lastName: lastName,
                                  email: email,
                                  photo: Photo(url: twitterUser.profileImageURL))
            completion(.success(user))
        }
    }
    
    private func urlHandler(withType type: URLHandlerType, sourceViewController: UIViewController?) -> OAuthSwiftURLHandlerType {
        switch type {
        case .external :
            return OAuthSwiftOpenURLExternally.sharedInstance
        case .embedded:
            if internalWebViewController.parent == nil {
                sourceViewController?.addChildViewController(internalWebViewController)
            }
            return internalWebViewController
        case .safari:
            if #available(iOS 9.0, *),
                let vc = sourceViewController {
                return makeSafariURLHandler(viewController: vc)
            } else {
                return urlHandler(withType: .embedded, sourceViewController: sourceViewController)
            }
        }
    }
    
    @available(iOS 9.0, *)
    private func makeSafariURLHandler(viewController: UIViewController) -> SafariURLHandler {
        let handler = SafariURLHandler(viewController: viewController, oauthSwift: authenticator)
        handler.presentCompletion = {
            print("Safari presented")
        }
        handler.dismissCompletion = {
            print("Safari dismissed")
        }
        handler.factory = { url in
            return SFSafariViewController(url: url)
        }
        return handler
    }
}

extension TwitterWebBasedAPI {
    enum URLHandlerType {
        case embedded
        case external
        case safari
    }
}

extension TwitterWebBasedAPI: OAuthWebViewControllerDelegate {
    
    func oauthWebViewControllerDidPresent() { }
    
    func oauthWebViewControllerDidDismiss() { }
    
    func oauthWebViewControllerWillAppear() { }
    
    func oauthWebViewControllerDidAppear() { }
    
    func oauthWebViewControllerWillDisappear() { }
    
    func oauthWebViewControllerDidDisappear() {
        authenticator.cancel()
    }
}

extension TwitterWebBasedAPI {
    
    enum APIError: LocalizedError {
        case missingUserData
        case generic
        
        public var errorDescription: String? {
            switch self {
            case .missingUserData: return "User data is missing."
            case .generic: return "Twitter API error."
            }
        }
    }
}
