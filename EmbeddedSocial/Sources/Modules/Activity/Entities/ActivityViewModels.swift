//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

protocol ActivityItemViewModel {
    var cellID: String { get set }
    var cellClass: UITableViewCell.Type { get set }
}

struct PendingRequestViewModel: ActivityItemViewModel {
    var cellID: String
    var cellClass: UITableViewCell.Type
    
    let profileImagePlaceholder = AppConfiguration.shared.theme.assets.userPhotoPlaceholder
    let profileImage: String?
    let profileName: String?
}

struct ActivityViewModel: ActivityItemViewModel {
    var cellID: String
    var cellClass: UITableViewCell.Type
    
    let iconImage: Asset?
    let profileImagePlaceholder = AppConfiguration.shared.theme.assets.userPhotoPlaceholder
    let profileImage: String?
    let postImagePlaceholder: Asset?
    let postText: String
    let postTime: String
    let postImage: String?
}

class ActivityItemViewModelBuilder {
    
    static func build(from item: ActivityItem) -> ActivityItemViewModel {
        switch item {
        case let .pendingRequest(model):
            return RequestItemViewModelBuilder.build(from: model)
            
        case let .myActivity(model):
            return MyActivityItemViewModelBuilder.build(from: model)
            
        case let .othersActivity(model):
            return OthersActivityItemViewModelBuilder.build(from: model)
        }
    }
    
    static func assetForActivity(_ model: ActivityView) -> Asset? {
        var result: Asset?
        if let activityType = model.activityType {
            switch activityType {
            case .comment:
                result = Asset.esDecorComment
            case .following:
                result = Asset.esDecorFollow
            case .like:
                result = Asset.esDecorLike
            default:
                result = nil
            }
        }
        return result
    }
}

class RequestItemViewModelBuilder {
    static func build(from model: User) -> ActivityItemViewModel {
        let cellID = FollowRequestCell.reuseID
        let cellClass = FollowRequestCell.self
        let profileImage = model.photo?.getHandle()
        let profileName = model.fullName
        
        return PendingRequestViewModel(cellID: cellID,
                                       cellClass: cellClass,
                                       profileImage: profileImage,
                                       profileName: profileName)
    }
}


class MyActivityItemViewModelBuilder {
    static func build(from model: ActivityView) -> ActivityItemViewModel {
        let cellID = ActivityCell.reuseID
        let cellClass = ActivityCell.self
        let profileImage = model.actorUsers?.first?.photoUrl
        let postImage = model.actedOnContent?.blobUrl
        let postImagePlaceholder: Asset? = (model.actedOnContent?.contentType == .topic) ? Asset.placeholderPostNoimage : nil
        let postText = ActivityTextRender.shared.renderMyActivity(model: model) ?? ""
        let timeAgoText = model.createdTimeAgo() ??  ""
        
        let activityIcon = ActivityItemViewModelBuilder.assetForActivity(model)
        
        return ActivityViewModel(cellID: cellID,
                                 cellClass: cellClass,
                                 iconImage: activityIcon,
                                 profileImage: profileImage,
                                 postImagePlaceholder: postImagePlaceholder,
                                 postText: postText,
                                 postTime: timeAgoText,
                                 postImage: postImage)
    }
}

class OthersActivityItemViewModelBuilder {
    static func build(from model: ActivityView) -> ActivityItemViewModel {
        let cellID = ActivityCell.reuseID
        let cellClass = ActivityCell.self
        let profileImage = model.actorUsers?.first?.photoUrl
        let postImage = model.actedOnContent?.blobUrl
        let postImagePlaceholder: Asset? = (model.actedOnContent?.contentType == .topic) ? Asset.placeholderPostNoimage : nil
        let postText = ActivityTextRender.shared.renderOthersActivity(model: model) ?? ""
        let timeAgoText = model.createdTimeAgo() ?? ""
        let activityIcon = ActivityItemViewModelBuilder.assetForActivity(model)
        
        return ActivityViewModel(cellID: cellID,
                                 cellClass: cellClass,
                                 iconImage: activityIcon,
                                 profileImage: profileImage,
                                 postImagePlaceholder: postImagePlaceholder,
                                 postText: postText,
                                 postTime: timeAgoText,
                                 postImage: postImage)
    }
}
