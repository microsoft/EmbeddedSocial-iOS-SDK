//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

protocol ActivityModuleInput: class {
    
}

class ActivityPresenter: ActivityModuleInput, ActivityViewOutput, ActivityInteractorOutput {
    
    func numberOfSections() -> Int {
        return data.count
    }
    
    func numberOfItems(in section: Int) -> Int {
        return data[section].count
    }
    
    var data: [[ActivityItemViewModel]] = [
        [FollowRequestViewModel(profileImage: Asset.placeholderPostUser1.image,
                                profileName: "Sirian Commando",
                                identifier: FollowRequestCell.reuseID)],
        
        [ActivityViewModel(profileImage: Asset.userPhotoPlaceholder.image,
                               postText: "Likes theses colors.",
                               postTime: "3s",
                               postImage: Asset.placeholderPostImage2.image,
                               identifier: ActivityCell.reuseID
            )]]
    
    func viewModel(for indexPath: IndexPath) -> ActivityItemViewModel {
        return data[indexPath.section][indexPath.row]
    }

    weak var view: ActivityViewInput!
    var interactor: ActivityInteractorInput!
    var router: ActivityRouterInput!

    func viewIsReady() {
        view.setupInitialState()
    }
}
