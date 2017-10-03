//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

protocol LoginViewInput: class {
    func setupInitialState()
    
    func showError(_ error: Error)
    
    func setIsLoading(_ isLoading: Bool)
    
    func addLeftNavigationCancelButton()
}
