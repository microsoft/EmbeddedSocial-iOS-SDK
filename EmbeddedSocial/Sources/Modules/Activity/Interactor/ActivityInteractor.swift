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
    
    func loadMyActivities(completion: ((Result<[ActivityItemType]>) -> Void)?)
    func loadNextPageMyActivities(completion: ((Result<[ActivityItemType]>) -> Void)?)
    
    func loadOthersActivties(completion: ((Result<[ActivityItemType]>) -> Void)?)
    func loadNextPageOthersActivities(completion: ((Result<[ActivityItemType]>) -> Void)?)
    
    func loadPendingRequestItems(completion: ((Result<[PendingRequestItemType]>) -> Void)?)
    func loadNextPagePendigRequestItems(completion: ((Result<[PendingRequestItemType]>) -> Void)?)
    
    func approvePendingRequest(user: UserCompactView, completion: @escaping (Result<Void>) -> Void)
    func rejectPendingRequest(user: UserCompactView, completion: @escaping (Result<Void>) -> Void)
    
}

protocol ActivityService: class {
    
    typealias ActivityResponse = ListResponse<ActivityView>

    
    func loadMyActivities(cursor: String?, limit: Int, completion: @escaping (Result<ActivityResponse>) -> Void)
    func loadOthersActivities(cursor: String?, limit: Int, completion: @escaping (Result<ActivityResponse>) -> Void)
    func loadPendingsRequests(cursor: String?, limit: Int, completion: @escaping (Result<UsersListResponse>) -> Void)
    
    func approvePendingRequest(handle: String, completion: @escaping (Result<Void>) -> Void)
    func rejectPendingRequest(handle: String, completion: @escaping (Result<Void>) -> Void)
}

//class ActivityServiceMock: ActivityService {
//
//    func approvePendingRequest(handle: String, completion: @escaping (Result<Void>) -> Void) {
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//            completion(.success())
//        }
//    }
//
//    func rejectPendingRequest(handle: String, completion: @escaping (Result<Void>) -> Void) {
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//            completion(.success())
//        }
//    }
//
//    let authorization = "String"
//
//    var followingActivitiesResponse: Result<ActivityResponseType>! = .success(ActivityResponseType().mockResponse())
//    var pendingRequestsResponse: Result<PendingRequestsResponseType>! = .success(PendingRequestsResponseType().mockResponse())
//
//    var pendingRequestsResponsesLeft = 1
//    var followingActivitiesResponsesLeft = 5
//
//    let emptyPendingRequestsResponse: Result<PendingRequestsResponseType> = .success(PendingRequestsResponseType())
//    let emptyFollowingActivitiesResponse: Result<ActivityResponseType> = .success(ActivityResponseType())
//
//
//    func builder<T>(cursor: String?, limit: Int) -> RequestBuilder<T>? {
//
//        switch T.self {
//        case is PendingRequestsResponseType.Type:
//            let result = SocialAPI.myPendingUsersGetPendingUsersWithRequestBuilder(authorization: authorization,
//                                                                                   cursor: cursor,
//                                                                                   limit: Int32(limit))
//
//            return result as? RequestBuilder<T>
//        default:
//            return nil
//        }
//    }
//
//    func loadFollowingActivities(cursor: String?, limit: Int, completion: @escaping (Result<ActivityResponseType>) -> Void) {
//
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
//            guard let strongSelf = self else { return }
//
//            guard strongSelf.followingActivitiesResponsesLeft > 0 else {
//                completion(strongSelf.emptyFollowingActivitiesResponse)
//                return
//            }
//
//            strongSelf.followingActivitiesResponsesLeft -= 1
//            completion(strongSelf.followingActivitiesResponse)
//        }
//    }
//
//    func loadPendingsRequests(cursor: String?, limit: Int, completion: @escaping (Result<PendingRequestsResponseType>) -> Void) {
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
//            guard let strongSelf = self else { return }
//
//            guard strongSelf.pendingRequestsResponsesLeft > 0 else {
//                completion(strongSelf.emptyPendingRequestsResponse)
//                return
//            }
//
//            strongSelf.pendingRequestsResponsesLeft -= 1
//
//            completion(strongSelf.pendingRequestsResponse)
//        }
//    }
//
//    func test<T: Any>(cursor: String?, limit: Int, completion: (Result<T>) -> Void) {
//
//        guard let builder: RequestBuilder<T> = self.builder(cursor: cursor, limit: limit) else {
//            fatalError("Builder not found")
//        }
//
//        builder.execute { (response, error) in
//
//        }
//    }
//
//}

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
    var loadingPages: Set<String> = Set()
    
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
    
    func indexRangeForPage(pageIndex: Int) -> CountableRange<Int>? {
        
        guard let lastPage = pages.last, lastPage.items.count > 0 else {
            return nil
        }
        
        let itemsCount = pages.reduce(0) { $0.0 + $0.1.items.count }
        let lastPageItemsCount = lastPage.items.count
        
        return (itemsCount - lastPageItemsCount)..<itemsCount
    }
    
}

