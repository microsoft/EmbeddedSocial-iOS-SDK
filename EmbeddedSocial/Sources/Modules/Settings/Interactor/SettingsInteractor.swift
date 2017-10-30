//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

final class SettingsInteractor: SettingsInteractorInput {

    private let userService: UserServiceType
    private let logoutController: LogoutController
    
    init(userService: UserServiceType, logoutController: LogoutController) {
        self.userService = userService
        self.logoutController = logoutController
    }
    
    func signOut() {
        logoutController.logOut()
    }
    
    func switchVisibility(_ visibility: Visibility, completion: @escaping (Result<Visibility>) -> Void) {
        let switchedVisibility = visibility.switched
        userService.updateVisibility(to: switchedVisibility) { result in
            let transformedResult = result.map { _ in switchedVisibility }
            completion(transformedResult)
        }
    }
    
    func deleteAccount(completion: @escaping (Result<Void>) -> Void) {
        userService.deleteAccount { [weak self] result in
            if result.isSuccess {
                self?.logoutController.logOut()
            }
            completion(result)
        }
    }
}
