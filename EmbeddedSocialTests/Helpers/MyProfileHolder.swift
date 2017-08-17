//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

@testable import EmbeddedSocial

class MyProfileHolder: UserHolder {
    var setMeCount = 0
    
    var me = User(uid: UUID().uuidString) {
        didSet {
            setMeCount += 1
        }
    }
}
