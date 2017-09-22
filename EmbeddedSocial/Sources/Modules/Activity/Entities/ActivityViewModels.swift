//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

protocol ActivityItemViewModel {
    var cellID: String { get set }
    var cellClass: UITableViewCell.Type { get set }
}

protocol ActivityItemCellConfigurable {
    func configure(with viewModel: ActivityItemViewModel)
}

struct PendingRequestViewModel: ActivityItemViewModel {
    
    var cellID: String
    var cellClass: UITableViewCell.Type
    
    let profileImage: UIImage
    let profileName: String
}

struct ActivityViewModel: ActivityItemViewModel {
    
    var cellID: String
    var cellClass: UITableViewCell.Type
    
    let profileImage: UIImage
    let postText: String
    let postTime: String
    let postImage: UIImage
}

class ActivityItemViewModelBuilder {
    static func build(from item: ActivityItem) -> ActivityItemViewModel {
        
        switch item {
        case let .pendingRequest(model):
            return RequestItemViewModelBuilder.build(from: model)
            
        case let .following(model):
            return FollowerItemRequestViewModelBuilder.build(from: model)
            
        case let .follower(model):
            return FollowingItemRequestViewModelBuilder.build(from: model)
        }
        
    }
}

class RequestItemViewModelBuilder {
    static func build(from model: UserCompactView) -> ActivityItemViewModel {
        let cellID = FollowRequestCell.reuseID
        let cellClass = FollowRequestCell.self
        let profileImage = Asset.placeholderPostUser1.image
        let profileName = String(format: "%@ %@", model.firstName ?? "", model.lastName ?? "")
        
        return PendingRequestViewModel(cellID: cellID,
                                       cellClass: cellClass,
                                       profileImage: profileImage,
                                       profileName: profileName)
    }
}

class FollowerItemRequestViewModelBuilder {
    static func build(from model: ActivityView) -> ActivityItemViewModel {
        let cellID = ActivityCell.reuseID
        let cellClass = ActivityCell.self
        let profileImage = Asset.userPhotoPlaceholder.image
        let postImage = Asset.placeholderPostImage2.image
        var postText = ""
        
        //        postText =
        var timeAgoText = model.createdTimeAgo() ??  ""
        
        
        return ActivityViewModel(cellID: cellID,
                                 cellClass: cellClass,
                                 profileImage: profileImage,
                                 postText: postText,
                                 postTime: timeAgoText,
                                 postImage: postImage)
    }
}

class FollowingItemRequestViewModelBuilder {
    static func build(from model: ActivityView) -> ActivityItemViewModel {
        let cellID = ActivityCell.reuseID
        let cellClass = ActivityCell.self
        let profileImage = Asset.userPhotoPlaceholder.image
        let postImage = Asset.placeholderPostImage2.image
        var postText = ""
        
        var timeAgoText = model.createdTimeAgo() ?? ""
        
        return ActivityViewModel(cellID: cellID,
                                 cellClass: cellClass,
                                 profileImage: profileImage,
                                 postText: postText,
                                 postTime: timeAgoText,
                                 postImage: postImage)
    }
}
