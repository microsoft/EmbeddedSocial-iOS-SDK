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
        let section = Section(model: header, items: [])
        
        return MyPendingRequests(interactor: interactor,
                                 section:section,
                                 delegate: delegate,
                                 context: context)
    }
    
    static func buildMyActivitiesDataSource(interactor: ActivityInteractorInput,
                                                    delegate: DataSourceDelegate,
                                                    context: DataSourceContext) -> MyActivities {
        let header = SectionHeader(name: "My followings activity", identifier: "")
        let section = Section(model: header, items: [])
        
        return MyActivities(interactor: interactor,
                                    section: section,
                                    delegate: delegate,
                                    context: context)
    }
    
    static func buildOthersActivitiesDataSource(interactor: ActivityInteractorInput,
                                                    delegate: DataSourceDelegate,
                                                    context: DataSourceContext) -> OthersActivties {
        let header = SectionHeader(name: "Others activities", identifier: "")
        let section = Section(model: header, items: [])
        
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
    
    func insertedIndexes(newItemsCount: Int) -> [IndexPath] {
        // make paths for inserted items
        let range = (section.items.count - newItemsCount)..<section.items.count
        let indexPaths = range.map { IndexPath(row: $0, section: context.index) }
        return indexPaths
    }
    
    deinit {
        Logger.log(self)
    }
}

class MyPendingRequests: DataSource {
    
    private func processResponse(_ result: Result<[PendingRequestItemType]>) {
    
        switch result {
        case let .failure(error):
            self.delegate?.didFail(error: error)
        case let .success(models):
            let items = models.map { ActivityItem.pendingRequest($0) }
            self.section.items.append(contentsOf: items)
            
            // make paths for inserted items
            let indexPaths = self.insertedIndexes(newItemsCount: items.count)
            self.delegate?.didLoad(indexPaths: indexPaths, context: self.context)
        }
    }
    
    override func load() {
        interactor.loadPendingRequestItems { [weak self] (result) in
            self?.processResponse(result)
        }
    }
    
    override func loadMore() {
        interactor.loadNextPagePendigRequestItems { [weak self] (result) in
            self?.processResponse(result)
        }
    }
    
}

class MyActivities: DataSource {
    
    private func processResponse(_ result: Result<[ActivityItemType]>) {
        
        switch result {
        case let .failure(error):
            self.delegate?.didFail(error: error)
        case let .success(models):
            let items = models.map { ActivityItem.myActivity($0) }
            self.section.items.append(contentsOf: items)
            
            // make paths for inserted items
            let indexPaths = self.insertedIndexes(newItemsCount: items.count)
            self.delegate?.didLoad(indexPaths: indexPaths, context: self.context)
        }
    }
    
    override func load() {
        interactor.loadMyActivities { [weak self] (result) in
            self?.processResponse(result)
        }
    }
    
    override func loadMore() {
    
        interactor.loadNextPageMyActivities { [weak self] (result) in
            self?.processResponse(result)
        }
    }
}

class OthersActivties: DataSource {
    
    private func processResponse(_ result: Result<[ActivityItemType]>) {
        
        switch result {
        case let .failure(error):
            self.delegate?.didFail(error: error)
        case let .success(models):
            let items = models.map { ActivityItem.othersActivity($0) }
            self.section.items.append(contentsOf: items)
            
            // make paths for inserted items
            let indexPaths = self.insertedIndexes(newItemsCount: items.count)
            self.delegate?.didLoad(indexPaths: indexPaths, context: self.context)
        }
    }
    
    override func load() {
        interactor.loadNextPageOthersActivities { [weak self] (result) in
            self?.processResponse(result)
        }
    }
    
    override func loadMore() {
        // load activity
        interactor.loadNextPageOthersActivities { [weak self] (result) in
            self?.processResponse(result)
        }
    }
}
