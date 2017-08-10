//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

enum Visibility: Int {
    case _public
    case _private
    
    init(visibility: UserProfileView.Visibility) {
        switch visibility {
        case ._public:
            self = ._public
        default:
            self = ._private
        }
    }
    
    init(visibility: UserCompactView.Visibility) {
        switch visibility {
        case ._public:
            self = ._public
        default:
            self = ._private
        }
    }
}
