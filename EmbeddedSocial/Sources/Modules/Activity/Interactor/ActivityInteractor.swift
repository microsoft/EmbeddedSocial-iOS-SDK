//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

protocol ActivityInteractorOutput: class {
    
}

typealias ActivityItemListResult = Result<PaginatedResponse<ActivityView>>
typealias UserRequestListResult = Result<PaginatedResponse<User>>

protocol ActivityInteractorInput: class {
    func loadSpecificMyActivities(cursor: String, limit: Int, completion: @escaping (ActivityItemListResult) -> Void)
    func loadMyActivities(completion: ((ActivityItemListResult) -> Void)?)
    func loadNextPageMyActivities(completion: ((ActivityItemListResult) -> Void)?)
    
    func loadSpecificOthersActivities(cursor: String, limit: Int, completion: @escaping  (ActivityItemListResult) -> Void)
    func loadOthersActivities(completion: ((ActivityItemListResult) -> Void)?)
    func loadNextPageOthersActivities(completion: ((ActivityItemListResult) -> Void)?)
    
    
    func loadSpecificPendingRequestItems(cursor: String, limit: Int, completion: @escaping (UserRequestListResult) -> Void)
    func loadPendingRequestItems(completion: ((UserRequestListResult) -> Void)?)
    func loadNextPagePendigRequestItems(completion: ((UserRequestListResult) -> Void)?)
    
    func acceptPendingRequest(user: User, completion: @escaping (Result<Void>) -> Void)
    func rejectPendingRequest(user: User, completion: @escaping (Result<Void>) -> Void)
    
//    func notify
    func sendActivityStateAsRead(with handle: String)
    
}

protocol ActivityService: class {

    func loadMyActivities(cursor: String?, limit: Int, completion: @escaping (ActivityItemListResult) -> Void)
    func loadOthersActivities(cursor: String?, limit: Int, completion: @escaping (ActivityItemListResult) -> Void)
    func loadPendingsRequests(cursor: String?, limit: Int, completion: @escaping (UserRequestListResult) -> Void)
    
    func acceptPending(user: User, completion: @escaping (Result<Void>) -> Void)
    func cancelPending(user: User, completion: @escaping (Result<Void>) -> Void)
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
    var notificationsService: ActivityNotificationsServiceProtocol! = ActivityNotificationsService()
    weak var notificationsUpdater: NotificationsUpdater!
    
    fileprivate var myActivitiesList: ActivitiesList = ActivitiesList()
    fileprivate var othersActivitiesList: ActivitiesList = ActivitiesList()
    fileprivate var pendingRequestsList: PendingRequestsList = PendingRequestsList()
    
}

extension ActivityInteractor: ActivityInteractorInput {
    
    func loadSpecificMyActivities(cursor: String, limit: Int, completion: @escaping (ActivityItemListResult) -> Void) {
        service.loadMyActivities(cursor: cursor, limit: limit, completion: completion)
    }
    
    func acceptPendingRequest(user: User, completion: @escaping (Result<Void>) -> Void) {
        service.acceptPending(user: user, completion: completion)
    }
    
    func rejectPendingRequest(user: User, completion: @escaping (Result<Void>) -> Void) {
        service.cancelPending(user: user, completion: completion)
    }
    
    // MARK: My Activity
    
    func loadMyActivities(completion: ((ActivityItemListResult) -> Void)?) {
        myActivitiesList = ActivitiesList()
        service.loadMyActivities(cursor: myActivitiesList.cursor, limit: myActivitiesList.limit) { [weak list = myActivitiesList] (result) in
            list?.cursor = result.value?.cursor
            completion?(result)
        }
    }
    
    func loadSpecificMyActivities(cursor: String, limit: Int32, completion: @escaping (ActivityItemListResult) -> Void) {
        service.loadMyActivities(cursor: cursor, limit: Int(limit), completion: completion)
    }
    
    func loadNextPageMyActivities(completion: ((ActivityItemListResult) -> Void)?) {
        guard let cursor = myActivitiesList.cursor  else {
            return
        }
        
        service.loadMyActivities(cursor: cursor, limit: myActivitiesList.limit) { [weak list = myActivitiesList] (result) in
            list?.cursor = result.value?.cursor
            completion?(result)
        }
    }
    
    // MARK: Pending requests
    func loadSpecificPendingRequestItems(cursor: String, limit: Int, completion: @escaping (UserRequestListResult) -> Void) {
        service.loadPendingsRequests(cursor: cursor, limit: limit, completion: completion)
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
    
    // MARK: Other Activity
    func loadSpecificOthersActivities(cursor: String, limit: Int, completion: @escaping  (ActivityItemListResult) -> Void) {
        service.loadOthersActivities(cursor: cursor, limit: limit, completion: completion)
    }
    
    func loadOthersActivities(completion: ((ActivityItemListResult) -> Void)?) {
        othersActivitiesList = ActivitiesList()
        service.loadOthersActivities(cursor: nil, limit: othersActivitiesList.limit) { [weak list = othersActivitiesList] (result) in
            list?.cursor = result.value?.cursor
            completion?(result)
        }
    }
    
    func loadNextPageOthersActivities(completion: ((ActivityItemListResult) -> Void)?) {
        guard let cursor = othersActivitiesList.cursor  else {
            return
        }
        
        service.loadOthersActivities(cursor: cursor, limit: othersActivitiesList.limit) { [weak list = othersActivitiesList] (result) in
            list?.cursor = result.value?.cursor
            completion?(result)
        }
    }
    
    // MARK: Misc
    func sendActivityStateAsRead(with handle: String) {
        let updater = self.notificationsUpdater
        notificationsService.updateStatus(for: handle) { result in
            if result.isSuccess {
                updater?.updateNotifications()
            }
        }
    }
}


