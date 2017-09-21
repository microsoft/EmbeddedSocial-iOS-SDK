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

enum ActivityContentType: String {
    case topic = "Topic"
    case comment = "Comment"
    case reply = "Reply"
}

struct ActionItem {
    var postDate: Date
    var profileImageURL: String?
    var contentImageURL: String?
    var unread: Bool
    var activityType: ActivityType
    var actorNameList: [(firstName: String, lastName: String)] = []
    var actedOnName: String
    var actedOnContentType: ActivityContentType?
}

extension ActionItem {
    static func mock(seed: Int) -> ActionItem {
        let model = ActionItem(
            postDate: Date(),
            profileImageURL: "image \(seed)",
            contentImageURL: "content \(seed)",
            unread: seed % 2 == 0,
            activityType: .like,
            actorNameList: [ ("Alice \(seed)", "Bob \(seed)") ],
            actedOnName: "User \(seed)",
            actedOnContentType: .topic)
        
        return model
    }
}


struct PendingRequestItem {
    var userName: String
    var lastName: String
    var userHandle: String
}

extension PendingRequestItem {
    static func mock(seed: Int) -> PendingRequestItem {
        return PendingRequestItem(
            userName: "username \(seed)",
            lastName: "lastname \(seed)",
            userHandle: "handle \(seed)")
    }
}

// Helpers

enum Change<T> {
    case Insertion(items: [T])
    case Deletion(items: [T])
    case Update(items: [T])
}

class ActionTextBuilder {
    
   
    
}

class ActivityViewModelBuilder {
    
    let cellTypes = [
        FollowRequestCell.reuseID : FollowRequestCell.self,
        ActivityCell.reuseID: ActivityCell.self
        ]
    
    private var dateFormatter: DateComponentsFormatter = {
        
        let formatter = DateFormatterTool().shortStyle
        return formatter
        
    }()
    
    private func build(with model: PendingRequestItem) -> PendingRequestViewModel {
        
        let cellID = FollowRequestCell.reuseID
        let cellClass = FollowRequestCell.self
        let profileImage = Asset.placeholderPostUser1.image
        let profileName = model.userName + " " + model.lastName
        
        return PendingRequestViewModel(cellID: cellID,
                                       cellClass: cellClass,
                                       profileImage: profileImage,
                                       profileName: profileName)
    }
    
    private func build(with model: ActionItem) -> ActivityItemViewModel {
        
        let cellID = ActivityCell.reuseID
        let cellClass = ActivityCell.self
        let profileImage = Asset.userPhotoPlaceholder.image
        let postImage = Asset.placeholderPostImage2.image
        var postText = ""
        
        // put names
        for (index, person) in model.actorNameList.enumerated() {
            let delimeter = (index < (model.actorNameList.count - 1)) ? "," : ""
            postText += "\(person.firstName) \(person.lastName)" + delimeter
        }
        
        // put actions
        postText += model.activityType.rawValue
        
        let postDate = model.postDate
        let timeAgoText = dateFormatter.string(from: postDate, to: Date()) ?? ""
        
        
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
            
        case let .follower(model):
            return build(with: model)
            
        default:
            fatalError()
        }
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

protocol DataSourceProtocol {
    func loadMore()
    var section: Section { get }
    var delegate: DataSourceDelegate? { get }
    var index: Int { get }
}

protocol DataSourceDelegate {
    func didFail(error: Error)
    func didLoad(indexPaths: [IndexPath])
}

class DataSource: DataSourceProtocol {
    weak var interactor: ActivityInteractorInput!
    var section: Section
    var delegate: DataSourceDelegate?
    var index: Int
    
    func loadMore() { }
    
    init(interactor: ActivityInteractorInput,
         section: Section,
         delegate: DataSourceDelegate? = nil,
         index: Int) {
        
        self.interactor = interactor
        self.section = section
        self.delegate = delegate
        self.index = index
    }
    
    func insertedIndexes(newItemsCount: Int) -> [IndexPath] {
        // make paths for inserted items
        let range = (section.items.count - newItemsCount)..<section.items.count
        let indexPaths = range.map { IndexPath(row: $0, section: index) }
        return indexPaths
    }
    
}


class MyPendingRequests: DataSource {
    
    override func loadMore() {
        
        // load pendings
        interactor.loadNextPagePendigRequestItems { [weak self] (result) in
            
            guard let strongSelf = self else { return }
            
            switch result {
            case let .failure(error):
                strongSelf.delegate?.didFail(error: error)
            case let .success(models):
                let items = models.map { ActivityItem.pendingRequest($0) }
                strongSelf.section.items.append(contentsOf: items)
                
                // make paths for inserted items
                let indexPaths = strongSelf.insertedIndexes(newItemsCount: items.count)
                strongSelf.delegate?.didLoad(indexPaths: indexPaths)
            }
        }
    }
    
}

class MyFollowingsActivity: DataSource {
    
    override func loadMore() {
        // load activity
        interactor.loadNextPageFollowingActivities {  [weak self] (result) in
            
            guard let strongSelf = self else { return }
            
            switch result {
            case let .failure(error):
                strongSelf.delegate?.didFail(error: error)
            case let .success(models):
                let items = models.map { ActivityItem.follower($0) }
                strongSelf.section.items.append(contentsOf: items)
                
                // make paths for inserted items
                let indexPaths = strongSelf.insertedIndexes(newItemsCount: items.count)
                strongSelf.delegate?.didLoad(indexPaths: indexPaths)
            }
        }
    }
}

class MyFollowersActivity: DataSource {
    
    override func loadMore() {
        
    }
}


