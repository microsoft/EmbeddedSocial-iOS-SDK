//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import UIKit

struct Constants {
    static let appKey = "ec1665a4-920d-4449-b8a0-49ed374d4290"
    static let standardCellHeight: CGFloat = 44.0
    static let oauth1URLScheme = "embeddedsocial"
    static let imageCompressionQuality: CGFloat = 0.8
    static let anonymousAuthorization: Authorization = "Anon AK=\(Constants.appKey)"
}

extension Constants {
    
    struct CreateAccount {
        static let contentPadding: CGFloat = 20.0
        static let uploadPhotoHeight: CGFloat = 84.0
        static let maxBioLength = 500
    }
    
    struct UserList {
        static let pageSize = 30
    }
    
    struct UserProfile {
        static let summaryAspectRatio: CGFloat = 2.25
        static let containerInset: CGFloat = 10.0
        static let filterHeight: CGFloat = 44.0
        static let contentWidth = UIScreen.main.bounds.width - containerInset * 2
        static let summaryHeight = contentWidth / summaryAspectRatio
    }
}

extension Constants {
    
    struct Placeholder {
        static let unknown = "Unknown"
        static let notSpecified = "Not specified"
    }
}

extension Constants {
    
    struct API {
        static let unauthorizedStatusCode = 401
    }
}
