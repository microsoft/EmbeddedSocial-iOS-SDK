//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

protocol PopularModuleInput {
    
}

class PopularModulePresenter: PopularModuleViewOutput, PopularModuleInput, PopularModuleInteractorOutput {
    
    weak var view: PopularModuleViewInput!
    var configuredFeedModule: ((UINavigationController, FeedModuleOutput) -> FeedModuleConfigurator)!
    var router: PopularModuleRouterInput!
    
    // MARK: Private
    private var feedModule: FeedModuleInput!
    private var feedModuleViewController: UIViewController!
    private var currentFeed: FeedType.TimeRange = .today
    private var feedMapping = [
        (feed: FeedType.TimeRange.today, title: L10n.PopularModule.FeedOption.today),
        (feed: FeedType.TimeRange.weekly, title: L10n.PopularModule.FeedOption.thisWeek),
        (feed: FeedType.TimeRange.alltime, title: L10n.PopularModule.FeedOption.allTime)
    ]
    
    // MARK: View Input
    func viewIsReady() {
        view.setFeedTypesAvailable(types: feedMapping.map { $0.title })
        view.setCurrentFeedType(to: currentFeed.rawValue)
        
        let configured = configuredFeedModule(router.navigationController, self)
        feedModule = configured.moduleInput
        feedModuleViewController = configured.viewController
        
        view.embedFeedViewController(feedModuleViewController)
        
        feedModule.setFeed(.popular(type: currentFeed))
        feedModule.refreshData()
    }

    func feedTypeDidChange(to index: Int) {
        let timeRange = feedMapping[index].feed
        let feedType = FeedType.popular(type: timeRange)
        feedModule.setFeed(feedType)
        feedModule.refreshData()
    }
}

extension PopularModulePresenter: FeedModuleOutput {
    
    func didStartRefreshingData() {
        view.lockFeedControl()
    }
    
    func didFinishRefreshingData(_ error: Error?) {
        view.unlockFeedControl()
        
        if let error = error {
            view.handleError(error: error)
        }
    }
}
