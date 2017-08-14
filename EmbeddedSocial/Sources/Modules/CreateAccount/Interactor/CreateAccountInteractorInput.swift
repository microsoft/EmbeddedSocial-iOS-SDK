//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

protocol CreateAccountInteractorInput {
    func updatedPhotoWithImageFromCache(_ photo: Photo?) -> Photo
    
    func cachePhoto(_ photo: Photo)
    
    func createAccount(for user: SocialUser, completion: @escaping (Result<(user: User, sessionToken: String)>) -> Void)
}
