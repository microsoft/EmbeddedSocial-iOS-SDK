//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import UIKit

enum FollowStatus: Int {
    case empty
    case accepted
    case pending
    case blocked
    
    var buttonStyle: UIButton.Style {
        switch self {
        case .empty: return .follow
        case .accepted: return .following
        case .pending: return .pending
        case .blocked: return .blocked
        }
    }
    
    static func reduce(status: FollowStatus, visibility: Visibility) -> FollowStatus {
        switch status {
        case .empty:
            return  visibility == ._public ? .accepted : .pending
        case .accepted:
            return .empty
        case .blocked:
            return .empty
        case .pending:
            return .empty
        }
    }
}

extension FollowStatus {
    init(status: UserProfileView.FollowerStatus?) {
        guard let status = status else {
            self = .empty
            return
        }
        
        switch status {
        case ._none:
            self = .empty
        case .follow:
            self = .accepted
        case .pending:
            self = .pending
        case .blocked:
            self = .blocked
        }
    }
    
    init(status: UserProfileView.FollowingStatus?) {
        guard let status = status else {
            self = .empty
            return
        }
        
        switch status {
        case ._none:
            self = .empty
        case .follow:
            self = .accepted
        case .pending:
            self = .pending
        case .blocked:
            self = .blocked
        }
    }
    
    init(status: UserCompactView.FollowerStatus?) {
        guard let status = status else {
            self = .empty
            return
        }
        
        switch status {
        case ._none:
            self = .empty
        case .follow:
            self = .accepted
        case .pending:
            self = .pending
        case .blocked:
            self = .blocked
        }
    }
}
