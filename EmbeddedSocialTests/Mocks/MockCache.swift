//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

@testable import EmbeddedSocial

class MockCache: CacheType {
    
    //MARK: - cacheIncoming<T: Cacheable>
    
    var cacheIncoming_Called = false
    var cacheIncoming_ReceivedItem: Cacheable?
    
    func cacheIncoming<T: Cacheable>(_ item: T) {
        cacheIncoming_Called = true
        cacheIncoming_ReceivedItem = item
    }
    
    //MARK: - cacheOutgoing<T: Cacheable>
    
    var cacheOutgoing_Called = false
    var cacheOutgoing_ReceivedItem: Cacheable?
    
    func cacheOutgoing<T: Cacheable>(_ item: T) {
        cacheOutgoing_Called = true
        cacheOutgoing_ReceivedItem = item
    }
    
    //MARK: - firstIncoming<T: Cacheable>
    
    var firstIncoming_ofType_handle_Called = false
    var firstIncoming_ofType_handle_ReceivedArguments: (type: Cacheable.Type, handle: String)?
    var firstIncoming_ofType_handle_ReturnValue: Cacheable?
    
    func firstIncoming<T: Cacheable>(ofType type: T.Type, handle: String) -> T? {
        firstIncoming_ofType_handle_Called = true
        firstIncoming_ofType_handle_ReceivedArguments = (type: type, handle: handle)
        return firstIncoming_ofType_handle_ReturnValue as? T
    }
    
    //MARK: - firstIncoming<T: Cacheable>
    
    var firstIncoming_ofType_relatedHandle_Called = false
    var firstIncoming_ofType_relatedHandle_ReceivedArguments: (type: Cacheable.Type, relatedHandle: String)?
    var firstIncoming_ofType_relatedHandle_ReturnValue: Cacheable?
    
    func firstIncoming<T: Cacheable>(ofType type: T.Type, relatedHandle: String) -> T? {
        firstIncoming_ofType_relatedHandle_Called = true
        firstIncoming_ofType_relatedHandle_ReceivedArguments = (type: type, relatedHandle: relatedHandle)
        return firstIncoming_ofType_relatedHandle_ReturnValue as? T
    }
    
    //MARK: - firstIncoming<T: Cacheable>
    
    var firstIncoming_ofType_predicate_sortDescriptors_Called = false
    var firstIncoming_ofType_predicate_sortDescriptors_ReceivedArguments: (type: Cacheable.Type, predicate: NSPredicate, sortDescriptors: [NSSortDescriptor])?
    var firstIncoming_ofType_predicate_sortDescriptors_ReturnValue: Cacheable?
    
    func firstIncoming<T: Cacheable>(ofType type: T.Type, predicate: NSPredicate, sortDescriptors: [NSSortDescriptor]) -> T? {
        firstIncoming_ofType_predicate_sortDescriptors_Called = true
        firstIncoming_ofType_predicate_sortDescriptors_ReceivedArguments = (type: type, predicate: predicate, sortDescriptors: sortDescriptors)
        return firstIncoming_ofType_predicate_sortDescriptors_ReturnValue as? T
    }
    
    //MARK: - firstOutgoing<T: Cacheable>
    
    var firstOutgoing_ofType_handle_Called = false
    var firstOutgoing_ofType_handle_ReceivedArguments: (type: Cacheable.Type, handle: String)?
    var firstOutgoing_ofType_handle_ReturnValue: Cacheable?
    
    func firstOutgoing<T: Cacheable>(ofType type: T.Type, handle: String) -> T? {
        firstOutgoing_ofType_handle_Called = true
        firstOutgoing_ofType_handle_ReceivedArguments = (type: type, handle: handle)
        return firstOutgoing_ofType_handle_ReturnValue as? T
    }
    
    //MARK: - firstOutgoing<T: Cacheable>
    
    var firstOutgoing_ofType_relatedHandle_Called = false
    var firstOutgoing_ofType_relatedHandle_ReceivedArguments: (type: Cacheable.Type, relatedHandle: String)?
    var firstOutgoing_ofType_relatedHandle_ReturnValue: Cacheable?
    
