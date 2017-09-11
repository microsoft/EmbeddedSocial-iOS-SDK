//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

struct FeedActionRequest: Cacheable, Hashable, CustomStringConvertible {
    
    enum ActionType: String {
        case like, pin
    }
    
    enum ActionMethod: String {
        case post, delete
        
        func isIncreasing() -> Bool {
            return self == .post
        }
    }
    
    init(handle: String, actionType: ActionType, actionMethod: ActionMethod) {
        _ = FeedActionRequest.__once_initDecoder
        self.handle = handle
        self.actionType = actionType
        self.actionMethod = actionMethod
    }
    
    let handle: String
    let actionType: ActionType
    let actionMethod: ActionMethod
    
    func getHandle() -> String? {
        return handle
    }
    
    func encodeToJSON() -> Any {
        var nillableDictionary = [String:Any?]()
        nillableDictionary["handle"] = self.handle
        nillableDictionary["actionType"] = self.actionType.rawValue
        nillableDictionary["actionMethod"] = self.actionMethod.rawValue
        
        let dictionary: [String:Any] = APIHelper.rejectNil(nillableDictionary) ?? [:]
        return dictionary
    }
    
    var description: String {
        return "\(actionType) \(actionMethod) \(handle)"
    }
    
    var hashKey: String {
        return actionType.rawValue + handle
    }
    
    var hashValue: Int {
        return hashKey.hashValue
    }
    
    public static func ==(lhs: FeedActionRequest, rhs: FeedActionRequest) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
    
    // TODO: move to a new place, needs discussion
    static let __once_initDecoder: () = {
        
        Decoders.addDecoder(clazz: FeedActionRequest.self) { source, instance in
            
            guard let payload = source as? [String: Any],
                let handle = payload["handle"] as? String,
                let actionTypeRaw = payload["actionType"] as? String,
                let actionMethodRaw = payload["actionMethod"] as? String,
                let actionType = FeedActionRequest.ActionType(rawValue: actionTypeRaw),
                let actionMethod = FeedActionRequest.ActionMethod(rawValue: actionMethodRaw)
                else {
                    return .failure(.typeMismatch(expected: "FeedActionRequest", actual: "\(source)"))
            }
            
            let item = FeedActionRequest(handle: handle, actionType: actionType, actionMethod: actionMethod)
            return .success(item)
        }
        
    }()
}

class CachedActionsExecutor: NetworkStatusListener {
    
    private let cacheAdapter: FeedCacheActionsAdapterProtocol
    private let likesService: LikesServiceProtocol
    
    var isConnectionAvailable: Bool
    
    init(isConnectionAvailable: Bool,
         cacheAdapter: FeedCacheActionsAdapterProtocol,
         likesService: LikesServiceProtocol = LikesService()) {
        
        self.isConnectionAvailable = isConnectionAvailable
        self.cacheAdapter = cacheAdapter
        self.likesService = likesService
    }
    
    func networkStatusDidChange(_ isReachable: Bool) {
        
        isConnectionAvailable = isReachable
        
        if isConnectionAvailable {
            executeAll()
        }
    }
    
    private func onCompletion(_ request: FeedActionRequest, _ error: Error?) {
        
        guard error == nil else {
            Logger.log("Outgoing action is sent with error, \(request)", event: .veryImportant)
            beingExecuted.remove(request)
            cacheAdapter.remove(request)
            return
        }
        
        Logger.log("Outgoing cached action is sent successfully, \(request)", event: .veryImportant)
        
        // Clean cached outgoing action
        cacheAdapter.remove(request)
        // Clean action from set for execution
        beingExecuted.remove(request)
    }
    
    private(set) var beingExecuted = Set<FeedActionRequest>()
    private(set) var queuedForExecution = Set<FeedActionRequest>()
    
    func executeAll() {
    
        let allActions = cacheAdapter.getAllCachedActions()
        
        // Get not sent yet actions, append them for execution
        let notExecutedActions = allActions.subtracting(beingExecuted)
        queuedForExecution.formUnion(notExecutedActions)
        
        // Execute
        queuedForExecution.forEach { execute($0) }
    }
    
    private func execute(_ action: FeedActionRequest) {
    
        guard isConnectionAvailable == true else { return }
        
        queuedForExecution.remove(action)
        beingExecuted.insert(action)
        
        let handle = action.handle
        
        Logger.log("Executing outgoing cached action, \(action.actionType) \(action.actionMethod)", event: .veryImportant)
        
        switch (action.actionType, action.actionMethod) {
        case (.like, .post):
            likesService.postLike(postHandle: handle) { [weak self] handle, error in
                self?.onCompletion(action, error)
            }
        case (.like, .delete):
            likesService.deleteLike(postHandle: handle) { [weak self] handle, error in
                self?.onCompletion(action, error)
            }
        case (.pin, .post):
            likesService.postPin(postHandle: handle) { [weak self] handle, error in
                self?.onCompletion(action, error)
            }
        case (.pin, .delete):
            likesService.deletePin(postHandle: handle) { [weak self] handle, error in
                self?.onCompletion(action, error)
            }
        }
    }
}

class FeedActionRequestBuilder {
    
    static private func transformMethod(_ method: String) -> FeedActionRequest.ActionMethod {
        switch method {
        case "POST":
            return .post
        case "DELETE":
            return .delete
        default:
            fatalError("Unexpected")
        }
    }
    
    static func build(method: String, handle: String, action: FeedActionRequest.ActionType) -> FeedActionRequest {
        
        return FeedActionRequest(handle: handle,
                                   actionType: action,
                                   actionMethod: transformMethod(method))
    }
}

protocol FeedCacheActionsAdapterProtocol: class {
    func cache(_ request: FeedActionRequest)
    func getAllCachedActions() -> Set<FeedActionRequest>
    func remove(_ request: FeedActionRequest)
}

class FeedCacheActionsAdapter: FeedCacheActionsAdapterProtocol {
    
    weak var cache: CacheType!
    var predicateBuilder = PredicateBuilder()
    
    init(cache: CacheType) {
        self.cache = cache
    }
    
    func cache(_ request: FeedActionRequest) {
        
        let oppositeActionPredicate = predicateBuilder.predicate(typeID: request.hashKey)
        
        if let cached = cache.firstOutgoing(
            ofType: FeedActionRequest.self,
            predicate: oppositeActionPredicate,
            sortDescriptors: nil) {
            
            Logger.log("Removing \(cached) opposite to \(request)", event: .veryImportant)
            cache.deleteOutgoing(with: oppositeActionPredicate)
        } else {
            Logger.log("Caching action \(request)", event: .veryImportant)
            cache.cacheOutgoing(request, for: request.hashKey)
        }
    }
    
    func getAllCachedActions() -> Set<FeedActionRequest> {
        
        let request = CacheFetchRequest(resultType: FeedActionRequest.self)
        let results = cache.fetchOutgoing(with: request)
        
        return Set(results)
    }
    
    func remove(_ request: FeedActionRequest) {
        let predicate = predicateBuilder.predicate(typeID: request.hashKey)
        cache.deleteOutgoing(with: predicate)
    }
}
