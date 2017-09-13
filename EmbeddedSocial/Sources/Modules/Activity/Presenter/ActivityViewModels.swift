//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

protocol ActivityViewModelConfigurable {
    func configure(with viewModel: ActivityItemViewModel)
}

struct FollowRequestViewModel: ActivityItemViewModel {
    let profileImage: UIImage
    let profileName: String
    let identifier: String
}

struct ActivityViewModel: ActivityItemViewModel {
    let profileImage: UIImage
    let postText: String
    let postTime: String
    let postImage: UIImage
    let identifier: String
}

extension ActivityCell: ActivityViewModelConfigurable {
    
    func configure(with viewModel: ActivityItemViewModel) {
        guard let data = viewModel as? ActivityViewModel else { return }
        
        profileImage.image = data.profileImage
        postImage.image = data.postImage
        
        let postTextAttributed = NSAttributedString(string: data.postText, attributes: Style.Fonts.Attributes.normal)
        let postTimeAttributed = NSAttributedString(string: data.postTime, attributes: Style.Fonts.Attributes.time)
        let textAttributed = NSMutableAttributedString()
        textAttributed.append(postTextAttributed)
        textAttributed.append(NSAttributedString(string: " "))
        textAttributed.append(postTimeAttributed)
        
        postText.attributedText = textAttributed
    }
    
}

extension FollowRequestCell: ActivityViewModelConfigurable {
    
    func configure(with viewModel: ActivityItemViewModel) {
        guard let data = viewModel as? FollowRequestViewModel else { return }
        
        profileImage.image = data.profileImage
        profileName.text = data.profileName
    }
    
}


