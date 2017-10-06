//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

class PaginatedListProcessor<ListItem>: AbstractPaginatedListProcessor<ListItem> {
    typealias Page = ListPage<ListItem>
    typealias API = ListAPI<ListItem>
    
    override var isLoadingList: Bool {
        didSet {
            delegate?.didUpdateListLoadingState(isLoadingList)
        }
    }
    
    override var listHasMoreItems: Bool {
        return cursor != nil
    }
    
    private var api: API
    private let networkTracker: NetworkStatusMulticast
    private let pageSize: Int
    private var pages: [Page] = []
    private var pendingPages: Set<String> = Set()
    
    private var allItems: [ListItem] {
        return pages.flatMap { $0.response.items }
    }
    
    private var cursor: String?
    
    private let queue = DispatchQueue(label: "PaginatedListProcessor-queue")
    
    init(api: API,
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
        
        api.getPage(cursor: cursor, limit: pageSize, skipCache: skipCache) { [weak self] result in
            guard let strongSelf = self, strongSelf.pendingPages.contains(pageID) else {
                return
            }
            
            if let response = result.value {
                let page = Page(uid: pageID, response: response)
                strongSelf.addUniquePage(page)
                strongSelf.cursor = response.cursor
                completion(.success(strongSelf.allItems))
            } else {
                completion(.failure(result.error ?? APIError.unknown))
            }
            
            strongSelf.isLoadingList = false
        }
    }
    
    override func setAPI(_ api: API) {
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
