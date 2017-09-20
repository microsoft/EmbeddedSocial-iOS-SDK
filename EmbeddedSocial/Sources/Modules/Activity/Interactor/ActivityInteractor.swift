//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

protocol ActivityInteractorOutput: class {
    
}



protocol ActivityInteractorInput {
    
//    var isLoadingList: Bool { get }
//
//    func getNextListPage(completion: @escaping (Result<[User]>) -> Void)
//
//    func processSocialRequest(to user: User, completion: @escaping (Result<FollowStatus>) -> Void)
//
//    func setAPI(_ api: UsersListAPI)
//
//    func reloadList(completion: @escaping (Result<[User]>) -> Void)
    
    
    
    
}


class Service {
    
    func load(cursor: String?, limit: Int, completion: (Result<FeedResponseActivityView>) -> Void) {
        completion(.success(FeedResponseActivityView().mockResponse()))
    }
    
}


class ActivityInteractor {
    
    struct PageModel<T> {
        let uid: String
        let cursor: String?
        var items: [T] = []
        
        func isEmpty() -> Bool {
            return items.isEmpty
        }
    }
    
    struct PagesList<T> {
        var limit: Int = 10
        var cursor: String?
        var pages: [PageModel<T>] = []
        
        mutating func add(items: [T], cursor: String?) {
            assert(items.count <= limit)
            let page = PageModel(uid: UUID().uuidString, cursor: cursor, items: items)
            pages.append(page)
        }
        
        mutating func add(page: PageModel<T>) {
            assert(page.items.count <= limit)
            pages.append(page)
            cursor = page.cursor
        }
        
        func nextPageAvailable() -> Bool {
            return cursor != nil
        }
    }
    
    typealias FollowingPage = PageModel<ActionItem>
    typealias PendingRequestPage = PageModel<PendingRequestItem>
    typealias PageID = String
    typealias FollowersActivitiesList = PagesList<ActionItem>
    
    weak var output: ActivityInteractorOutput!
    
    fileprivate var service: Service = Service()
    fileprivate var followingPages: FollowersActivitiesList = FollowersActivitiesList()
    fileprivate var loadingPages: Set<PageID> = Set()
    
    // MARK: State
    
    fileprivate var isLoading: Bool = false
    
//    fileprivate var followingPages: [FollowingPage] = []
//    fileprivate var pendingRequestsPages: [PendingRequestPage] = []

}

extension ActivityInteractor: ActivityInteractorInput {
    
    private func process(response: FeedResponseActivityView, pageID: String) -> FollowingPage? {
        var items = [ActionItem]()
        
        // mapping into domain model
        if let dataItems = response.data {
            for source in dataItems {
                guard let item = ActionItem(with: source) else { return nil }
                items.append(item)
            }
        }
        
        return FollowingPage(uid: pageID, cursor: response.cursor, items: items)
    }
    
    func loadAll() {
        followingPages = FollowersActivitiesList()
        loadingPages = Set()
        
        loadNextPage()
    }
    
    func loadNextPage(completion: ((Result<[ActionItem]>) -> Void)? = nil) {
        
        let pageID = UUID().uuidString
        loadingPages.insert(pageID)
        
        service.load(cursor: followingPages.cursor, limit: followingPages.limit) { [weak self] (result) in
            
            defer {
                loadingPages.remove(pageID)
            }
            
            guard let strongSelf = self, strongSelf.loadingPages.contains(pageID) else {
                return
            }
            
            guard let response = result.value else {
                completion?(.failure(ActivityError.noData))
                return
            }
            
            guard let page = strongSelf.process(response: response, pageID: pageID) else {
                completion?(.failure(ActivityError.notParsable))
                return
            }
            
            strongSelf.followingPages.add(page: page)
            
            completion?(.success(page.items))
        }
        
    }
    
    func loadNextPage(completion: (Result<[PendingRequestItem]>) -> Void) {
        
    }
}


