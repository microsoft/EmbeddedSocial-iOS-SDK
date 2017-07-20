//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import OAuthSwift
import UIKit
import SafariServices
import TwitterKit

final class TwitterWebBasedAPI: AuthAPI {
    
    fileprivate let authenticator = OAuth1Swift(
        consumerKey: ThirdPartyConfigurator.Keys.twitterConsumerKey,
        consumerSecret: ThirdPartyConfigurator.Keys.twitterConsumerSecret,
        requestTokenUrl: "https://api.twitter.com/oauth/request_token",
        authorizeUrl: "https://api.twitter.com/oauth/authorize",
        accessTokenUrl: "https://api.twitter.com/oauth/access_token"
    )
    
    private lazy var internalWebViewController: WebViewController = {
        let controller = WebViewController()
        controller.view = UIView(frame: UIScreen.main.bounds) // needed if no nib or not loaded from storyboard
        controller.delegate = self
        controller.urlScheme = "twitterkit-\(ThirdPartyConfigurator.Keys.twitterConsumerKey)"
        controller.viewDidLoad()
        return controller
    }()
    
    fileprivate var request: OAuthSwiftRequestHandle?
    
    func login(from viewController: UIViewController?, handler: @escaping (Result<SocialUser>) -> Void) {
        authenticator.authorizeURLHandler = urlHandler(withType: .safari, sourceViewController: viewController)
        
        authenticator.authorize(
            withCallbackURL: URL(string: "\(Constants.oauth1URLScheme)://oauth-callback/twitter")!,
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
            failure: { _ in handler(.failure(APIError.unknown)) }
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
        handler.factory = { return SFSafariViewController(url: $0) }
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
