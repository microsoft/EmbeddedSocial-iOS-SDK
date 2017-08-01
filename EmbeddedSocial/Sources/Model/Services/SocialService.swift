//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

protocol SocialServiceType {
    func follow(userID: String, completion: @escaping (Result<Void>) -> Void)
    
    func unfollow(userID: String, completion: @escaping (Result<Void>) -> Void)
    
    func cancelPending(userID: String, completion: @escaping (Result<Void>) -> Void)
    
    func unblock(userID: String, completion: @escaping (Result<Void>) -> Void)
    
    func block(userID: String, completion: @escaping (Result<Void>) -> Void)
}

struct SocialService: SocialServiceType {
    
    func follow(userID: String, completion: @escaping (Result<Void>) -> Void) {
        let request = PostFollowingUserRequest()
        request.userHandle = userID
        
        SocialAPI.myFollowingPostFollowingUser(request: request) { data, error in
            self.processResponse(data, error, completion)
        }
    }
    
    func unfollow(userID: String, completion: @escaping (Result<Void>) -> Void) {
        SocialAPI.myFollowingDeleteFollowingUser(userHandle: userID) { data, error in
            self.processResponse(data, error, completion)
        }
    }
    
    func cancelPending(userID: String, completion: @escaping (Result<Void>) -> Void) {
        completion(.success())
    }
    
    func unblock(userID: String, completion: @escaping (Result<Void>) -> Void) {
        completion(.success())
    }
    
    func block(userID: String, completion: @escaping (Result<Void>) -> Void) {
        let request = PostBlockedUserRequest()
        request.userHandle = userID
        
        SocialAPI.myBlockedUsersPostBlockedUser(request: request) { data, error in
            self.processResponse(data, error, completion)
        }
    }
    
    private func processResponse(_ data: Object?,_ error: Error?, _ completion: @escaping (Result<Void>) -> Void) {
        if error == nil {
            completion(.success())
        } else {
            completion(.failure(APIError(error: error as? ErrorResponse)))
        }
    }
}