class ActivityInteractor {
    
    typealias FollowingPage = PageModel<ActivityItemType>
    typealias PendingRequestPage = PageModel<PendingRequestItemType>
    typealias PageID = String
    typealias ActivitiesList = PagesList<ActivityView>
    typealias PendingRequestsList = PagesList<UserCompactView>
    
    weak var output: ActivityInteractorOutput!
    
    var service: ActivityService!
    
    fileprivate var myActivitiesList: ActivitiesList = ActivitiesList()
    fileprivate var othersActivitiesList: ActivitiesList = ActivitiesList()
    fileprivate var pendingRequestsList: PendingRequestsList = PendingRequestsList()
    
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
        guard let handle = user.userHandle else {
            completion(.failure(APIError.missingUserData))
            return
        }
        service.rejectPendingRequest(handle: handle, completion: completion)
    }
    
    private func process(response: ActivityResponseType, pageID: String) -> FollowingPage? {
        return FollowingPage(uid: pageID, cursor: response.cursor, items: response.data ?? [])
    }
    
    private func process(response: PendingRequestsResponseType, pageID: String) -> PendingRequestPage? {
        return PendingRequestPage(uid: pageID, cursor: response.cursor, items: response.data ?? [])
    }
    
    func loadAll() {
        myActivitiesList = ActivitiesList()
        othersActivitiesList = ActivitiesList()
        pendingRequestsList = PendingRequestsList()
    }
    
    func loadMyActivities(completion: ((Result<[ActivityItemType]>) -> Void)?) {
        myActivitiesList = ActivitiesList()
        loadNextPageMyActivities(completion: completion)
    }
    
    func loadPendingRequestItems(completion: ((Result<[PendingRequestItemType]>) -> Void)?) {
        pendingRequestsList = PendingRequestsList()
        loadNextPagePendigRequestItems(completion: completion)
    }
    
    func loadOthersActivties(completion: ((Result<[ActivityItemType]>) -> Void)?) {
        othersActivitiesList = ActivitiesList()
        loadNextPageOthersActivities(completion: completion)
    }
   
    // TODO: remake using generics
    func loadNextPageMyActivities(completion: ((Result<[ActivityItemType]>) -> Void)? = nil) {
        
        let pageID = UUID().uuidString
        myActivitiesList.loadingPages.insert(pageID)
        
        service.loadMyActivities(cursor: myActivitiesList.cursor,
                                 limit: myActivitiesList.limit) { [weak self] (result) in
    
                defer {
                    self?.myActivitiesList.loadingPages.remove(pageID)
                }
                
                // exit on released or canceled
                guard let strongSelf = self, strongSelf.myActivitiesList.loadingPages.contains(pageID) else {
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
                
                strongSelf.myActivitiesList.add(page: page)
                
                completion?(.success(page.items))
        }
        
    }
    
    // TODO: remake using generics
    func loadNextPageOthersActivities(completion: ((Result<[ActivityItemType]>) -> Void)?) {
        let pageID = UUID().uuidString
        othersActivitiesList.loadingPages.insert(pageID)
        
        service.loadOthersActivities(
            cursor: othersActivitiesList.cursor,
            limit: othersActivitiesList.limit) { [weak self] (result: Result<ActivityResponseType>) in
                
                defer {
                    self?.othersActivitiesList.loadingPages.remove(pageID)
                }
                
                // exit on released or canceled
                guard let strongSelf = self, strongSelf.othersActivitiesList.loadingPages.contains(pageID) else {
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
                
                strongSelf.othersActivitiesList.add(page: page)
                
                completion?(.success(page.items))
        }
    }
    
    // TODO: remake using generics
    func loadNextPagePendigRequestItems(completion: ((Result<[PendingRequestItemType]>) -> Void)? = nil) {
        
        let pageID = UUID().uuidString
        pendingRequestsList.loadingPages.insert(pageID)
        let cursor = pendingRequestsList.cursor
        let limit = pendingRequestsList.limit
        
        service.loadPendingsRequests(
            cursor: cursor,
            limit: limit) { [weak self] (result: Result<PendingRequestsResponseType>) in
                
                defer {
                    self?.pendingRequestsList.loadingPages.remove(pageID)
                }
                
                // exit on released or canceled
                guard let strongSelf = self, strongSelf.pendingRequestsList.loadingPages.contains(pageID) else {
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
                
                if cursor == nil {
                    strongSelf.pendingRequestsList.pages = [page]
                } else {
                    strongSelf.pendingRequestsList.add(page: page)
                }
                
                completion?(.success(page.items))
        }
        
    }
}


