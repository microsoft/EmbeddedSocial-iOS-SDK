//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

protocol ActivityInteractorOutput: class {
    
}

protocol ActivityInteractorInput {
    func load<T>(cursor: String?, limit: Int, handler: ((Result<T>) -> Void))
}

protocol ActivityServiceProtocol {
    func loadPendings(cursor: String?, limit: Int, completion: (String) -> Void)
}

class ActivityService: ActivityServiceProtocol {
    func loadPendings(cursor: String?, limit: Int, completion: (String) -> Void) {
        completion("lol")
    }
    
    func loadActions(cursor: String?, limit: Int, completion: (Result<ActivityView>) -> Void) {
        let result = ActivityView()
        let userA = UserCompactView()
        userA.firstName = "Bilya"
        userA.lastName = "Ates"
        
        let userB = UserCompactView()
        userB.firstName = "Stivi"
        userB.lastName = "Hopes"
        result.activityType = .like
        result.actorUsers = [userA]
        result.actedOnUser = userB
        
        completion(.success(result))
    }
}

class ActivityInteractor: ActivityInteractorInput {
    
    weak var output: ActivityInteractorOutput!
    
    var service: ActivityService! = ActivityService()
    
    func load<T>(cursor: String? = nil, limit: Int = 10, handler: ((Result<T>) -> Void) ) {
        
        let key = String(describing: T.self)
        
        // get loader
        guard let loader = loaders[key] else {
            handler(.failure(Activity.Errors.loaderNotFound))
            return
        }
        
        //
        let args: FetchArguments = (cursor, limit)
        
        // load
        loader(args) { (result: Result<Any>)  in
            
            guard let data = result.value else {
                handler(.failure(Activity.Errors.noData))
                return
            }
            
            // map the loaded data
            if let mapped: T = self.map(source: data) {
                handler(.success(mapped))
            } else {
                handler(.failure(Activity.Errors.mapperNotFound))
            }
        }
    }
    
    typealias MappingBlockType = (Result<Any>) -> Void
    typealias FetchArguments = (cursor: String?, limit: Int)
    typealias LoaderBlockType = (FetchArguments, MappingBlockType) -> Void
    
    private lazy var loaders: [String: LoaderBlockType] = {
        
        var items = [String: LoaderBlockType]()
        
        items["\(Activity.PendingRequestItem.self)"] = { (args, completion: MappingBlockType) in
            
            self.service.loadPendings(cursor: args.cursor, limit: args.limit) { response in
                completion(.success(response))
            }
        }
        
        items["\(Activity.ActionItem.self)"] = { (args, completion: MappingBlockType) in
            
            self.service.loadActions(
                cursor: args.cursor,
                limit: args.limit,
                completion: { (response: Result<ActivityView>) in
                    completion(Result(value: response.value, error: response.error))
            })
            
        }
      
        return items
        
    }()
    
    private lazy var mappers: [String : ((Any) -> Any?)] = {
        
        return [
            String(describing: Activity.PendingRequestItem.self): {
                
                guard let name = $0 as? String else { return nil }
                
                return Activity.PendingRequestItem(userName: name, userHandle: name)
            },
            String(describing: Activity.ActionItem.self): {
                
                guard let argument = $0 as? ActivityView else { return nil }
                
                return Activity.ActionItem(with: argument)
            }
        ]
        
    }()
    
    private func map<T>(source: Any) -> T? {
        
        let key = String(describing: T.self)
        
        if let mapper = mappers[key], let value = mapper(source) as? T {
            return value
        } else {
            return nil
        }
    }
}


