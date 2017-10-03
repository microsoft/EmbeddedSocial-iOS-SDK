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

struct PagesListModel<Header, Item> {
    
    var header: Header
    var pages: [[Item]] = []
    
    var items: [Item] {
        return pages.flatMap{ $0 }
    }
    
    func range(forPage index: Int) -> CountableRange<Int> {
        let page = pages[index]
        let startIndex = pages[0..<index].reduce(0) { result, page in
            return result + page.count
        }
        return startIndex..<startIndex + page.count
    }
    
    mutating func removeItem(itemIndex: Int) {
        
        var indexes = 0
        for (index, page) in pages.enumerated() {
            
            // page range
            let range = indexes..<indexes + page.count
            
            // check for looking index in page
            if range.contains(itemIndex) {
                let indexInPage = itemIndex - range.startIndex
                pages[index].remove(at: indexInPage)
                break
            }
            
            indexes += page.count
        }
        
    }
}

enum ActivityItem {
    case pendingRequest(User)
    case myActivity(ActivityView)
    case othersActivity(ActivityView)
}

extension ActivityItem: Equatable {
    static func ==(lhs: ActivityItem, rhs: ActivityItem) -> Bool {
        switch (lhs, rhs) {
        case let (.pendingRequest(lhsRequest), .pendingRequest(rhsRequest)):
            return lhsRequest == rhsRequest
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
    case insertion([T])
    case deletion([T])
    case update([T])
    case updateVisible
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
        
        cell.actionIcon.image = viewModel.iconImage?.image
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

