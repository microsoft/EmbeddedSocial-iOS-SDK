//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

@testable import EmbeddedSocial

class UserHolderMock: UserHolder {
    var me: User? = {
        return User()
    }()
}
