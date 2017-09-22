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
    case follower(ActivityView)
    case following(ActivityView)
}

// MARK: Models

// Helpers

enum Change<T> {
    case Insertion(items: [T])
    case Deletion(items: [T])
    case Update(items: [T])
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
    
    func getFullName() -> String {
        return String(format: "%@ %@", self.firstName ?? "", self.lastName ?? "")
    }

}




