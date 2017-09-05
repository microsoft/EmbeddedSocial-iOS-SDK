//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

struct SocialActionRequest: Cacheable, Hashable, CustomStringConvertible {
    
    enum ActionType: String {
        case like, pin
    }
    
    enum ActionMethod: String {
        case post, delete
    }
    
    init(handle: String, actionType: ActionType, actionMethod: ActionMethod) {
        _ = SocialActionRequest.__once_initDecoder
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
    
    public static func ==(lhs: SocialActionRequest, rhs: SocialActionRequest) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
    
    // TODO: move to a new place, needs discussion
    static let __once_initDecoder: () = {
        
        Decoders.addDecoder(clazz: SocialActionRequest.self) { source, instance in
            
            guard let payload = source as? [String: Any],
                let handle = payload["handle"] as? String,
                let actionTypeRaw = payload["actionType"] as? String,
                let actionMethodRaw = payload["actionMethod"] as? String,
                let actionType = SocialActionRequest.ActionType(rawValue: actionTypeRaw),
                let actionMethod = SocialActionRequest.ActionMethod(rawValue: actionMethodRaw)
                else {
                    return .failure(.typeMismatch(expected: "SocialActionRequest", actual: "\(source)"))
            }
            
            let item = SocialActionRequest(handle: handle, actionType: actionType, actionMethod: actionMethod)
            return .success(item)
        }
        
    }()
}

class CachedActionsExecuter: NetworkStatusListener {
    
    private let cacheAdapter: SocialActionsCacheAdapter
    private let likesService: LikesServiceProtocol
    
    init(cacheAdapter: SocialActionsCacheAdapter, likesService: LikesServiceProtocol = LikesService()) {
        self.cacheAdapter = cacheAdapter
        self.likesService = likesService
    }
    
    func networkStatusDidChange(_ isReachable: Bool) {
        
        guard isReachable == true else { return }
        
        Logger.log("Connection from now is \(isReachable) \(String(describing: self))", event: .veryImportant)
        
        executeAll()
    }
    
    private func onCompletion(_ request: SocialActionRequest, _ error: Error?) {
        guard error == nil else { return }
        Logger.log("Outgoing cached action is sent successfully, \(request)", event: .veryImportant)
        
        // Clean cached outgoing action
        cacheAdapter.remove(request)
        // Clean action from set for execution
        actionsInExecution.remove(request)
    }
    
    private var actionsInExecution = Set<SocialActionRequest>()
    
    func executeAll() {
    
        let actions = cacheAdapter.getAllCachedActions()
        
        let actionToExecute = actions.subtracting(actionsInExecution)
        
        actionToExecute.forEach { execute($0) }
    }
    
    func execute(_ action: SocialActionRequest) {
        
        let handle = action.handle
        
        Logger.log("Executing outgoing cached action, \(action.actionType) \(action.actionMethod)", event: .veryImportant)
        
        actionsInExecution.insert(action)
        
        switch action.actionType {
        case .like:
            if action.actionMethod == .post {
                
                likesService.postLike(postHandle: handle) { [weak self] handle, error in
                    self?.onCompletion(action, error)
                    
                }
            } else {
                
                likesService.deleteLike(postHandle: handle) { [weak self] handle, error in
                    self?.onCompletion(action, error)
                    
                }
            }
        case .pin:
            if action.actionMethod == .post {
                
                likesService.postPin(postHandle: handle) { [weak self] handle, error in
                    self?.onCompletion(action, error)
                    
                }
            } else {
                
                likesService.deletePin(postHandle: handle) { [weak self] handle, error in
                    self?.onCompletion(action, error)
                    
                }
            }
        }
    }
}

class SocialActionRequestBuilder {
    
    static private func transformMethod(_ method: String) -> SocialActionRequest.ActionMethod {
        switch method {
        case "POST":
            return SocialActionRequest.ActionMethod.post
        case "DELETE":
            return SocialActionRequest.ActionMethod.delete
        default:
            fatalError("Unexpected")
        }
    }
    
    static func build(method: String, handle: String, action: SocialActionRequest.ActionType) -> SocialActionRequest {
        
        return SocialActionRequest(handle: handle,
                                   actionType: action,
                                   actionMethod: transformMethod(method))
    }
}

class SocialActionsCacheAdapter {
    
    weak var cache: CacheType!
    var predicateBuilder = PredicateBuilder()
    
    init(cache: CacheType) {
        self.cache = cache
    }
    
    func cache(_ request: SocialActionRequest) {
        
        let oppositeActionPredicate = predicateBuilder.predicate(typeID: request.hashKey)
        
        if let cached = cache.firstOutgoing(
            ofType: SocialActionRequest.self,
            predicate: oppositeActionPredicate,
            sortDescriptors: nil) {
            
            Logger.log("Removing opposite action \(cached) to \(request)", event: .veryImportant)
            cache.deleteOutgoing(with: oppositeActionPredicate)
        } else {
            Logger.log("Caching action \(request)", event: .veryImportant)
            cache.cacheOutgoing(request, for: request.hashKey)
        }
    }
    
    func getAllCachedActions() -> Set<SocialActionRequest> {
        
        let request = CacheFetchRequest(resultType: SocialActionRequest.self)
        let results = cache.fetchOutgoing(with: request)
        
        return Set(results)
    }
    
    func remove(_ request: SocialActionRequest) {
        let predicate = predicateBuilder.predicate(typeID: request.hashKey)
        cache.deleteOutgoing(with: predicate)
    }
}
