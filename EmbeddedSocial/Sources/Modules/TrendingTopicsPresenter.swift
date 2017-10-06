//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

final class TrendingTopicsPresenter {
    var view: TrendingTopicsViewInput!
    var interactor: TrendingTopicsInteractorInput!
    weak var output: TrendingTopicsModuleOutput?
}

extension TrendingTopicsPresenter: TrendingTopicsViewOutput {
    
    func viewIsReady() {
        view.setupInitialState()
        loadHashtags()
    }
    
    private func loadHashtags() {
        view.setIsLoading(true)
        
        interactor.getTrendingHashtags { [weak self] result in
            if let hashtags = result.value {
                self?.view.setHashtags(hashtags)
            } else {
                self?.view.showError(result.error ?? APIError.unknown)
            }
            
            self?.view.setIsLoading(false)
        }
    }
    
    func onItemSelected(_ item: TrendingTopicsListItem) {
        output?.didSelectHashtag(item.hashtag)
    }
}

extension TrendingTopicsPresenter: TrendingTopicsModuleInput {
    
    var viewController: UIViewController {
        return view as? UIViewController ?? UIViewController()
    }
}
