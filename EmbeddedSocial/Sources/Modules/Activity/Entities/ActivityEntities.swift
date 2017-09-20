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

struct SectionHeader {
    var name: String
    var identifier: String?
}

// MARK: Model

enum ActivityItem {
    case pendingRequest(PendingRequestItem)
    case follower(ActionItem)
    case following(ActionItem)
}

// MARK: Models

struct ActionItem {
    
    enum ActivityType: String {
        case like = "Like"
        case comment = "Comment"
        case reply = "Reply"
        case commentPeer = "CommentPeer"
        case replyPeer = "ReplyPeer"
        case following = "Following"
        case followRequest = "FollowRequest"
        case followAccept = "FollowAccept"
    }
    
    var postDate: Date
    var profileImageURL: String?
    var contentImageURL: String?
    var unread: Bool
    var type: ActivityType
    var actorNameList: [(firstName: String, lastName: String)] = []
    var actedOnName: String
}

extension ActionItem {
    static func mock(seed: Int) -> ActionItem {
        let model = ActionItem(postDate: Date(),
                               profileImageURL: "image \(seed)",
            contentImageURL: "content \(seed)",
            unread: seed % 2 == 0,
            type: .like,
            actorNameList: [ ("Alice \(seed)", "Bob \(seed)") ],
            actedOnName: "User \(seed)")
        
        return model
    }
}


struct PendingRequestItem {
    var userName: String
    var userHandle: String
}

extension PendingRequestItem {
    static func mock(seed: Int) -> PendingRequestItem {
        return PendingRequestItem(userName: "username \(seed)", userHandle: "handle \(seed)")
    }
}

// Helpers

enum Change<T> {
    case Insertion(items: [T])
    case Deletion(items: [T])
    case Update(items: [T])
}

class ActivityViewModelBuilder {
    
    let cellTypes = ["UITableViewCell": UITableViewCell.self]
    
    private var dateFormatter: DateFormatter = {
        
        let formatter = DateFormatter()
        return formatter
        
    }()
    
    private func build(with model: PendingRequestItem) -> PendingRequestViewModel {
        
        let cellID = ""
        let cellClass = UITableViewCell.self
        let profileImage = UIImage()
        let profileName = model.userName
        
        return PendingRequestViewModel(cellID: cellID,
                                       cellClass: cellClass,
                                       profileImage: profileImage,
                                       profileName: profileName)
    }
    
    private func build(with model: ActionItem) -> ActivityItemViewModel {
        
        let cellID = ""
        let cellClass = UITableViewCell.self
        let profileImage = UIImage()
        let postImage = UIImage()
        var postText = ""
        
        for (index, person) in model.actorNameList.enumerated() {
            let delimeter = (index < (model.actorNameList.count - 1)) ? "," : ""
            postText += "\(person.firstName) + \(person.lastName)" + delimeter
        }
        
        let postDate = model.postDate
        let timeAgoText = dateFormatter.string(from: postDate)
        
        
        return ActivityViewModel(cellID: cellID,
                                 cellClass: cellClass,
                                 profileImage: profileImage,
                                 postText: postText,
                                 postTime: timeAgoText,
                                 postImage: postImage)
    }
    
    func build(from item: ActivityItem) -> ActivityItemViewModel {
        
        switch item {
        case let .pendingRequest(model):
            return build(with: model)
            
        case let .following(model):
            return build(with: model)
            
        default:
            fatalError()
        }
    }
    
}

class SectionsConfigurator {
    
    func build(section: ActivityPresenter.State) -> [Section] {
        
        switch section {
        case .my:
            return my
        case .others:
            return others
        }
        
    }
    
    private var my: [Section] {
        let sectionHeader = SectionHeader(name: "Section 1", identifier: "")
        let model = PendingRequestItem(userName: "User", userHandle: "User handle")
        let item = ActivityItem.pendingRequest(model)
        let section = Section(model: sectionHeader, items: [item])
        return [section]
    }
    
    private var others: [Section] {
        let sectionHeader = SectionHeader(name: "Section 2", identifier: "")
        let model = ActionItem.mock(seed: 0)
        let item = ActivityItem.follower(model)
        let section = Section(model: sectionHeader, items: [item])
        return [section]
    }
    
}

class CellConfigurator {
    
    func configure(cell: UITableViewCell, with viewModel: ActivityItemViewModel) {
        
        cell.selectionStyle = .none
        
        if let cell = cell as? ActivityCell, let viewModel = viewModel as? ActivityViewModel {
            configure(cell: cell, with: viewModel)
        }
        else if let cell = cell as? FollowRequestCell, let viewModel = viewModel as? PendingRequestViewModel  {
            configure(cell: cell, with: viewModel)
        }
        
    }
    
    private func configure(cell: ActivityCell, with viewModel: ActivityViewModel) {
        cell.profileImage.image = viewModel.profileImage
        cell.postImage.image = viewModel.postImage
        
        let postTextAttributed = NSAttributedString(string: viewModel.postText,
                                                    attributes: ActivityBaseCell.Style.Fonts.Attributes.normal)
        let postTimeAttributed = NSAttributedString(string: viewModel.postTime,
                                                    attributes: ActivityBaseCell.Style.Fonts.Attributes.time)
        
        let textAttributed = NSMutableAttributedString()
        textAttributed.append(postTextAttributed)
        textAttributed.append(NSAttributedString(string: " "))
        textAttributed.append(postTimeAttributed)
        
        cell.postText.attributedText = textAttributed
    }
    
    private func configure(cell: FollowRequestCell, with viewModel: PendingRequestViewModel) {
        cell.profileImage.image = viewModel.profileImage
        cell.profileName.text = viewModel.profileName
    }
    
}

struct ActivityFetchResult<T> {
    var items: [T] = []
    var cursor: String?
}

extension PageModel: Hashable {
    
    var hashValue: Int {
        return uid.hashValue
    }
    
    static func ==(lhs: PageModel<T>, rhs: PageModel<T>) -> Bool {
        return lhs.uid == rhs.uid
    }
    
}

enum ActivityError: Int, Error {
    case notParsable
    case noData
    case mapperNotFound
    case loaderNotFound
}


