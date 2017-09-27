//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

@testable import EmbeddedSocial
import XCTest

class MockCache: CacheType {
    
    //MARK: - cacheIncoming
    
    var cacheIncoming_typeID_Called = false
    var cacheIncoming_typeID_ReceivedArguments: (item: Cacheable, typeID: String)?
    
    func cacheIncoming(_ item: Cacheable, for typeID: String) {
        cacheIncoming_typeID_Called = true
        cacheIncoming_typeID_ReceivedArguments = (item: item, typeID: typeID)
    }
    
    //MARK: - firstIncoming<Item: Cacheable>

    var firstIncoming_ofType_handle_Called = false
    var firstIncoming_ofType_handle_ReceivedArguments: (type: Cacheable.Type, handle: String)?
    var firstIncoming_ofType_handle_ReturnValue: Cacheable?
    
    func firstIncoming<Item: Cacheable>(ofType type: Item.Type, handle: String) -> Item? {
        firstIncoming_ofType_handle_Called = true
        firstIncoming_ofType_handle_ReceivedArguments = (type: type, handle: handle)
        return firstIncoming_ofType_handle_ReturnValue as? Item
    }
    
    //MARK: - firstIncoming<Item: Cacheable>
    
    var firstIncoming_ofType_typeID_Called = false
    var firstIncoming_ofType_typeID_ReceivedArguments: (type: Cacheable.Type, typeID: String)?
    var firstIncoming_ofType_typeID_ReturnValue: Cacheable?
    
    func firstIncoming<Item: Cacheable>(ofType type: Item.Type, typeID: String) -> Item? {
        firstIncoming_ofType_typeID_Called = true
        firstIncoming_ofType_typeID_ReceivedArguments = (type: type, typeID: typeID)
        return firstIncoming_ofType_typeID_ReturnValue as? Item
    }
    
    //MARK: - firstIncoming<Item: Cacheable>
    
    var firstIncoming_ofType_predicate_sortDescriptors_Called = false
    var firstIncoming_ofType_predicate_sortDescriptors_ReceivedArguments: (type: Cacheable.Type, predicate: NSPredicate?, sortDescriptors: [NSSortDescriptor]?)?
    var firstIncoming_ofType_predicate_sortDescriptors_ReturnValue: Cacheable?
    
    func firstIncoming<Item: Cacheable>(ofType type: Item.Type, predicate: NSPredicate?, sortDescriptors: [NSSortDescriptor]?) -> Item? {
        firstIncoming_ofType_predicate_sortDescriptors_Called = true
        firstIncoming_ofType_predicate_sortDescriptors_ReceivedArguments = (type: type, predicate: predicate, sortDescriptors: sortDescriptors)
        return firstIncoming_ofType_predicate_sortDescriptors_ReturnValue as? Item
    }
    
    //MARK: - fetchIncoming<Item: Cacheable>
    
    var fetchIncoming_with_Called = false
    var fetchIncoming_with_ReceivedRequest: Any?
    var fetchIncoming_with_ReturnValue: [Cacheable] = []
    
    func fetchIncoming<Item: Cacheable>(with request: CacheFetchRequest<Item>) -> [Item] {
        fetchIncoming_with_Called = true
        fetchIncoming_with_ReceivedRequest = request
        return fetchIncoming_with_ReturnValue as? [Item] ?? []
    }
    
    //MARK: - fetchIncoming<Item: Cacheable>
    
    var fetchIncoming_with_result_Called = false
    var fetchIncoming_with_result_ReceivedRequest: Any?
    var fetchIncoming_with_result_ReturnValue: [Cacheable] = []

    func fetchIncoming<Item: Cacheable>(with request: CacheFetchRequest<Item>, result: @escaping FetchResult<Item>) {
        fetchIncoming_with_result_Called = true
        fetchIncoming_with_result_ReceivedRequest = request
        result(fetchIncoming_with_result_ReturnValue as? [Item] ?? [])
    }
    
    //MARK: - cacheOutgoing
    
    var cacheOutgoing_typeID_Called = false
    var cacheOutgoing_typeID_ReceivedArguments: (item: Cacheable, typeID: String)?
    
    func cacheOutgoing(_ item: Cacheable, for typeID: String) {
        cacheOutgoing_typeID_Called = true
        cacheOutgoing_typeID_ReceivedArguments = (item: item, typeID: typeID)
    }
    
    //MARK: - firstOutgoing<Item: Cacheable>
    
    var firstOutgoing_ofType_predicate_sortDescriptors_Called = false
    var firstOutgoing_ofType_predicate_sortDescriptors_ReceivedArguments: (type: Cacheable.Type, predicate: NSPredicate?, sortDescriptors: [NSSortDescriptor]?)?
    var firstOutgoing_ofType_predicate_sortDescriptors_ReturnValue: Cacheable?
    
    func firstOutgoing<Item: Cacheable>(ofType type: Item.Type, predicate: NSPredicate?, sortDescriptors: [NSSortDescriptor]?) -> Item? {
        firstOutgoing_ofType_predicate_sortDescriptors_Called = true
        firstOutgoing_ofType_predicate_sortDescriptors_ReceivedArguments = (type: type, predicate: predicate, sortDescriptors: sortDescriptors)
        return firstOutgoing_ofType_predicate_sortDescriptors_ReturnValue as? Item
    }
    
    //MARK: - fetchOutgoing<Item: Cacheable>
    
    var fetchOutgoing_with_Called = false
    var fetchOutgoing_with_ReceivedRequest: Any?
    var fetchOutgoing_with_ReturnValue: [Cacheable] = []

    func fetchOutgoing<Item: Cacheable>(with request: CacheFetchRequest<Item>) -> [Item] {
        fetchOutgoing_with_Called = true
        fetchOutgoing_with_ReceivedRequest = request
        return fetchOutgoing_with_ReturnValue as? [Item] ?? []
    }
    
    //MARK: - fetchOutgoing<Item: Cacheable>
    
    var fetchOutgoing_with_result_Called = false
    var fetchOutgoing_with_result_ReceivedRequest: Any?
    var fetchOutgoing_with_result_ReturnValue: [Cacheable] = []
    
    func fetchOutgoing<Item: Cacheable>(with request: CacheFetchRequest<Item>, result: @escaping FetchResult<Item>) {
        fetchOutgoing_with_result_Called = true
        fetchOutgoing_with_ReceivedRequest = request
        result(fetchOutgoing_with_result_ReturnValue as? [Item] ?? [])
    }
    
    //MARK: - deleteIncoming<Item: Cacheable>
    
    var deleteIncoming_with_Called = false
    var deleteIncoming_with_ReceivedPredicate: NSPredicate?
    
    func deleteIncoming(with predicate: NSPredicate) {
        deleteIncoming_with_Called = true
        deleteIncoming_with_ReceivedPredicate = predicate
    }
    
    //MARK: - deleteOutgoing<Item: Cacheable>
    
    var deleteOutgoing_with_Called = false
    var deleteOutgoing_with_ReceivedPredicate: NSPredicate?
    var deleteOutgoing_Expectation = XCTestExpectation()

    func deleteOutgoing(with predicate: NSPredicate) {
        deleteOutgoing_with_Called = true
        deleteOutgoing_with_ReceivedPredicate = predicate
        deleteOutgoing_Expectation.fulfill()
    }
}
