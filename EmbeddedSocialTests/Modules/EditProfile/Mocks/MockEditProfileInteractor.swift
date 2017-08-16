//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

@testable import EmbeddedSocial

final class MockEditProfileInteractor: EditProfileInteractorInput {
    private(set) var editProfileCount = 0
    private(set) var cachePhotoCount = 0
    private(set) var cachedPhoto: Photo?
    
    var editResult: Result<User>?
    
    func editProfile(me: User, completion: @escaping (Result<User>) -> Void) {
        editProfileCount += 1
        if let result = editResult {
            completion(result)
        }
    }
    
    func cachePhoto(_ photo: Photo) {
        cachedPhoto = photo
        cachePhotoCount += 1
    }
}
