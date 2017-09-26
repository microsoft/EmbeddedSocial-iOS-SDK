//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

typealias DataSourceContext = (state: ActivityPresenter.State, index: Int)

protocol DataSourceDelegate {
    func didFail(error: Error)
    func didLoad(indexPaths: [IndexPath], context: DataSourceContext)
}

class DataSourceBuilder {
    static func buildPendingRequestsDataSource(interactor: ActivityInteractorInput,
                                               delegate: DataSourceDelegate,
                                               context: DataSourceContext) -> MyPendingRequests {
        let header = SectionHeader(name: "Pending requests", identifier: "")
        let section = Section(header: header, pages: [])
        
        return MyPendingRequests(interactor: interactor,
                                 section:section,
                                 delegate: delegate,
                                 context: context)
    }
    
    static func buildMyActivitiesDataSource(interactor: ActivityInteractorInput,
                                                    delegate: DataSourceDelegate,
                                                    context: DataSourceContext) -> MyActivities {
        let header = SectionHeader(name: "My followings activity", identifier: "")
        let section = Section(header: header, pages: [])
        
        return MyActivities(interactor: interactor,
                                    section: section,
                                    delegate: delegate,
                                    context: context)
    }
    
    static func buildOthersActivitiesDataSource(interactor: ActivityInteractorInput,
                                                    delegate: DataSourceDelegate,
                                                    context: DataSourceContext) -> OthersActivties {
        let header = SectionHeader(name: "Others activities", identifier: "")
        let section = Section(header: header, pages: [])
        
        return OthersActivties(interactor: interactor,
                            section: section,
                            delegate: delegate,
                            context: context)
    }
    
}


// TODO: remake via generics
class DataSource {
    weak var interactor: ActivityInteractorInput!
    var section: Section
    var delegate: DataSourceDelegate?
    let context: DataSourceContext
    
    func load() { fatalError("No impl") }
    func loadMore() { fatalError("No impl") }
    
    init(interactor: ActivityInteractorInput,
         section: Section,
         delegate: DataSourceDelegate? = nil,
         context: DataSourceContext) {
        
        self.interactor = interactor
        self.section = section
        self.delegate = delegate
        self.context = context
    }
    
    deinit {
        Logger.log(self)
    }
}

class MyPendingRequests: DataSource {
    
    private func processResponse(_ result: UserRequestListResult, _ page: Int) {
    
        switch result {
        case let .failure(error):
            self.delegate?.didFail(error: error)
        case let .success(list):
            let items = list.users.map { ActivityItem.pendingRequest($0) }
            
            // replace page with new data, probaby from cache
            if section.pages.indices.contains(page) {
                section.pages[page] = items
            } else {
                section.pages.insert(items, at: page)
            }
        
            let indexPaths = section.range(forPage: page).map { IndexPath(row: $0, section: context.index) }
            self.delegate?.didLoad(indexPaths: indexPaths, context: self.context)
        }
    }
    
    override func load() {
        section.pages = []
        interactor.loadPendingRequestItems { [weak self] (result) in
            self?.processResponse(result, 0)
        }
    }
    
    override func loadMore() {
        let nextPage = section.pages.count
        interactor.loadNextPagePendigRequestItems { [weak self] (result) in
            self?.processResponse(result, nextPage)
        }
    }
    
}

class MyActivities: DataSource {
    
    private func processResponse(_ result: ActivityItemListResult, _ page: Int) {
        
        switch result {
        case let .failure(error):
            self.delegate?.didFail(error: error)
        case let .success(models):
            let items = models.items.map { ActivityItem.myActivity($0) }
        
            // replace page with new data, probaby from cache
            if section.pages.indices.contains(page) {
                section.pages[page] = items
            } else {
                section.pages.insert(items, at: page)
            }
            
            // make paths for inserted items
            let indexPaths = section.range(forPage: page).map { IndexPath(row: $0, section: context.index) }
            self.delegate?.didLoad(indexPaths: indexPaths, context: self.context)
        }
    }
    
    override func load() {
        section.pages = []
        interactor.loadMyActivities { [weak self] (result) in
            self?.processResponse(result, 0)
        }
    }
    
    override func loadMore() {
        let nextPage = section.pages.count
        interactor.loadNextPageMyActivities { [weak self] (result) in
            self?.processResponse(result, nextPage)
        }
    }
}

// TODO: remake via generic
class OthersActivties: DataSource {
    
    private func processResponse(_ result: ActivityItemListResult, _ page: Int) {
        
        switch result {
        case let .failure(error):
            self.delegate?.didFail(error: error)
        case let .success(models):
            let items = models.items.map { ActivityItem.othersActivity($0) }
            
            // replace page with new data, probaby from cache
            if section.pages.indices.contains(page) {
                section.pages[page] = items
            } else {
                section.pages.insert(items, at: page)
            }
            
            // make paths for inserted items
            let indexPaths = section.range(forPage: page).map { IndexPath(row: $0, section: context.index) }
            self.delegate?.didLoad(indexPaths: indexPaths, context: self.context)
        }
    }
    
    override func load() {
        section.pages = []
        interactor.loadOthersActivities { [weak self] (result) in
            self?.processResponse(result, 0)
        }
    }
    
    override func loadMore() {
        let nextPage = section.pages.count
        interactor.loadNextPageOthersActivities { [weak self] (result) in
            self?.processResponse(result, nextPage)
        }
    }
}
