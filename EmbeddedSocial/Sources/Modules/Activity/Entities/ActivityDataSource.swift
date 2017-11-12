//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

typealias DataSourceContext = (state: ActivityPresenter.State, index: Int)

protocol DataSourceDelegate {
    func didStartLoading()
    func didFinishLoading()
    func didFail(error: Error)
    func didChangeItems(change: Change<IndexPath>, context: DataSourceContext)
}

class DataSourceBuilder {
    
    enum DataSourceType {
        case pending, myActivity, othersActivity
    }
    
    static func build(with type: DataSourceType,
                      delegate: DataSourceDelegate? = nil,
                      interactor: ActivityInteractorInput,
                      context: DataSourceContext) -> DataSourceProtocol {
        switch type {
        case .pending:
            return self.buildPendingRequestsDataSource(interactor: interactor, delegate: delegate, context: context)
        case .myActivity:
            return self.buildMyActivitiesDataSource(interactor: interactor, delegate: delegate, context: context)
        case .othersActivity:
            return self.buildOthersActivitiesDataSource(interactor: interactor, delegate: delegate, context: context)
        }
    }
    
    
    static func buildPendingRequestsDataSource(interactor: ActivityInteractorInput,
                                               delegate: DataSourceDelegate? = nil,
                                               context: DataSourceContext) -> MyPendingRequests {
        let header = SectionHeader(name: L10n.Activity.Sections.Pending.title, identifier: "")
        let section = ActivitySection(header: header, pages: [])
        
        return MyPendingRequests(interactor: interactor,
                                 section:section,
                                 delegate: delegate,
                                 context: context)
    }
    
    static func buildMyActivitiesDataSource(interactor: ActivityInteractorInput,
                                                    delegate: DataSourceDelegate? = nil,
                                                    context: DataSourceContext) -> MyActivities {
        let header = SectionHeader(name: L10n.Activity.Sections.My.title, identifier: "")
        let section = ActivitySection(header: header, pages: [])
        
        return MyActivities(interactor: interactor,
                                    section: section,
                                    delegate: delegate,
                                    context: context)
    }
    
    static func buildOthersActivitiesDataSource(interactor: ActivityInteractorInput,
                                                    delegate: DataSourceDelegate? = nil,
                                                    context: DataSourceContext) -> OthersActivties {
        let header = SectionHeader(name: L10n.Activity.Sections.Others.title, identifier: "")
        let section = ActivitySection(header: header, pages: [])
        
        return OthersActivties(interactor: interactor,
                            section: section,
                            delegate: delegate,
                            context: context)
    }
    
}

protocol DataSourceProtocol: class {
    func load()
    func loadMore()
    var section: ActivitySection { get set}
    var delegate: DataSourceDelegate? { get set}
    var context: DataSourceContext { get }
}

class DataSource<T>: DataSourceProtocol {
    
    typealias Page = PaginatedResponse<T>
    
    weak var interactor: ActivityInteractorInput!
    var section: ActivitySection
    var delegate: DataSourceDelegate?
    let context: DataSourceContext
    
    fileprivate func fetchAll(completion: @escaping (Result<Page>) -> Void) { fatalError("Abstract") }
    fileprivate func fetch(limit: Int, cursor: String, completion: @escaping (Result<Page>) -> Void) { fatalError("Abstract") }
    fileprivate func fetchMore(completion: @escaping (Result<Page>) -> Void) { fatalError("Abstract") }
    fileprivate func convert(_ data: T) -> ActivityItem { fatalError("Abstract") }
    
    func load() {
        self.delegate?.didStartLoading()
        self.section.pages = []
        let limit = Constants.ActivityList.pageSize
        
        fetchAll { [weak self] result in
            self?.resultHandler(limit: limit, result: result, page: 0)
            self?.delegate?.didFinishLoading()
        }
    }
    
