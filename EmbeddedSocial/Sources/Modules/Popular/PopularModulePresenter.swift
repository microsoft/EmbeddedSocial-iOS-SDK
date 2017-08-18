//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

protocol PopularModuleInput {
    
}

class PopularModulePresenter: PopularModuleViewOutput, PopularModuleInput, PopularModuleInteractorOutput {
    
    weak var view: PopularModuleViewInput!
    var feedModule: FeedModuleInput!
    
    // MARK: Private
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
    }
    
    func feedTypeDidChange(to index: Int) {
        let timeRange = feedMapping[index].feed
        let feedType = FeedType.popular(type: timeRange)
        feedModule.setFeed(feedType)
        feedModule.refreshData()
    }
}
