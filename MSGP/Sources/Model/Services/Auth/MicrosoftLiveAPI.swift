//
//  MicrosoftLiveAPI.swift
//  MSGP
//
//  Created by Vadim Bulavin on 7/19/17.
//  Copyright © 2017 Akvelon. All rights reserved.
//

import Foundation
import LiveSDK

final class MicrosoftLiveAPI: NSObject, AuthAPI {
    
    enum UserState: String {
        case initialize
        case login
    }
    
    private let clientID = ThirdPartyConfigurator.Keys.microsoftClientID
    private let scopes = ["wl.signin", "wl.emails"]
    
    private var client: LiveConnectClient!
    fileprivate var handler: ((Result<SocialUser>) -> Void)?
    fileprivate var accessToken: String?
    
    override init() {
        super.init()
        client = LiveConnectClient(clientId: clientID, scopes: scopes, delegate: self, userState: UserState.initialize.rawValue)
    }
    
    func login(from viewController: UIViewController?, handler: @escaping (Result<SocialUser>) -> Void) {
        self.handler = handler
        
        if client.session != nil {
            client.logout()
        }
        
        client.login(viewController, scopes: scopes, delegate: self, userState: UserState.login.rawValue)
    }
    
    fileprivate func processAuthCompleted(with status: LiveConnectSessionStatus, session: LiveConnectSession?) {
        guard status == LiveAuthConnected else {
            handler?(.failure(APIError.unknown))
            return
        }
        accessToken = session?.accessToken
        client.getWithPath("me", delegate: self)
    }
    
    fileprivate func processUserInfo(json: [AnyHashable: Any]) {
        guard let user = makeUser(from: json) else {
            handler?(.failure(APIError.missingUserData))
            return
        }
        
        handler?(.success(user))
    }
    
    fileprivate func makeUser(from json: [AnyHashable: Any]) -> SocialUser? {
        guard let uid = json["id"] as? String,
            let accessToken = accessToken else {
                return nil
        }
        
        let emails = json["emails"] as? [String: Any]
        let credentials = CredentialsList(provider: .microsoft, accessToken: accessToken, socialUID: uid)
        return SocialUser(uid: uid,
                          credentials: credentials,
                          firstName: json["first_name"] as? String,
                          lastName: json["last_name"] as? String,
                          email: emails?["preferred"] as? String,
                          photo: nil)
    }
}

extension MicrosoftLiveAPI: LiveAuthDelegate {
    func authCompleted(_ status: LiveConnectSessionStatus, session: LiveConnectSession!, userState: Any!) {
        guard let rawValue = userState as? String,
            UserState(rawValue: rawValue) == .login else {
                return
        }
        processAuthCompleted(with: status, session: session)
    }
    
    func authFailed(_ error: Error!, userState: Any!) {
        handler?(.failure(error))
    }
}

extension MicrosoftLiveAPI: LiveOperationDelegate {
    func liveOperationSucceeded(_ operation: LiveOperation!) {
        guard operation != nil, operation.path == "me", operation.result != nil else {
            handler?(.failure(APIError.unknown))
            return
        }
        processUserInfo(json: operation.result)
    }
    
    func liveOperationFailed(_ error: Error!, operation: LiveOperation!) {
        handler?(.failure(error ?? APIError.unknown))
    }
}
