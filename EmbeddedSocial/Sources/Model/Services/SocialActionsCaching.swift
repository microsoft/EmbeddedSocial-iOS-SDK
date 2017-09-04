//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

struct SocialActionRequest: Cacheable {
    
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
    
    var hashKey: String {
        return actionType.rawValue + handle
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

class CachedActionsExecuter {
    
    let cache: SocialActionsCache
    var likesService: LikesServiceProtocol
    
    init(cache: SocialActionsCache, likesService: LikesServiceProtocol = LikesService()) {
        self.cache = cache
        self.likesService = likesService
    }
    
    private func onCompletion(_ request: SocialActionRequest, _ error: Error?) {
        guard error == nil else { return }
        cache.remove(request)
    }
    
    func executeAll() {
        actionsGroup = DispatchGroup()
        
        let actions = cache.getAllCachedActions()
        
        guard actions.count > 0 else { return }
        
        Logger.log("Outgoing operations are being executed, \(actions.count) to go", event: .veryImortant)
        
        for action in actions {
            execute(action)
        }
    }
    
    private var actionsGroup: DispatchGroup?
    
    func execute(_ action: SocialActionRequest) {
        
        let handle = action.handle
    
        switch action.actionType {
        case .like:
            if action.actionMethod == .post {
                actionsGroup?.enter()
                likesService.postLike(postHandle: handle) { [weak self] handle, error in
                    self?.onCompletion(action, error)
                    self?.actionsGroup?.leave()
                }
            } else {
                actionsGroup?.enter()
                likesService.deleteLike(postHandle: handle) { [weak self] handle, error in
                    self?.onCompletion(action, error)
                    self?.actionsGroup?.leave()
                }
            }
        case .pin:
            if action.actionMethod == .post {
                actionsGroup?.enter()
                likesService.postPin(postHandle: handle) { [weak self] handle, error in
                    self?.onCompletion(action, error)
                    self?.actionsGroup?.leave()
                }
            } else {
                actionsGroup?.enter()
                likesService.deletePin(postHandle: handle) { [weak self] handle, error in
                    self?.onCompletion(action, error)
                    self?.actionsGroup?.leave()
                }
            }
        }
        
        actionsGroup?.notify(queue: DispatchQueue.main) {
            Logger.log("Outgoing operations are executed", event: .veryImortant)
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

class SocialActionsCache {
    
    weak var cache: CacheType!
    var predicateBuilder = PredicateBuilder()
    
    init(cache: CacheType) {
        self.cache = cache
    }
    
    func cache(_ request: SocialActionRequest) {
        cache.cacheOutgoing(request, for: request.hashKey)
    }
    
    func getAllCachedActions() -> [SocialActionRequest] {
        
        let request = CacheFetchRequest(resultType: SocialActionRequest.self)
        let results = cache.fetchOutgoing(with: request)
        
        return results
    }
    
    func remove(_ request: SocialActionRequest) {
        let predicate = predicateBuilder.predicate(typeID: request.hashKey)
        cache.deleteOutgoing(with: predicate)
    }
}
