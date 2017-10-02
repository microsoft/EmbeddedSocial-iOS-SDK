//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

protocol UserServiceType {
    func getMyProfile(authorization: Authorization, credentials: CredentialsList, completion: @escaping (Result<User>) -> Void)
    
    func getUserProfile(userID: String, completion: @escaping (Result<User>) -> Void)
    
    func createAccount(for user: User, completion: @escaping (Result<(user: User, sessionToken: String)>) -> Void)
    
    func createAccount(for user: User,
                       photoHandle: String?,
                       completion: @escaping (Result<(user: User, sessionToken: String)>) -> Void)
    
    func updateProfile(me: User, completion: @escaping (Result<User>) -> Void)
    
    func updateVisibility(to visibility: Visibility, completion: @escaping (Result<Void>) -> Void)
    
    func getLinkedAccounts(completion: @escaping (Result<[LinkedAccountView]>) -> Void)
    
    func linkAccount(authorization: Authorization, sessionToken: String, completion: @escaping (Result<Void>) -> Void)
    
    func deleteLinkedAccount(for provider: AuthProvider, completion: @escaping (Result<Void>) -> Void)
}

class UserService: BaseService, UserServiceType {
    
    private let imagesService: ImagesServiceType
    
    init(imagesService: ImagesServiceType) {
        self.imagesService = imagesService
    }
    
    func getMyProfile(authorization: Authorization, credentials: CredentialsList, completion: @escaping (Result<User>) -> Void) {
        UsersAPI.usersGetMyProfile(authorization: authorization) { profile, error in
            if let profile = profile {
                let user = User(profileView: profile, credentials: credentials)
                completion(.success(user))
            } else {
                self.errorHandler.handle(error: error, completion: completion)
            }
        }
    }
    
    func createAccount(for user: User, completion: @escaping (Result<(user: User, sessionToken: String)>) -> Void) {
        guard let credentials = user.credentials else {
            completion(.failure(APIError.missingCredentials))
            return
        }
        
        guard let image = user.photo?.image else {
            createAccount(for: user, photoHandle: nil, completion: completion)
            return
        }
        
        imagesService.uploadUserImage(image, authorization: credentials.authorization) { [weak self] result in
            if let photoHandle = result.value {
                self?.createAccount(for: user, photoHandle: photoHandle, completion: completion)
            } else {
                self?.errorHandler.handle(error: result.error, completion: completion)
            }
        }
    }

    func createAccount(for user: User,
                       photoHandle: String?,
                       completion: @escaping (Result<(user: User, sessionToken: String)>) -> Void) {
        
        guard let credentials = user.credentials else {
            completion(.failure(APIError.missingCredentials))
            return
        }
        
        let params = PostUserRequest()
        params.instanceId = user.uid
        params.firstName = user.firstName
        params.lastName = user.lastName
        params.bio = user.bio
        params.photoHandle = photoHandle

        UsersAPI.usersPostUser(request: params, authorization: credentials.authorization) { response, error in
            if let response = response, let userHandle = response.userHandle, let sessionToken = response.sessionToken {
                var user = user
                user.uid = userHandle
                completion(.success((user, sessionToken)))
            } else {
                self.errorHandler.handle(error: error, completion: completion)
            }
        }
    }
    
    func getUserProfile(userID: String, completion: @escaping (Result<User>) -> Void) {
        UsersAPI.usersGetUser(userHandle: userID, authorization: authorization) { profile, error in
            if let profile = profile {
                let user = User(profileView: profile)
                self.cache.cacheIncoming(profile)
                completion(.success(user))
            } else {
                self.errorHandler.handle(error: error, completion: completion)
            }
        }
    }
    
    func updateProfile(me: User, completion: @escaping (Result<User>) -> Void) {
        var me = me
        
        updateUserPhoto(me.photo) { [weak self] result in
            guard result.isSuccess else {
                self?.errorHandler.handle(error: result.error, completion: completion)
                return
            }
            me.photo = result.value ?? me.photo
            
            self?.updateUserInfo(me) { result in
                guard result.isSuccess else {
                    self?.errorHandler.handle(error: result.error, completion: completion)
                    return
                }
                completion(.success(me))
            }
        }
    }
    
    func updateUserPhoto(_ photo: Photo?, completion: @escaping (Result<Photo>) -> Void) {
        if let photo = photo, photo.image != nil {
            imagesService.updateUserPhoto(photo, completion: completion)
        } else {
            imagesService.deleteUserPhoto(authorization: authorization) {
                let result = $0.map { _ in Photo() }
                completion(result)
            }
        }
    }
    
    private func updateUserInfo(_ user: User, completion: @escaping (Result<Void>) -> Void) {
        let request = PutUserInfoRequest()
        request.firstName = user.firstName
        request.lastName = user.lastName
        request.bio = user.bio
        
        UsersAPI.usersPutUserInfo(request: request, authorization: authorization) { response, error in
            self.processResult(response, error, completion)
        }
    }
    
    func updateVisibility(to visibility: Visibility, completion: @escaping (Result<Void>) -> Void) {
        let request = PutUserVisibilityRequest()
        request.visibility = PutUserVisibilityRequest.Visibility(rawValue: visibility.rawValue)
        UsersAPI.usersPutUserVisibility(request: request, authorization: authorization) { response, error in
            self.processResult(response, error, completion)
        }
    }
    
    private func processResult(_ data: Object?, _ error: ErrorResponse?, _ completion: @escaping (Result<Void>) -> Void) {
        DispatchQueue.main.async {
            if error == nil {
                completion(.success())
            } else {
                self.errorHandler.handle(error: error, completion: completion)
            }
        }
    }
    
    func getLinkedAccounts(completion: @escaping (Result<[LinkedAccountView]>) -> Void) {
        UsersAPI.myLinkedAccountsGetLinkedAccounts(authorization: authorization) { accounts, error in
            if let accounts = accounts {
                completion(.success(accounts))
            } else if let error = error, case let ErrorResponse.DecodeError(data, _) = error, data != nil {
                let intermediateJson = try? JSONSerialization.jsonObject(with: data!, options: [])
                let json = intermediateJson as? [[String: Any]]
                let accounts = json?.map(LinkedAccountView.init) ?? []
                DispatchQueue.main.async {
                    completion(.success(accounts))
                }
            } else {
                self.errorHandler.handle(error: error, completion: completion)
            }
        }
    }
    
    func linkAccount(authorization: Authorization, sessionToken: String, completion: @escaping (Result<Void>) -> Void) {
        let request = PostLinkedAccountRequest()
        request.sessionToken = sessionToken
        
        UsersAPI.myLinkedAccountsPostLinkedAccount(request: request, authorization: authorization) { response, error in
            self.processResult(response, error, completion)
        }
    }
    
    func deleteLinkedAccount(for provider: AuthProvider, completion: @escaping (Result<Void>) -> Void) {
        UsersAPI.myLinkedAccountsDeleteLinkedAccount(
            identityProvider: provider.usersAPIIdentityProvider,
            authorization: authorization) { response, error in
                self.processResult(response, error, completion)
        }
    }
}
