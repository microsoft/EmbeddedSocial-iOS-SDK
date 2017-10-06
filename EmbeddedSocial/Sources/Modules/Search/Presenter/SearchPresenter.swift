//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

final class SearchPresenter: NSObject {
    
    weak var view: SearchViewInput!
    var peopleSearchModule: SearchPeopleModuleInput!
    var topicsSearchModule: SearchTopicsModuleInput!
    var interactor: SearchInteractorInput!
    
    fileprivate var isViewReady = false
    fileprivate var initialTab = SearchTabInfo.Tab.topics
    
    fileprivate var topicsTab: SearchTabInfo!
    fileprivate var peopleTab: SearchTabInfo!
    
    fileprivate var selectedTab: SearchTabInfo? {
        didSet {
            guard let oldValue = oldValue, let selectedTab = selectedTab, oldValue != selectedTab else {
                return
            }
            view.switchTabs(to: selectedTab, from: oldValue)
        }
    }
}

extension SearchPresenter: SearchViewOutput {
    
    func viewIsReady() {
        peopleSearchModule.setupInitialState()
        topicsSearchModule.setupInitialState()
        
        peopleTab = interactor.makePeopleTab(with: peopleSearchModule)
        topicsTab = interactor.makeTopicsTab(with: topicsSearchModule)
        selectedTab = initialTab == .people ? peopleTab : topicsTab
        
        view.setupInitialState(selectedTab!)
        view.setLayoutAsset(topicsSearchModule.layoutAsset)
        
        isViewReady = true
    }
    
    func onTopics() {
        selectedTab = topicsTab
    }
    
    func onPeople() {
        selectedTab = peopleTab
    }
    
    func onFlipTopicsLayout() {
        topicsSearchModule.flipLayout()
        view.setLayoutAsset(topicsSearchModule.layoutAsset)
    }
}

extension SearchPresenter: SearchPeopleModuleOutput, SearchTopicsModuleOutput {
    
    func didFailToLoadSuggestedUsers(_ error: Error) { }
    
    func didFailToLoadSearchQuery(_ error: Error) {
        view.showError(error)
    }
    
    func didSelectHashtag(_ hashtag: Hashtag) {
        view.search(hashtag: hashtag)
    }
}

extension SearchPresenter: SearchModuleInput {
    
    func selectPeopleTab() {
        isViewReady ? (selectedTab = peopleTab) : (initialTab = .people)
    }
}
