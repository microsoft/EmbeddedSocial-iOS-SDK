//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

final class SettingsInteractor: SettingsInteractorInput {

    private let userService: UserServiceType
    
    init(userService: UserServiceType) {
        self.userService = userService
    }
    
    func signOut(success: @escaping (Void) -> Void, fauilure: @escaping (Error) -> Void) {
        OperationQueue().cancelAllOperations()
        SocialPlus.shared.logOut()
        SocialPlus.shared.coreDataStack.reset { (result) in
            guard let error = result.error else {
                success()
                return
            }
            
            fauilure(error)
        }

    }
    
    func switchVisibility(_ visibility: Visibility, completion: @escaping (Result<Visibility>) -> Void) {
        let switchedVisibility = visibility.switched
        userService.updateVisibility(to: switchedVisibility) { result in
            let transformedResult = result.map { _ in switchedVisibility }
            completion(transformedResult)
        }
    }
}
