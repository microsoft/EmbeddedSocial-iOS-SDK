//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

protocol ActivityInteractorOutput: class {
    
}

protocol ActivityInteractorInput {
    
    func loadAll()
    func loadNextPageFollowingActivities(completion: ((Result<[ActionItem]>) -> Void)?)
    func loadNextPagePendigRequestItems(completion: ((Result<[PendingRequestItem]>) -> Void)?)
    
}

protocol ActivityService: class {
    func loadFollowingActivities(cursor: String?, limit: Int, completion: (Result<FeedResponseActivityView>) -> Void)
    func loadPendingsRequests(cursor: String?, limit: Int, completion: (Result<FeedResponseUserCompactView>) -> Void)
}

class ActivityServiceMock: ActivityService {
    
    let authorization = "String"
    
    var followingActivitiesResponse: Result<FeedResponseActivityView>!
    var pendingRequestsResponse: Result<FeedResponseUserCompactView>!
    
    func builder<T>(cursor: String?, limit: Int) -> RequestBuilder<T>? {
        
        switch T.self {
        case is FeedResponseUserCompactView.Type:
            let result = SocialAPI.myPendingUsersGetPendingUsersWithRequestBuilder(authorization: authorization,
                                                                                   cursor: cursor,
                                                                                   limit: Int32(limit))
            
            return result as? RequestBuilder<T>
        default:
            return nil
        }
    }
    
    func loadFollowingActivities(cursor: String?, limit: Int, completion: (Result<FeedResponseActivityView>) -> Void) {
        completion(followingActivitiesResponse)
    }
    
    func loadPendingsRequests(cursor: String?, limit: Int, completion: (Result<FeedResponseUserCompactView>) -> Void) {
        completion(pendingRequestsResponse)
    }
    
    func test<T: Any>(cursor: String?, limit: Int, completion: (Result<T>) -> Void) {
        
        guard let builder: RequestBuilder<T> = self.builder(cursor: cursor, limit: limit) else {
            fatalError("Builder not found")
        }
        
        builder.execute { (response, error) in
            
        }
        
    }
    
}

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

class ActivityInteractor {
    
    typealias FollowingPage = PageModel<ActionItem>
    typealias PendingRequestPage = PageModel<PendingRequestItem>
    typealias PageID = String
    typealias FollowersActivitiesList = PagesList<ActionItem>
    typealias PendingRequestsList = PagesList<PendingRequestItem>
    
    weak var output: ActivityInteractorOutput!
    
    var service: ActivityServiceMock = ActivityServiceMock()
    fileprivate var followersList: FollowersActivitiesList = FollowersActivitiesList()
    fileprivate var pendingRequestsList: PendingRequestsList = PendingRequestsList()
    fileprivate var loadingPages: Set<PageID> = Set()
    
    // MARK: State
    
    fileprivate var isLoading: Bool = false
    
    //    fileprivate var followingPages: [FollowingPage] = []
    //    fileprivate var pendingRequestsPages: [PendingRequestPage] = []
    
}

protocol ResponseProcessor {
    associatedtype ResponseType
    associatedtype ResultType
    
    func process(response: ResponseType, pageID: String) -> PageModel<ResultType>?
}

class ActionItemResponseProcessor: ResponseProcessor {
    typealias ResponseType = FeedResponseActivityView
    typealias ResultType = ActionItem
    
    func process(response: ResponseType, pageID: String) -> PageModel<ResultType>? {
        var items = [ActionItem]()
        
        // mapping into domain model
        if let dataItems = response.data {
            for source in dataItems {
                guard let item = ActionItem(with: source) else { return nil }
                items.append(item)
            }
        }
        
        return PageModel<ActionItem>(uid: pageID, cursor: response.cursor, items: items)
    }
    
}

extension ActivityInteractor: ActivityInteractorInput {
    
    // TODO: remake using generics
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
    
    private func process(response: FeedResponseUserCompactView, pageID: String) -> PendingRequestPage? {
        var items = [PendingRequestItem]()
        
        // mapping into domain model
        if let dataItems = response.data {
            for source in dataItems {
                guard let item = PendingRequestItem(with: source) else { return nil }
                items.append(item)
            }
        }
        
        return PendingRequestPage(uid: pageID, cursor: response.cursor, items: items)
    }
    
    
    func loadAll() {
        followersList = FollowersActivitiesList()
        pendingRequestsList = PendingRequestsList()
        loadingPages = Set()
        
        //        loadNextPage()
    }
    
    // TODO: remake using generics
    func loadNextPageFollowingActivities(completion: ((Result<[ActionItem]>) -> Void)? = nil) {
        
        let pageID = UUID().uuidString
        loadingPages.insert(pageID)
        
        service.loadFollowingActivities(
            cursor: followersList.cursor,
            limit: followersList.limit) { [weak self] (result: Result<FeedResponseActivityView>) in
                
                defer {
                    loadingPages.remove(pageID)
                }
                
                // exit on released or canceled
                guard let strongSelf = self, strongSelf.loadingPages.contains(pageID) else {
                    return
                }
                
                // must have data
                guard let response = result.value else {
                    completion?(.failure(ActivityError.noData))
                    return
                }
                
                // map data into page
                guard let page = strongSelf.process(response: response, pageID: pageID) else {
                    completion?(.failure(ActivityError.notParsable))
                    return
                }
                
                strongSelf.followersList.add(page: page)
                
                completion?(.success(page.items))
        }
        
    }
    
    // TODO: remake using generics
    func loadNextPagePendigRequestItems(completion: ((Result<[PendingRequestItem]>) -> Void)? = nil) {
        
        let pageID = UUID().uuidString
        loadingPages.insert(pageID)
        
        service.loadPendingsRequests(
            cursor: followersList.cursor,
            limit: followersList.limit) { [weak self] (result: Result<FeedResponseUserCompactView>) in
                
                defer {
                    loadingPages.remove(pageID)
                }
                
                // exit on released or canceled
                guard let strongSelf = self, strongSelf.loadingPages.contains(pageID) else {
                    return
                }
                
                // must have data
                guard let response = result.value else {
                    completion?(.failure(ActivityError.noData))
                    return
                }
                
                // map data into page
                guard let page = strongSelf.process(response: response, pageID: pageID) else {
                    completion?(.failure(ActivityError.notParsable))
                    return
                }
                
                strongSelf.pendingRequestsList.add(page: page)
                
                completion?(.success(page.items))
        }
        
    }
}


