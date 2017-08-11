//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

@testable import EmbeddedSocial

final class MockCreateAccountInteractor: CreateAccountInteractorInput {
    private(set) var createAccountCount = 0
    private(set) var lastSocialUser: SocialUser?
    
    private(set) var updatedPhotoWithImageFromCacheCount = 0
    private(set) var updatedPhoto: Photo?
    var updatePhotoToReturn = Photo()
    
    private(set) var cachedPhoto: Photo?
    private(set) var cachePhotoCount = 0
    
    var resultMaker: (SocialUser) -> Result<(user: User, sessionToken: String)> = {
        return .success(User(socialUser: $0, userHandle: ""), "")
    }
    
    func createAccount(for user: SocialUser, completion: @escaping (Result<(user: User, sessionToken: String)>) -> Void) {
        createAccountCount += 1
        lastSocialUser = user
        completion(resultMaker(user))
    }
    
    func updatedPhotoWithImageFromCache(_ photo: Photo?) -> Photo {
        updatedPhotoWithImageFromCacheCount += 1
        updatedPhoto = photo
        return updatePhotoToReturn
    }
    
    func cachePhoto(_ photo: Photo) {
        cachePhotoCount += 1
        cachedPhoto = photo
    }
}
