//
//  MicrosoftAPI.swift
//  MSGP
//
//  Created by Vadim Bulavin on 7/12/17.
//  Copyright © 2017 Akvelon. All rights reserved.
//

import Foundation
import MSAL
import MSGraphSDK
import MSGraphSDK_NXOAuth2Adapter

final class MicrosoftAPI: AuthAPI {
    private let clientID = "5e4ecf55-0958-4324-b32a-332e42064697"
    private let scopes = ["https://graph.microsoft.com/User.Read"]
    private let graphClient: MSGraphClient
    
    init() {
        MSGraphClient.setAuthenticationProvider(NXOAuth2AuthenticationProvider.sharedAuth())
        graphClient = MSGraphClient()
    }
    
    func login(from viewController: UIViewController?, handler: @escaping (Result<User>) -> Void) {
        guard let application = try? MSALPublicClientApplication(clientId: clientID) else {
            let url = "https://github.com/AzureAD/microsoft-authentication-library-for-objc"
            fatalError("Microsoft ClientId is not set. Please follow instructions from \(url)")
        }
        
        application.acquireToken(forScopes: scopes) { (result, error) in
            print(result, error)
            let name = result?.user.name
            
            
            if error == nil {
                
                // You'll want to get the user identifier to retrieve and reuse the user
                // for later acquireToken calls
                
                let userIdentifier = result?.user.userIdentifier
                let accessToken = result?.accessToken
                
                self.graphClient.me().request().getWithCompletion { user, error in
                    print(user, error)
                }
                
            } else {
                // Check error
            }
        }
    }
}

//
//  MicrosoftAPI.swift
//  MSGP
//
//  Created by Vadim Bulavin on 7/12/17.
//  Copyright © 2017 Akvelon. All rights reserved.
//
//
//import Foundation
//import MSGraphSDK
//import MSGraphSDK_NXOAuth2Adapter
//
//final class MicrosoftAPI: AuthAPI {
//    
//    private let scopes = ["https://graph.microsoft.com/User.Read", "offline_access"]
//    private let clientID = "5e4ecf55-0958-4324-b32a-332e42064697"
//    
//    func login(from viewController: UIViewController?, handler: @escaping (Result<User>) -> Void) {
//        connectToGraph(withClientId: clientID, scopes: scopes) { error in
//            if let graphError = error {
//                switch graphError {
//                case .nsErrorType(let nsError):
//                    print(NSLocalizedString("ERROR", comment: ""), nsError.localizedDescription)
//                    self.showError(message: NSLocalizedString("CHECK_LOG_ERROR", comment: ""))
//                }
//            }
//            else {
//                self.performSegue(withIdentifier: "showSendMail", sender: nil)
//            }
//        }
//    }
//    
//    func connectToGraph(withClientId clientId: String,
//                        scopes: [String],
//                        completion:@escaping (_ error: MSGraphError?) -> Void) {
//        
//        // Set client ID
//        NXOAuth2AuthenticationProvider.setClientId(clientId, scopes: scopes)
//        
//        // Try silent log in. This will attempt to sign in if there is a previous successful
//        // sign in user information.
//        if NXOAuth2AuthenticationProvider.sharedAuth().loginSilent() == true {
//            completion(nil)
//        }
//            // Otherwise, present log in controller.
//        else {
//            NXOAuth2AuthenticationProvider.sharedAuth()
//                .login(with: nil) { (error: Error?) in
//                    
//                    if let nserror = error {
//                        completion(MSGraphError.nsErrorType(error: nserror as NSError))
//                    }
//                    else {
//                        completion(nil)
//                    }
//            }
//        }
//    }
//    
//    func disconnect() {
//        NXOAuth2AuthenticationProvider.sharedAuth().logout()
//    }
//    
//}

