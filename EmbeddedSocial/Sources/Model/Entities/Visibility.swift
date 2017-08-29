//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

enum Visibility: String {
    case _public = "Public"
    case _private = "Private"
    
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
    
    var switched: Visibility {
        switch self {
        case ._public:
            return ._private
        case ._private:
            return ._public
        }
    }
}

extension UserProfileView.Visibility {
    
}
