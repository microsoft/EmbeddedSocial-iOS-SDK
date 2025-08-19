//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import UIKit

struct Constants {
    static let standardCellHeight: CGFloat = 44.0
    static let oauth1URLScheme = "embeddedsocial"
    static let imageCompressionQuality: CGFloat = 0.8
    static let deviceTokenStorageKey = "com.deviceToken"
    static let configurationFilename = "config"
}

extension Constants {
    
    struct Menu {
        static let defaultItemColor = Palette.white
        static let selectedItemColor = Palette.green
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
            static let rowsMargin = CGFloat(10.0)
            static let itemsPerRow = CGFloat(2)
            static let gridCellsPadding = CGFloat(5)
            static let footerHeight = CGFloat(60)
            static let containerPadding = CGFloat(10)
            static let containerColor = UIColor.white
            static let imageHeight = CGFloat(180)
            static let imageRatio = CGFloat(1.0 / 3.0)
            
            struct Cell {
                static let trimmedMaxLines = 10
                static let maxLines = 100
            }
        }
    }
    
    struct UserProfile {
        static let containerInset: CGFloat = 10.0
        static let filterHeight: CGFloat = 44.0
        static let contentWidth = UIScreen.main.bounds.width - containerInset * 2
        static let summaryHeight: CGFloat = 160.0
        static let recentSegment = 0
        static let popularSegment = 1
        static let lockVerticalOffset: CGFloat = 80.0
    }
    
    struct Feed {
        static let pageSize = 10
        static let searchPageSize = 10
        
        struct Popular {
            static let initialFeedScope = FeedType.TimeRange.alltime
        }
    }
    
    struct FollowRequests {
        static let pageSize = 30
    }
    
    struct Settings {
        static let privacyPolicyURL = URL(string: "http://go.microsoft.com/fwlink/?LinkId=521839")
        
        static let termsAndConditionsURL = URL(string: "http://go.microsoft.com/fwlink/?LinkID=206977")
    }
    
    struct Search {
        static let historyMaxHeight: CGFloat = 300
    }
    
    struct ImageResize {
/*
 - d is 25 pixels wide
 - h is 50 pixels wide
 - l is 100 pixels wide
 - p is 250 pixels wide
 - t is 500 pixels wide
 - x is 1000 pixels wide
 
 - ImageType.UserPhoto supports d,h,l,p,t,x
 - ImageType.ContentBlob supports d,h,l,p,t,x
 - ImageType.AppIcon supports l
 
 All resized images will maintain their aspect ratio. Any orientation specified in the EXIF headers will be honored.
*/
        static let pixels25 = "d"
        static let pixels50 = "h"
        static let pixels100 = "l"
        static let pixels250 = "p"
        static let pixels500 = "t"
        static let pixels1000 = "x"
    }
    
    struct Notifications {
        static let pollInterval = TimeInterval(60 * 15)
    }
    
}

extension Constants {
 
    struct API {
        static let unauthorizedStatusCode = 401
        static func authorization(_ sessionToken: String) -> Authorization { return "SocialPlus TK=\(sessionToken)" }
    }
    
    enum HTTPStatusCodes: Int {
        // 100 Informational
        case Continue = 100
        case SwitchingProtocols
        case Processing
        // 200 Success
        case OK = 200
        case Created
        case Accepted
        case NonAuthoritativeInformation
        case NoContent
        case ResetContent
        case PartialContent
        case MultiStatus
        case AlreadyReported
        case IMUsed = 226
        // 300 Redirection
        case MultipleChoices = 300
        case MovedPermanently
        case Found
        case SeeOther
        case NotModified
        case UseProxy
        case SwitchProxy
        case TemporaryRedirect
        case PermanentRedirect
        // 400 Client Error
        case BadRequest = 400
        case Unauthorized
        case PaymentRequired
        case Forbidden
        case NotFound
        case MethodNotAllowed
        case NotAcceptable
        case ProxyAuthenticationRequired
        case RequestTimeout
        case Conflict
        case Gone
        case LengthRequired
        case PreconditionFailed
        case PayloadTooLarge
        case URITooLong
        case UnsupportedMediaType
        case RangeNotSatisfiable
        case ExpectationFailed
        case ImATeapot
        case MisdirectedRequest = 421
        case UnprocessableEntity
        case Locked
        case FailedDependency
        case UpgradeRequired = 426
        case PreconditionRequired = 428
        case TooManyRequests
        case RequestHeaderFieldsTooLarge = 431
        case UnavailableForLegalReasons = 451
        // 500 Server Error
        case InternalServerError = 500
        case NotImplemented
        case BadGateway
        case ServiceUnavailable
        case GatewayTimeout
        case HTTPVersionNotSupported
        case VariantAlsoNegotiates
        case InsufficientStorage
        case LoopDetected
        case NotExtended = 510
        case NetworkAuthenticationRequired
    }
}
