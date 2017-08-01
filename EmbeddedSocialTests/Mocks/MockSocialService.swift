//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

@testable import EmbeddedSocial

final class MockSocialService: SocialServiceType {
    private(set) var followCount = 0
    private(set) var unfollowCount = 0
    private(set) var cancelPendingCount = 0
    private(set) var unblockCount = 0
    private(set) var blockCount = 0

    func follow(userID: String, completion: @escaping (Result<Void>) -> Void) {
        followCount += 1
    }
    
    func unfollow(userID: String, completion: @escaping (Result<Void>) -> Void) {
        unfollowCount += 1
    }
    
    func cancelPending(userID: String, completion: @escaping (Result<Void>) -> Void) {
        cancelPendingCount += 1
    }
    
    func unblock(userID: String, completion: @escaping (Result<Void>) -> Void) {
        unblockCount += 1
    }
    
    func block(userID: String, completion: @escaping (Result<Void>) -> Void) {
        blockCount += 1
    }
}