    func loadMore() {
        self.delegate?.didStartLoading()
        let nextPage = section.pages.count
        let limit = Constants.ActivityList.pageSize
        
        fetchMore { [weak self] result in
            self?.resultHandler(limit: limit,result: result, page: nextPage)
            self?.delegate?.didFinishLoading()
        }
    }
    
    init(interactor: ActivityInteractorInput,
         section: ActivitySection,
         delegate: DataSourceDelegate? = nil,
         context: DataSourceContext) {
        
        self.interactor = interactor
        self.section = section
        self.delegate = delegate
        self.context = context
    }
    
    func resultHandler(limit: Int, result: Result<Page>, page: Int) {
        switch result {
        case let .failure(error):
            self.delegate?.didFail(error: error)
        case let .success(list):

            let items = list.items.map { self.convert($0) }
            print("received items \(items.count), limit\(limit) cursor \(list.cursor)")
            process(newItems: items, pageIdx: page)
            
            // recursive re-refetch if server returns empty pages with cursor
            if let nextCursor = list.cursor, items.count < limit, list.hasMore == true {
               let missingItems = max(limit - items.count, 0)
                fetch(limit: missingItems, cursor: nextCursor, completion: { [weak self] (result) in
                    self?.resultHandler(limit: missingItems, result: result, page: page)
                })
            } else {
                print("done with result \(list) ofr limit : \(limit)")
            }
            
            
        }
    }
    
    func process(newItems: [ActivityItem], pageIdx: Int) {
        // replace page with new data, probalby from cache
        let noPages = section.pages.count == 0
        let pageExists = section.pages.indices.contains(pageIdx)
        let shouldInsertNewPage = (noPages || !pageExists)
        
        if shouldInsertNewPage {
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

class MyPendingRequests: DataSource<User> {
    override func convert(_ data: User) -> ActivityItem {
        return ActivityItem.pendingRequest(data)
    }
    
    override func fetchAll(completion: @escaping (Result<PaginatedResponse<User>>) -> Void) {
        interactor.loadPendingRequestItems(completion: completion)
    }
    
    override func fetch(limit: Int, cursor: String, completion: @escaping (Result<PaginatedResponse<User>>) -> Void) {
        interactor.loadSpecificPendingRequestItems(cursor: cursor, limit: limit, completion: completion)
    }
    
    override func fetchMore(completion: @escaping (Result<PaginatedResponse<User>>) -> Void) {
        interactor.loadNextPagePendigRequestItems(completion: completion)
    }
}

class MyActivities: DataSource<ActivityView> {
    override func convert(_ data: ActivityView) -> ActivityItem {
        return ActivityItem.myActivity(data)
    }
    
    override func fetchAll(completion: @escaping (Result<PaginatedResponse<ActivityView>>) -> Void) {
        interactor.loadMyActivities(completion: completion)
    }
    
    override func fetch(limit: Int, cursor: String, completion: @escaping (Result<PaginatedResponse<ActivityView>>) -> Void) {
        interactor.loadSpecificMyActivities(cursor: cursor, limit: limit, completion: completion)
    }
    
    override func fetchMore(completion: @escaping (Result<PaginatedResponse<ActivityView>>) -> Void) {
        interactor.loadNextPageMyActivities(completion: completion)
    }
}

class OthersActivties: DataSource<ActivityView> {
    
    override func convert(_ data: ActivityView) -> ActivityItem {
        return ActivityItem.othersActivity(data)
    }
    
    override func fetch(limit: Int, cursor: String, completion: @escaping (Result<PaginatedResponse<ActivityView>>) -> Void) {
        interactor.loadSpecificOthersActivities(cursor: cursor, limit: limit, completion: completion)
    }
    
    override func fetchAll(completion: @escaping (Result<PaginatedResponse<ActivityView>>) -> Void) {
        interactor.loadOthersActivities(completion: completion)
    }

    override func fetchMore(completion: @escaping (Result<PaginatedResponse<ActivityView>>) -> Void) {
        interactor.loadNextPageOthersActivities(completion: completion)
    }
}
