//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

struct TrendingTopicsConfigurator {
    let viewController: TrendingTopicsViewController
    var moduleInput: TrendingTopicsModuleInput!
    
    init() {
        viewController = StoryboardScene.TrendingTopics.trendingTopicsViewController.instantiate()
    }
    
    mutating func configure(output: TrendingTopicsModuleOutput?) {
        let presenter = TrendingTopicsPresenter()
        presenter.interactor = TrendingTopicsInteractor(hashtagsService: HashtagsService())
        presenter.view = viewController
        presenter.output = output
        
        viewController.output = presenter
        viewController.dataManager = TrendingTopicsDataDisplayManager()
        viewController.theme = SocialPlus.theme
        viewController.dataManager.theme = SocialPlus.theme
        
        moduleInput = presenter
    }
}
