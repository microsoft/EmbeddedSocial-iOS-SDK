//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

typealias DataSourceContext = (state: ActivityPresenter.State, index: Int)

protocol DataSourceDelegate {
    func didFail(error: Error)
    func didChangeItems(change: Change<IndexPath>, context: DataSourceContext)
}

class DataSourceBuilder {
    
    static func buildPendingRequestsDataSource(interactor: ActivityInteractorInput,
                                               delegate: DataSourceDelegate? = nil,
                                               context: DataSourceContext) -> MyPendingRequests {
        let header = SectionHeader(name: L10n.Activity.Sections.Pending.title, identifier: "")
        let section = Section(header: header, pages: [])
        
        return MyPendingRequests(interactor: interactor,
                                 section:section,
                                 delegate: delegate,
                                 context: context)
    }
    
    static func buildMyActivitiesDataSource(interactor: ActivityInteractorInput,
                                                    delegate: DataSourceDelegate? = nil,
                                                    context: DataSourceContext) -> MyActivities {
        let header = SectionHeader(name: L10n.Activity.Sections.My.title, identifier: "")
        let section = Section(header: header, pages: [])
        
        return MyActivities(interactor: interactor,
                                    section: section,
                                    delegate: delegate,
                                    context: context)
    }
    
    static func buildOthersActivitiesDataSource(interactor: ActivityInteractorInput,
                                                    delegate: DataSourceDelegate? = nil,
                                                    context: DataSourceContext) -> OthersActivties {
        let header = SectionHeader(name: L10n.Activity.Sections.Others.title, identifier: "")
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
    
    func process(newItems: [ActivityItem], pageIdx: Int) {
        // replace page with new data, probaby from cache
        let isNewData = (section.pages.count == 0 || section.pages.indices.contains(pageIdx) == false)
        
        if isNewData {
            // inserting new page
            section.pages.insert(newItems, at: pageIdx)
            
            let paths = section.range(forPage: pageIdx).map { IndexPath(row: $0, section: context.index) }
            delegate?.didChangeItems(change: .insertion(paths), context: context)
            
        } else {
            
            let cachedNumberOfItems = section.pages[pageIdx].count
            let needRemoveItems = (cachedNumberOfItems - newItems.count)
            let needAddItems = (newItems.count - cachedNumberOfItems)
            
            let oldPaths = Set(section.range(forPage: pageIdx).map { IndexPath(row: $0, section: context.index) })
            
            
            // replacing items for existing page
            section.pages[pageIdx] = newItems
            
            let newPaths = Set(section.range(forPage: pageIdx).map { IndexPath(row: $0, section: context.index) })
            let diffPaths = Array(oldPaths.symmetricDifference(newPaths))
            let toUpdate = Array(oldPaths.intersection(newPaths))
            
            // notify UI about changes
            if needAddItems > 0 {
                delegate?.didChangeItems(change: .insertion(diffPaths), context: context)
            }
            else if needRemoveItems > 0 {
                delegate?.didChangeItems(change: .deletion(diffPaths), context: context)
            }
            
            delegate?.didChangeItems(change: .update(toUpdate), context: context)
        }
    }
}

// TODO: remake via generic
class MyPendingRequests: DataSource {
    
    private func processResponse(_ result: UserRequestListResult, _ page: Int) {
    
        switch result {
        case let .failure(error):
            self.delegate?.didFail(error: error)
        case let .success(list):
            let items = list.users.map { ActivityItem.pendingRequest($0) }
            process(newItems: items, pageIdx: page)
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

// TODO: remake via generic
class MyActivities: DataSource {
    
    private func processResponse(_ result: ActivityItemListResult, _ page: Int) {
        
        switch result {
        case let .failure(error):
            self.delegate?.didFail(error: error)
        case let .success(models):
            let items = models.items.map { ActivityItem.myActivity($0) }
            process(newItems: items, pageIdx: page)
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
            
            process(newItems: items, pageIdx: page)
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