    func firstOutgoing<T: Cacheable>(ofType type: T.Type, relatedHandle: String) -> T? {
        firstOutgoing_ofType_relatedHandle_Called = true
        firstOutgoing_ofType_relatedHandle_ReceivedArguments = (type: type, relatedHandle: relatedHandle)
        return firstOutgoing_ofType_relatedHandle_ReturnValue as? T
    }
    
    //MARK: - firstOutgoing<T: Cacheable>
    
    var firstOutgoing_ofType_predicate_sortDescriptors_Called = false
    var firstOutgoing_ofType_predicate_sortDescriptors_ReceivedArguments: (type: Cacheable.Type, predicate: NSPredicate, sortDescriptors: [NSSortDescriptor])?
    var firstOutgoing_ofType_predicate_sortDescriptors_ReturnValue: Cacheable?
    
    func firstOutgoing<T: Cacheable>(ofType type: T.Type, predicate: NSPredicate, sortDescriptors: [NSSortDescriptor]) -> T? {
        firstOutgoing_ofType_predicate_sortDescriptors_Called = true
        firstOutgoing_ofType_predicate_sortDescriptors_ReceivedArguments = (type: type, predicate: predicate, sortDescriptors: sortDescriptors)
        return firstOutgoing_ofType_predicate_sortDescriptors_ReturnValue as? T
    }
    
    //MARK: - fetchIncoming<T: Cacheable>
    
    var fetchIncoming_type_sortDescriptors_Called = false
    var fetchIncoming_type_sortDescriptors_ReceivedArguments: (type: Cacheable.Type, sortDescriptors: [NSSortDescriptor]?)?
    var fetchIncoming_type_sortDescriptors_ReturnValue: [Cacheable] = []
    
    func fetchIncoming<T: Cacheable>(type: T.Type, sortDescriptors: [NSSortDescriptor]?) -> [T] {
        fetchIncoming_type_sortDescriptors_Called = true
        fetchIncoming_type_sortDescriptors_ReceivedArguments = (type: type, sortDescriptors: sortDescriptors)
        return fetchIncoming_type_sortDescriptors_ReturnValue as! [T]
    }
    
    //MARK: - fetchIncoming<T: Cacheable>
    
    var fetchIncoming_type_predicate_sortDescriptors_Called = false
    var fetchIncoming_type_predicate_sortDescriptors_ReceivedArguments: (type: Cacheable.Type, predicate: NSPredicate, sortDescriptors: [NSSortDescriptor]?)?
    var fetchIncoming_type_predicate_sortDescriptors_ReturnValue: [Cacheable] = []
    
    func fetchIncoming<T: Cacheable>(type: T.Type, predicate: NSPredicate, sortDescriptors: [NSSortDescriptor]?) -> [T] {
        fetchIncoming_type_predicate_sortDescriptors_Called = true
        fetchIncoming_type_predicate_sortDescriptors_ReceivedArguments = (type: type, predicate: predicate, sortDescriptors: sortDescriptors)
        return fetchIncoming_type_predicate_sortDescriptors_ReturnValue as! [T]
    }
    
    //MARK: - fetchIncoming<T: Cacheable>
    
    var fetchIncoming_type_sortDescriptors_result_Called = false
    var fetchIncoming_type_sortDescriptors_result_ReceivedArguments: (type: Cacheable.Type, sortDescriptors: [NSSortDescriptor]?)?
    var fetchIncoming_type_sortDescriptors_result_ReturnValue: [Cacheable] = []

    func fetchIncoming<T: Cacheable>(type: T.Type, sortDescriptors: [NSSortDescriptor]?, result: @escaping FetchResult<T>) {
        fetchIncoming_type_sortDescriptors_result_Called = true
        fetchIncoming_type_sortDescriptors_result_ReceivedArguments = (type: type, sortDescriptors: sortDescriptors)
        result(fetchIncoming_type_sortDescriptors_result_ReturnValue as! [T])
    }
    
    //MARK: - fetchIncoming<T: Cacheable>
    
    var fetchIncoming_type_predicate_sortDescriptors_result_Called = false
    var fetchIncoming_type_predicate_sortDescriptors_result_ReceivedArguments: (type: Cacheable.Type, predicate: NSPredicate, sortDescriptors: [NSSortDescriptor]?)?
    var fetchIncoming_type_predicate_sortDescriptors_result_ReturnValue: [Cacheable] = []

