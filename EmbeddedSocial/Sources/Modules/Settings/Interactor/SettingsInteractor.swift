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
    
    func switchVisibility(_ visibility: Visibility, completion: @escaping (Result<Visibility>) -> Void) {
        let switchedVisibility = visibility.switched
        userService.updateVisibility(to: switchedVisibility) { result in
            let transformedResult = result.map { _ in switchedVisibility }
            completion(transformedResult)
        }
    }
}
