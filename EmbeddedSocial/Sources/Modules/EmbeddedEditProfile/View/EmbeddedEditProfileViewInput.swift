//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

protocol EmbeddedEditProfileViewInput: class {
    func setupInitialState(with user: User)
    
    func setUser(_ user: User)

    func setIsLoading(_ isLoading: Bool)
}
