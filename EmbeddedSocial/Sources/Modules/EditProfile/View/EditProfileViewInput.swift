//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

protocol EditProfileViewInput: class {
    func setupInitialState(with editView: UIView)
        
    func showError(_ error: Error)
    
    func setSaveButtonEnabled(_ isEnabled: Bool)
}
