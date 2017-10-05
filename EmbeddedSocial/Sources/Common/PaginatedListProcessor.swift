//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

protocol PaginatedListProcessorDelegate: class {
    func didUpdateListLoadingState(_ isLoading: Bool)
}

protocol PaginatedListAPI {
    func getPage<ListItem>(cursor: String?, limit: Int, completion: @escaping (Result<PaginatedResponse<ListItem>>) -> Void)
}

class AbstractPaginatedListProcessor<ListItem> {
    var isLoadingList = false
    
    var listHasMoreItems: Bool {
        return false
    }
    
    weak var delegate: PaginatedListProcessorDelegate?
    
    func getNextListPage(completion: @escaping (Result<[ListItem]>) -> Void) {
        
    }
    
    func setAPI(_ api: PaginatedListAPI) {
        
    }
    
    func reloadList(completion: @escaping (Result<[ListItem]>) -> Void) {
        
    }
}

class PaginatedListProcessor<ListItem>: AbstractPaginatedListProcessor<ListItem> {
    typealias ListState = PaginatedResponse<ListItem>
    typealias Page = ListPage<ListItem>
    
    override var isLoadingList: Bool {
        didSet {
            delegate?.didUpdateListLoadingState(isLoadingList)
        }
    }
    
    override var listHasMoreItems: Bool {
        return listState.hasMore
    }
    
    private var api: PaginatedListAPI
    private let networkTracker: NetworkStatusMulticast
    private let pageSize: Int
    private var pages: [Page] = []
    private var pendingPages: Set<String> = Set()
    
    private let queue = DispatchQueue(label: "PaginatedListProcessor-queue")
    
    private var listState: ListState {
        let lastCursor = pages.last?.response.cursor
        let items = pages.flatMap { $0.response.items }
        return ListState(items: items, hasMore: lastCursor != nil, error: nil, cursor: lastCursor)
    }
    
    init(api: PaginatedListAPI,
         pageSize: Int,
         networkTracker: NetworkStatusMulticast = SocialPlus.shared.networkTracker) {
        self.api = api
        self.pageSize = pageSize
        self.networkTracker = networkTracker
    }
    
    override func getNextListPage(completion: @escaping (Result<[ListItem]>) -> Void) {
        getNextListPage(skipCache: false, completion: completion)
    }
    
    private func getNextListPage(skipCache: Bool, completion: @escaping (Result<[ListItem]>) -> Void) {
        isLoadingList = true
        
        let pageID = UUID().uuidString
        pendingPages.insert(pageID)
        
        api.getPage(
            cursor: listState.cursor,
            limit: pageSize) { [weak self] (result: Result<ListState>) in
                guard let strongSelf = self, strongSelf.pendingPages.contains(pageID) else {
                    return
                }
                
                if let response = result.value {
                    let page = Page(uid: pageID, response: response)
                    strongSelf.addUniquePage(page)
                    completion(.success(strongSelf.listState.items))
                } else {
                    completion(.failure(result.error ?? APIError.unknown))
                }
                
                strongSelf.isLoadingList = false
        }
    }
    
    override func setAPI(_ api: PaginatedListAPI) {
        self.api = api
        resetLoadingState()
    }
    
    override func reloadList(completion: @escaping (Result<[ListItem]>) -> Void) {
        resetLoadingState()
        getNextListPage(skipCache: networkTracker.isReachable, completion: completion)
    }
    
    private func resetLoadingState() {
        pages = []
        isLoadingList = false
        pendingPages = Set()
    }
    
    private func addUniquePage(_ page: Page) {
        queue.sync {
            if let index = pages.index(of: page) {
                pages[index] = page
            } else {
                pages.append(page)
            }
        }
    }
}
