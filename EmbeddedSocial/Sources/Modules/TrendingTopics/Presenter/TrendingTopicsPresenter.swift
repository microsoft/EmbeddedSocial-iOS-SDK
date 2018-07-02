//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import UIKit

final class TrendingTopicsPresenter {
    var view: TrendingTopicsViewInput!
    var interactor: TrendingTopicsInteractorInput!
    weak var output: TrendingTopicsModuleOutput?
    
    fileprivate var isAnimatingPullToRefresh = false
}

extension TrendingTopicsPresenter: TrendingTopicsViewOutput {
    
    func viewIsReady() {
        view.setupInitialState()
        loadHashtags()
    }
    
    private func loadHashtags() {
        view.setIsLoading(true)
        
        interactor.getTrendingHashtags { [weak self] result in
            self?.view.setIsLoading(false)
            self?.proccessHashtagsResult(result)
        }
    }
    
    private func proccessHashtagsResult(_ result: Result<[Hashtag]>) {
        if let hashtags = result.value {
            view.setHashtags(hashtags)
        } else {
            view.showError(result.error ?? APIError.unknown)
        }
    }
    
    func onItemSelected(_ item: TrendingTopicsListItem) {
        output?.didSelectHashtag(item.hashtag)
    }
    
    func onPullToRefresh() {
        guard !isAnimatingPullToRefresh else {
            return
        }
        
        isAnimatingPullToRefresh = true
        
        interactor.reloadTrendingHashtags { [weak self] result in
            self?.isAnimatingPullToRefresh = false
            self?.view.endPullToRefreshAnimation()
            self?.proccessHashtagsResult(result)
        }
    }
}

extension TrendingTopicsPresenter: TrendingTopicsModuleInput {
    
    var viewController: UIViewController {
        return view as? UIViewController ?? UIViewController()
    }
}
