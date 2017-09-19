//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

protocol ActivityInteractorOutput: class {
    
}

protocol ActivityInteractorInput {
    func load<T>(cursor: String?, limit: Int, handler: ((ItemFetchResult<T>) -> Void))
}

protocol ActivityServiceProtocol: class {
//    func loadPendingsRequests(cursor: String?, limit: Int, completion: (String) -> Void)
    func loadActions(cursor: String?, limit: Int, completion: (Result<FeedResponseActivityView>) -> Void)
}

class ActivityService: ActivityServiceProtocol {
//    func loadPendingsRequests(cursor: String?, limit: Int, completion: (Result<FeedResponseUserCompactView>) -> Void) {
//        completion("lol")
//    }
    
    func loadActions(cursor: String?, limit: Int, completion: (Result<FeedResponseActivityView>) -> Void) {
       
    }
    
}

struct ItemFetchResult<T> {
    var items: [T]?
    var cursor: String?
    var error: ModuleError?
    
    init(items: [T]? = nil, cursor: String? = nil, error: ModuleError? = nil) {
        self.items = items ?? []
        self.cursor = cursor
        self.error = error
    }
}

class ActivityInteractor: ActivityInteractorInput {
    
    weak var output: ActivityInteractorOutput!
    var service: ActivityServiceProtocol!
    
    typealias Section = PaggedSection<ActivityItem>
    
    func load<T>(cursor: String? = nil, limit: Int = 10, handler: ((ItemFetchResult<T>) -> Void)) {
        
        let key = String(describing: T.self)
        
        // get loader
        guard let loader = loaders[key] else {
            handler(ItemFetchResult(error: ModuleError.loaderNotFound))
            return
        }
        
        //
        let args: FetchArguments = (cursor, limit)
        
        // load
        loader(args) { (result: Result<Any>)  in
            
            guard let data = result.value else {
                handler(ItemFetchResult(error: ModuleError.noData))
                return
            }
            
            // map the loaded data
            if let result: ItemFetchResult<T> = self.map(source: data) {
                handler(result)
            } else {
                handler(ItemFetchResult(error: ModuleError.mapperNotFound))
            }
        }
    }
    
    typealias MappingBlockType = (Result<Any>) -> Void
    typealias FetchArguments = (cursor: String?, limit: Int)
    typealias LoaderBlockType = (FetchArguments, MappingBlockType) -> Void
    

    private lazy var loaders: [String: LoaderBlockType] = {
        
        var items = [String: LoaderBlockType]()
        
        items["\(PendingRequestItem.self)"] = { (args, completion: MappingBlockType) in
            
//            self.service.loadPendings(cursor: args.cursor, limit: args.limit) { response in
//                completion(.success(response))
//            }
        }
        
        items["\(ActionItem.self)"] = { (args, completion: MappingBlockType) in
            
            self.service.loadActions(
                cursor: args.cursor,
                limit: args.limit,
                completion: { (response: Result<FeedResponseActivityView>) in
                    completion(Result(value: response.value, error: response.error))
            })
            
        }
      
        return items
        
    }()
    
    private lazy var mappers: [String : ((Any) -> Any?)] = {
        
        return [
            "\(PendingRequestItem.self)": {
                
                guard let response = $0 as? String else { return nil }
                
                return PendingRequestItem(userName: response, userHandle: response)
            },
            
            "\(ActionItem.self)": {
                
                guard let response = $0 as? FeedResponseActivityView else { return nil }
                
                let items = response.data?.map { ActionItem(with: $0) }
                let cursor = response.cursor
                
                return ItemFetchResult(items: items, cursor: cursor)
            }
        ]
        
    }()
    
    private func map<T>(source: Any) -> ItemFetchResult<T> {
        
        let key = String(describing: T.self)
        
        if let mapper = mappers[key], let value = mapper(source)? as ItemFetchResult<T> {
            return value
        } else {
            return ItemFetchResult(error: ModuleError.mapperNotFound)
        }
    }
}