    func fetchIncoming<T: Cacheable>(type: T.Type, predicate: NSPredicate,
                       sortDescriptors: [NSSortDescriptor]?, result: @escaping FetchResult<T>) {
        fetchIncoming_type_predicate_sortDescriptors_result_Called = true
        fetchIncoming_type_predicate_sortDescriptors_result_ReceivedArguments =
            (type: type, predicate: predicate, sortDescriptors: sortDescriptors)
        result(fetchIncoming_type_predicate_sortDescriptors_result_ReturnValue as! [T])
    }
    
    //MARK: - fetchOutgoing<T: Cacheable>
    
    var fetchOutgoing_type_sortDescriptors_Called = false
    var fetchOutgoing_type_sortDescriptors_ReceivedArguments: (type: Cacheable.Type, sortDescriptors: [NSSortDescriptor]?)?
    var fetchOutgoing_type_sortDescriptors_ReturnValue: [Cacheable]!
    
    func fetchOutgoing<T: Cacheable>(type: T.Type, sortDescriptors: [NSSortDescriptor]?) -> [T] {
        fetchOutgoing_type_sortDescriptors_Called = true
        fetchOutgoing_type_sortDescriptors_ReceivedArguments = (type: type, sortDescriptors: sortDescriptors)
        return fetchOutgoing_type_sortDescriptors_ReturnValue as! [T]
    }
    
    //MARK: - fetchOutgoing<T: Cacheable>
    
    var fetchOutgoing_type_predicate_sortDescriptors_Called = false
    var fetchOutgoing_type_predicate_sortDescriptors_ReceivedArguments: (type: Cacheable.Type, predicate: NSPredicate, sortDescriptors: [NSSortDescriptor]?)?
    var fetchOutgoing_type_predicate_sortDescriptors_ReturnValue: [Cacheable]!
    
    func fetchOutgoing<T: Cacheable>(type: T.Type, predicate: NSPredicate, sortDescriptors: [NSSortDescriptor]?) -> [T] {
        fetchOutgoing_type_predicate_sortDescriptors_Called = true
        fetchOutgoing_type_predicate_sortDescriptors_ReceivedArguments = (type: type, predicate: predicate, sortDescriptors: sortDescriptors)
        return fetchOutgoing_type_predicate_sortDescriptors_ReturnValue as! [T]
    }
    
    //MARK: - fetchOutgoing<T: Cacheable>
    
    var fetchOutgoing_type_sortDescriptors_result_Called = false
    var fetchOutgoing_type_sortDescriptors_result_ReceivedArguments: (type: Cacheable.Type, sortDescriptors: [NSSortDescriptor]?)?
    var fetchOutgoing_type_sortDescriptors_result_ReturnValue: [Cacheable]!
    
    func fetchOutgoing<T: Cacheable>(type: T.Type, sortDescriptors: [NSSortDescriptor]?, result: @escaping FetchResult<T>) {
        fetchOutgoing_type_sortDescriptors_result_Called = true
        fetchOutgoing_type_sortDescriptors_result_ReceivedArguments = (type: type, sortDescriptors: sortDescriptors)
        result(fetchOutgoing_type_sortDescriptors_result_ReturnValue as! [T])
    }
    
    //MARK: - fetchOutgoing<T: Cacheable>
    
    var fetchOutgoing_type_predicate_sortDescriptors_result_Called = false
    var fetchOutgoing_type_predicate_sortDescriptors_result_ReceivedArguments: (type: Cacheable.Type, predicate: NSPredicate, sortDescriptors: [NSSortDescriptor]?)?
    var fetchOutgoing_type_predicate_sortDescriptors_result_ReturnValue: [Cacheable]!
    
    func fetchOutgoing<T: Cacheable>(type: T.Type, predicate: NSPredicate,
                       sortDescriptors: [NSSortDescriptor]?, result: @escaping FetchResult<T>) {
        fetchOutgoing_type_predicate_sortDescriptors_result_Called = true
        fetchOutgoing_type_predicate_sortDescriptors_result_ReceivedArguments = (type: type, predicate: predicate, sortDescriptors: sortDescriptors)
        result(fetchOutgoing_type_predicate_sortDescriptors_result_ReturnValue as! [T])
    }
    
}

