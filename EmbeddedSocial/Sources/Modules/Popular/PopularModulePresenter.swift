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
    private var layoutType: FeedModuleLayoutType = .list
    private var feedModule: FeedModuleInput!
    private var feedModuleViewController: UIViewController!
    private var currentFeed = Constants.Feed.Popular.initialFeedScope
    var feedMapping = [
        (feed: FeedType.TimeRange.today, title: L10n.PopularModule.FeedOption.today),
        (feed: FeedType.TimeRange.weekly, title: L10n.PopularModule.FeedOption.thisWeek),
        (feed: FeedType.TimeRange.alltime, title: L10n.PopularModule.FeedOption.allTime)
    ]
    
    fileprivate let settings: Settings
    
    init(settings: Settings = AppConfiguration.shared.settings) {
        self.settings = settings
    }
    
    // MARK: View Input
    func viewIsReady() {
        view.setupInitialState(showGalleryView: settings.showGalleryView)
        view.setFeedTypesAvailable(types: feedMapping.map { $0.title })
        view.setCurrentFeedType(to: currentFeed.rawValue)
        
        let configured = configuredFeedModule(router.navigationController, self)
        feedModule = configured.moduleInput
        feedModuleViewController = configured.viewController
        
        view.embedFeedViewController(feedModuleViewController)
        
        feedModule.feedType = .popular(type: currentFeed)
        
        view.setFeedLayoutImage(layoutType.nextLayoutAsset.image)
    }

    func feedTypeDidChange(to index: Int) {
        let timeRange = feedMapping[index].feed
        let feedType = FeedType.popular(type: timeRange)
        feedModule.feedType = (feedType)
    }
    
    func feedLayoutTypeChangeDidTap() {
        layoutType.flip()
        view.setFeedLayoutImage(layoutType.nextLayoutAsset.image)
        feedModule.layout = layoutType
    }
    
    deinit {
        Logger.log()
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
    
    func didScrollFeed(_ feedView: UIScrollView) { }
    
    func shouldOpenProfile(for userID: String) -> Bool {
        return true
    }
}
