//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

protocol UserServiceType {
    func getMyProfile(credentials: CredentialsList, completion: @escaping (Result<User>) -> Void)
    
    func getUserProfile(userID: String, completion: @escaping (Result<User>) -> Void)
    
    func createAccount(for user: User, completion: @escaping (Result<(user: User, sessionToken: String)>) -> Void)
    
    func updateProfile(me: User, completion: @escaping (Result<User>) -> Void)
}

class UserService: BaseService, UserServiceType {
    
    private let imagesService: ImagesServiceType
    
    init(imagesService: ImagesServiceType) {
        self.imagesService = imagesService
    }
    
    func getMyProfile(credentials: CredentialsList, completion: @escaping (Result<User>) -> Void) {
        UsersAPI.usersGetMyProfile(authorization: credentials.authorization) { profile, error in
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

    private func createAccount(for user: User,
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
        var error: Error?
        let group = DispatchGroup()
        
        if let photo = me.photo, photo.image != nil {
            group.enter()
            imagesService.updateUserPhoto(photo) { result in
                me.photo = result.value ?? me.photo
                error = result.error ?? error
                group.leave()
            }
        }
        
        let request = PutUserInfoRequest()
        request.firstName = me.firstName
        request.lastName = me.lastName
        request.bio = me.bio
        
        group.enter()
        UsersAPI.usersPutUserInfo(request: request, authorization: authorization) { response, responseError in
            error = responseError ?? error
            group.leave()
        }
        
        group.notify(queue: .main) { [weak self] in
            if error == nil {
                completion(.success(me))
            } else {
                self?.errorHandler.handle(error: error, completion: completion)
            }
        }
    }
}
