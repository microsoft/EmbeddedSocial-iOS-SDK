//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import OAuthSwift
import UIKit
import SafariServices

final class TwitterServerBasedAPI: NSObject, AuthAPI {
    
    private let sessionService = SessionService()
    
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
    
    fileprivate var loginCompletion: ((Result<SocialUser>) -> Void)?
    
    func login(from viewController: UIViewController?, handler: @escaping (Result<SocialUser>) -> Void) {
        loginCompletion = handler
        
        authenticator.authorizeURLHandler = urlHandler(withType: .safari, sourceViewController: viewController)
        
        sessionService.requestToken(authProvider: .twitter) { [unowned self] result in
            guard let token = result.value else {
                handler(.failure(APIError(error: result.error as? ErrorResponse)))
                return
            }
            
            self.authenticator.client.credential.oauthToken = token
            
            self.authorize(requestToken: token, handler: handler)
        }
    }
    
    private func authorize(requestToken: String, handler: @escaping (Result<SocialUser>) -> Void) {
        authenticator.authorize(
            withCallbackURL: URL(string: "\(Constants.oauth1URLScheme)://oauth-callback/twitter")!,
            success: { [weak self] credential, _, _ in
                let userID = UUID().uuidString
                self?.loadSocialUser(userID: userID,
                                     requestToken: requestToken,
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
        
        let credentials = CredentialsList(provider: .twitter,
                                          accessToken: accessToken,
                                          requestToken: requestToken,
                                          socialUID: userID)
        
        let user = SocialUser(credentials: credentials, firstName: nil, lastName: nil, email: nil, photo: Photo())
        
        completion(.success(user))
    }
    
    private func urlHandler(withType type: URLHandlerType, sourceViewController: UIViewController?) -> OAuthSwiftURLHandlerType {
        switch type {
        case .external:
            return OAuthSwiftOpenURLExternally.sharedInstance
        case .embedded:
            if internalWebViewController.parent == nil {
                sourceViewController?.addChildViewController(internalWebViewController)
            }
            return internalWebViewController
        case .safari:
            if let vc = sourceViewController {
                return makeSafariURLHandler(viewController: vc)
            } else {
                return urlHandler(withType: .embedded, sourceViewController: sourceViewController)
            }
        }
    }
    
    private func makeSafariURLHandler(viewController: UIViewController) -> SafariURLHandler {
        let handler = SafariURLHandler(viewController: viewController, oauthSwift: authenticator)
        handler.factory = { SFSafariViewController(url: $0) }
        handler.delegate = self
        return handler
    }
}

extension TwitterServerBasedAPI {
    enum URLHandlerType {
        case embedded
        case external
        case safari
    }
}

extension TwitterServerBasedAPI: SFSafariViewControllerDelegate {
    
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        authenticator.cancel()
        loginCompletion?(.failure(APIError.cancelled))
    }
}

extension TwitterServerBasedAPI: OAuthWebViewControllerDelegate {
    
    func oauthWebViewControllerDidPresent() { }
    
    func oauthWebViewControllerDidDismiss() { }
    
    func oauthWebViewControllerWillAppear() { }
    
    func oauthWebViewControllerDidAppear() { }
    
    func oauthWebViewControllerWillDisappear() { }
    
    func oauthWebViewControllerDidDisappear() {
        authenticator.cancel()
    }
}
