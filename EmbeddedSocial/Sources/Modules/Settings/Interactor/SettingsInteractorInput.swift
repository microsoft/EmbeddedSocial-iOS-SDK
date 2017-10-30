//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

protocol SettingsInteractorInput: class {
    func switchVisibility(_ visibility: Visibility, completion: @escaping (Result<Visibility>) -> Void)
    
    func signOut()
    
    func deleteAccount(completion: @escaping (Result<Void>) -> Void)
}
