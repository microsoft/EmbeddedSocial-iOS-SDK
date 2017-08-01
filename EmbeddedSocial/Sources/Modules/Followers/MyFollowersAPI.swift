//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

struct MyFollowersAPI: UsersListAPI {
    private let service: SocialServiceType
    
    init(service: SocialServiceType) {
        self.service = service
    }
    
    func getUsersList(completion: @escaping (Result<[User]>) -> Void) {
        let users = [
            makeDummyUser(),
            makeDummyUser(),
            makeDummyUser(),
            makeDummyUser(),
            makeDummyUser()
        ]
        completion(.success(users))
//        service.getMyFollowers(completion: completion)
    }
    
    private func makeDummyUser() -> User {
        return User(
            uid: UUID().uuidString,
            firstName: "\(UUID().uuidString.components(separatedBy: "-").first!)",
            lastName: "\(UUID().uuidString.components(separatedBy: "-").first!)",
            visibility: ._public
        )
    }
}
