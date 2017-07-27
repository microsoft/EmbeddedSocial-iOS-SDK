//
//  FollowStatus.swift
//  MSGP
//
//  Created by Vadim Bulavin on 7/26/17.
//  Copyright © 2017 Akvelon. All rights reserved.
//

import UIKit

enum FollowStatus: Int {
    case empty
    case accepted
    case pending
    case blocked
    
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
    
    var buttonStyle: UIButton.Style? {
        switch self {
        case .empty: return .follow
        case .accepted: return .following
        case .pending: return .pending
        case .blocked: return .blocked
        }
    }
    
    static func reduce(status: FollowStatus) -> FollowStatus {
        switch status {
        case .empty:
            return .pending
        case .accepted:
            return .empty
        case .blocked:
            return .empty
        case .pending:
            return .empty
        }
    }
}
