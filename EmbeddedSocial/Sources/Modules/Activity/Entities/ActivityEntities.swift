//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

struct SectionHeader {
    var name: String
    var identifier: String?
}

// MARK: Model

enum ActivityItem {
    case pendingRequest(UserCompactView)
    case myActivity(ActivityView)
    case othersActivity(ActivityView)
}

extension ActivityItem: Equatable {
    static func ==(lhs: ActivityItem, rhs: ActivityItem) -> Bool {
        switch (lhs, rhs) {
        case let (.pendingRequest(lhsRequest), .pendingRequest(rhsRequest)):
            return lhsRequest.userHandle == rhsRequest.userHandle
        case let (.myActivity(lhsMyActivity), .myActivity(rhsMyActivity)):
            return lhsMyActivity.activityHandle == rhsMyActivity.activityHandle
        case let (.othersActivity(lhsOthersActivity), .othersActivity(rhsOthersActivity)):
            return lhsOthersActivity.activityHandle == rhsOthersActivity.activityHandle
        default:
            return false
        }
    }
}



// MARK: Models

// Helpers

enum Change<T> {
    case Insertion(items: [T])
    case Deletion(items: [T])
    case Update(items: [T])
}

class CellConfigurator {
    
    var presenter: ActivityPresenter!
    
    func configure(cell: UITableViewCell,
                   viewModel: ActivityItemViewModel,
                   tableView: UITableView,
                   onAction: ActivityCellBlock?) {
        
        cell.selectionStyle = .none
        
        if let cell = cell as? ActivityCell, let viewModel = viewModel as? ActivityViewModel {
            configure(cell: cell, with: viewModel, tableView: tableView, onAction: onAction)
        }
        else if let cell = cell as? FollowRequestCell, let viewModel = viewModel as? PendingRequestViewModel  {
            configure(cell: cell, with: viewModel, tableView: tableView, onAction: onAction)
        } else {
            fatalError("No implementation")
        }
    }
    
    private func configure(cell: ActivityCell,
                           with viewModel: ActivityViewModel,
                           tableView: UITableView,
                           onAction: ActivityCellBlock?) {
        
        let profilePhoto = Photo(url: viewModel.profileImage)
        cell.profileImage.setPhotoWithCaching(profilePhoto, placeholder: viewModel.profileImagePlaceholder.image)
        
        if let postImageURL = viewModel.postImage {
            cell.postImage.setPhotoWithCaching(Photo(url: postImageURL) , placeholder: nil)
        }
        
        let postTextAttributed = NSAttributedString(string: viewModel.postText,
                                                    attributes: ActivityBaseCell.Style.Fonts.Attributes.normal)
        let postTimeAttributed = NSAttributedString(string: viewModel.postTime,
                                                    attributes: ActivityBaseCell.Style.Fonts.Attributes.time)
        
        let textAttributed = NSMutableAttributedString()
        textAttributed.append(postTextAttributed)
        textAttributed.append(NSAttributedString(string: " "))
        textAttributed.append(postTimeAttributed)
        
        cell.postText.attributedText = textAttributed
        
        cell.indexPath = { cell in
            return tableView.indexPath(for: cell)
        }
        cell.onAction = onAction
    }
    
    private func configure(cell: FollowRequestCell,
                           with viewModel: PendingRequestViewModel,
                           tableView: UITableView,
                           onAction: ActivityCellBlock?)  {
        
        let profilePhoto = Photo(url: viewModel.profileImage)
        cell.profileImage.setPhotoWithCaching(profilePhoto, placeholder: viewModel.profileImagePlaceholder.image)
        cell.profileName.text = viewModel.profileName
        
        cell.indexPath = { cell in
            return tableView.indexPath(for: cell)
        }
        cell.onAction = onAction
    }
    
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


extension ActivityView {

    func createdTimeAgo() -> String? {
        guard let date = self.createdTime else { return nil }
        return DateFormatterTool.timeAgo(since: date)
    }
    
}


extension UserCompactView {
    
    func getFullName() -> String? {
        
        guard let firstName = self.firstName, let lastName = self.lastName else {
            return nil
        }
        return String(format: "%@ %@", firstName, lastName)
    }

}

struct ListResponse<T> {
    var items: [T] = []
    var cursor: String? = nil
    var isFromCache: Bool = false
}




