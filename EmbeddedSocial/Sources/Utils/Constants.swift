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
}

extension Constants {
    
    struct Menu {
        static let defaultItemColor = UIColor.white
        static let selectedItemColor = UIColor(r: 80, g: 173, b: 85)
    }
    
    struct CreateAccount {
        static let contentPadding: CGFloat = 20.0
        static let uploadPhotoHeight: CGFloat = 84.0
        static let maxBioLength = 500
    }
    
    struct EditProfile {
        static let contentPadding: CGFloat = 20.0
        static let uploadPhotoHeight: CGFloat = 84.0
        static let maxBioLength = 500
    }
    
    struct UserList {
        static let pageSize = 30
    }
    
    struct ActivityList {
        static let pageSize = 20
    }
    
    struct FeedModule {
        struct Collection  {
            static var rowsMargin = CGFloat(10.0)
            static var itemsPerRow = CGFloat(2)
            static var gridCellsPadding = CGFloat(5)
            static var footerHeight = CGFloat(60)
            static var containerPadding = CGFloat(10)
            static var containerColor = UIColor.white
            
            struct Cell {
                static var maxLines = 10
            }
        }
    }
    
    struct UserProfile {
        static let summaryAspectRatio: CGFloat = 2.25
        static let containerInset: CGFloat = 10.0
        static let filterHeight: CGFloat = 44.0
        static let contentWidth = UIScreen.main.bounds.width - containerInset * 2
        static let summaryHeight = contentWidth / summaryAspectRatio
        static let recentSegment = 0
        static let popularSegment = 1
    }
    
    struct Feed {
        static let pageSize = 10
        
        struct Popular {
            static let initialFeedScope = FeedType.TimeRange.alltime
        }
    }
    
    struct PostDetails {
        static let pageSize = 5
    }
    
    struct CommentReplies {
        static let pageSize = 5
    }
    
    struct FollowRequests {
        static let pageSize = 30
    }
}

extension Constants {
    
    struct API {
        static let unauthorizedStatusCode = 401
        static let anonymousAuthorization: Authorization = "Anon AK=\(Constants.appKey)"
        static func authorization(_ sessionToken: String) -> Authorization { return "SocialPlus TK=\(sessionToken)" }
    }
}
