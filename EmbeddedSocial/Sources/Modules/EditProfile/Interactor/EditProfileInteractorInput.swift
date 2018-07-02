//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

protocol EditProfileInteractorInput {
    func editProfile(me: User, completion: @escaping (Result<User>) -> Void)
    
    func cachePhoto(_ photo: Photo)
}
