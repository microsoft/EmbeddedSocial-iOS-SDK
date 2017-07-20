//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

protocol LoginModuleOutput: class {
    func onSessionCreated(user: User, sessionToken: String)
}
