//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

protocol ActivityInteractorOutput: class {
    
}

typealias ActivityItemType = ActivityView
typealias PendingRequestItemType = UserCompactView
typealias ActivityResponseType = FeedResponseActivityView
typealias PendingRequestsResponseType = FeedResponseUserCompactView

protocol ActivityInteractorInput: class {
    
    func loadAll()
    func loadNextPageFollowingActivities(completion: ((Result<[ActivityItemType]>) -> Void)?)
    func loadNextPagePendigRequestItems(completion: ((Result<[PendingRequestItemType]>) -> Void)?)
    
    func approvePendingRequest(user: UserCompactView, completion: @escaping (Result<Void>) -> Void)
    func rejectPendingRequest(user: UserCompactView, completion: @escaping (Result<Void>) -> Void)
    
}

protocol ActivityService: class {
    func loadFollowingActivities(cursor: String?, limit: Int, completion: @escaping (Result<ActivityResponseType>) -> Void)
    func loadPendingsRequests(cursor: String?, limit: Int, completion: @escaping (Result<PendingRequestsResponseType>) -> Void)
    
    func approvePendingRequest(handle: String, completion: @escaping (Result<Void>) -> Void)
    func rejectPendingRequest(handle: String, completion: @escaping (Result<Void>) -> Void)
}

class ActivityServiceMock: ActivityService {
    
    func approvePendingRequest(handle: String, completion: @escaping (Result<Void>) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            completion(.success())
        }
    }
    
    func rejectPendingRequest(handle: String, completion: @escaping (Result<Void>) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            completion(.success())
        }
    }
    
    let authorization = "String"
    
    var followingActivitiesResponse: Result<ActivityResponseType>! = .success(ActivityResponseType().mockResponse())
    var pendingRequestsResponse: Result<PendingRequestsResponseType>! = .success(PendingRequestsResponseType().mockResponse())
    
    var pendingRequestsResponsesLeft = 1
    var followingActivitiesResponsesLeft = 5
    
    let emptyPendingRequestsResponse: Result<PendingRequestsResponseType> = .success(PendingRequestsResponseType())
    let emptyFollowingActivitiesResponse: Result<ActivityResponseType> = .success(ActivityResponseType())
 
    
    func builder<T>(cursor: String?, limit: Int) -> RequestBuilder<T>? {
        
        switch T.self {
        case is PendingRequestsResponseType.Type:
            let result = SocialAPI.myPendingUsersGetPendingUsersWithRequestBuilder(authorization: authorization,
                                                                                   cursor: cursor,
                                                                                   limit: Int32(limit))
            
            return result as? RequestBuilder<T>
        default:
            return nil
        }
    }
    
    func loadFollowingActivities(cursor: String?, limit: Int, completion: @escaping (Result<ActivityResponseType>) -> Void) {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            guard let strongSelf = self else { return }
            
            guard strongSelf.followingActivitiesResponsesLeft > 0 else {
                completion(strongSelf.emptyFollowingActivitiesResponse)
                return
            }
            
            strongSelf.followingActivitiesResponsesLeft -= 1
            completion(strongSelf.followingActivitiesResponse)
        }
    }
    
    func loadPendingsRequests(cursor: String?, limit: Int, completion: @escaping (Result<PendingRequestsResponseType>) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            guard let strongSelf = self else { return }
            
            guard strongSelf.pendingRequestsResponsesLeft > 0 else {
                completion(strongSelf.emptyPendingRequestsResponse)
                return
            }
            
            strongSelf.pendingRequestsResponsesLeft -= 1
            
            completion(strongSelf.pendingRequestsResponse)
        }
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
    var limit: Int = Constants.ActivityList.pageSize
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
    
    typealias FollowingPage = PageModel<ActivityItemType>
    typealias PendingRequestPage = PageModel<PendingRequestItemType>
    typealias PageID = String
    typealias FollowersActivitiesList = PagesList<ActivityView>
    typealias PendingRequestsList = PagesList<UserCompactView>
    
    weak var output: ActivityInteractorOutput!
    
    var service: ActivityServiceMock = ActivityServiceMock()
    fileprivate var followersList: FollowersActivitiesList = FollowersActivitiesList()
    fileprivate var pendingRequestsList: PendingRequestsList = PendingRequestsList()
    fileprivate var loadingPages: Set<PageID> = Set()
    
    // MARK: State
    
    fileprivate var isLoading: Bool = false

}

extension ActivityInteractor: ActivityInteractorInput {
    
    func approvePendingRequest(user: UserCompactView, completion: @escaping (Result<Void>) -> Void) {
        guard let handle = user.userHandle else {
            completion(.failure(APIError.missingUserData))
            return
        }
        
        service.approvePendingRequest(handle: handle, completion: completion)
    }
    
    func rejectPendingRequest(user: UserCompactView, completion: @escaping (Result<Void>) -> Void) {
        
    }
    
    private func process(response: ActivityResponseType, pageID: String) -> FollowingPage? {
        return FollowingPage(uid: pageID, cursor: response.cursor, items: response.data ?? [])
    }
    
    private func process(response: PendingRequestsResponseType, pageID: String) -> PendingRequestPage? {
        return PendingRequestPage(uid: pageID, cursor: response.cursor, items: response.data ?? [])
    }
    
    
    func loadAll() {
        followersList = FollowersActivitiesList()
        pendingRequestsList = PendingRequestsList()
        loadingPages = Set()
        
        //        loadNextPage()
    }
    
    // TODO: remake using generics
    func loadNextPageFollowingActivities(completion: ((Result<[ActivityItemType]>) -> Void)? = nil) {
        
        let pageID = UUID().uuidString
        loadingPages.insert(pageID)
        
        service.loadFollowingActivities(
            cursor: followersList.cursor,
            limit: followersList.limit) { [weak self] (result: Result<ActivityResponseType>) in
                
                defer {
                    self?.loadingPages.remove(pageID)
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
    func loadNextPagePendigRequestItems(completion: ((Result<[PendingRequestItemType]>) -> Void)? = nil) {
        
        let pageID = UUID().uuidString
        loadingPages.insert(pageID)
        
        service.loadPendingsRequests(
            cursor: followersList.cursor,
            limit: followersList.limit) { [weak self] (result: Result<PendingRequestsResponseType>) in
                
                defer {
                    self?.loadingPages.remove(pageID)
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


