//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

protocol CreatePostViewInput: class {

    /**
        @author generamba setup
        Setup initial state of the view
    */

    func setupInitialState()
    func showError(error: Error)
}
