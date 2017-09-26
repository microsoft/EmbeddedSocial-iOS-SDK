//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

protocol ActivityInteractorOutput: class {
    
}

typealias ActivityItemListResult = Result<ListResponse<ActivityView>>
typealias UserRequestListResult = Result<UsersListResponse>

protocol ActivityInteractorInput: class {
    
    func loadMyActivities(completion: ((ActivityItemListResult) -> Void)?)
    func loadNextPageMyActivities(completion: ((ActivityItemListResult) -> Void)?)
    
    func loadOthersActivities(completion: ((ActivityItemListResult) -> Void)?)
    func loadNextPageOthersActivities(completion: ((ActivityItemListResult) -> Void)?)
    
    func loadPendingRequestItems(completion: ((UserRequestListResult) -> Void)?)
    func loadNextPagePendigRequestItems(completion: ((UserRequestListResult) -> Void)?)
    
    func approvePendingRequest(user: UserCompactView, completion: @escaping (Result<Void>) -> Void)
    func rejectPendingRequest(user: UserCompactView, completion: @escaping (Result<Void>) -> Void)
    
}

protocol ActivityService: class {
    typealias ActivityResponse = ListResponse<ActivityView>

    func loadMyActivities(cursor: String?, limit: Int, completion: @escaping (ActivityItemListResult) -> Void)
    func loadOthersActivities(cursor: String?, limit: Int, completion: @escaping (ActivityItemListResult) -> Void)
    func loadPendingsRequests(cursor: String?, limit: Int, completion: @escaping (UserRequestListResult) -> Void)
    
    func approvePendingRequest(handle: String, completion: @escaping (Result<Void>) -> Void)
    func rejectPendingRequest(handle: String, completion: @escaping (Result<Void>) -> Void)
}

class ItemList<T> {
    var items: [T] = []
    var cursor: String?
    let limit = Constants.ActivityList.pageSize
}

class ActivityInteractor {
    
    typealias ActivitiesList = ItemList<ActivityView>
    typealias PendingRequestsList = ItemList<UserCompactView>
    
    weak var output: ActivityInteractorOutput!
    
    var service: ActivityService!
    
    fileprivate var myActivitiesList: ActivitiesList = ActivitiesList()
    fileprivate var othersActivitiesList: ActivitiesList = ActivitiesList()
    fileprivate var pendingRequestsList: PendingRequestsList = PendingRequestsList()

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
    
    func loadMyActivities(completion: ((ActivityItemListResult) -> Void)?) {
        myActivitiesList = ActivitiesList()
        loadNextPageMyActivities { [weak list = myActivitiesList] (result) in
            list?.cursor = result.value?.cursor
            completion?(result)
        }
    }
    
    func loadNextPageMyActivities(completion: ((ActivityItemListResult) -> Void)?) {
        service.loadMyActivities(cursor: myActivitiesList.cursor, limit: myActivitiesList.limit) { [weak list = myActivitiesList] (result) in
            list?.cursor = result.value?.cursor
            completion?(result)
        }
    }
    
    func loadPendingRequestItems(completion: ((UserRequestListResult) -> Void)?) {
        pendingRequestsList = PendingRequestsList()
        service.loadPendingsRequests(cursor: nil, limit: pendingRequestsList.limit) { [weak list = pendingRequestsList] (result) in
            list?.cursor = result.value?.cursor
            completion?(result)
        }
    }
    
    func loadNextPagePendigRequestItems(completion: ((UserRequestListResult) -> Void)?) {
        guard let cursor = pendingRequestsList.cursor  else {
            return
        }
        service.loadPendingsRequests(cursor: cursor, limit: pendingRequestsList.limit) { [weak list = pendingRequestsList] (result) in
            list?.cursor = result.value?.cursor
            completion?(result)
        }
    }
    
    func loadOthersActivities(completion: ((ActivityItemListResult) -> Void)?) {
        othersActivitiesList = ActivitiesList()
        service.loadOthersActivities(cursor: othersActivitiesList.cursor, limit: othersActivitiesList.limit) { [weak list = othersActivitiesList] (result) in
            list?.cursor = result.value?.cursor
            completion?(result)
        }
    }
    
    func loadNextPageOthersActivities(completion: ((ActivityItemListResult) -> Void)?) {
        service.loadOthersActivities(cursor: othersActivitiesList.cursor, limit: othersActivitiesList.limit) { [weak list = othersActivitiesList] (result) in
            list?.cursor = result.value?.cursor
            completion?(result)
        }
    }

}


