//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

protocol UsersListProcessorDelegate: class {
    func didUpdateListLoadingState(_ isLoading: Bool)
}

protocol UsersListProcessorType {
    var isLoadingList: Bool { get }
    
    var listHasMoreItems: Bool { get }
    
    weak var delegate: UsersListProcessorDelegate? { get set }
    
    func getNextListPage(completion: @escaping (Result<[User]>) -> Void)
    
    func setAPI(_ api: UsersListAPI)
    
    func reloadList(completion: @escaping (Result<[User]>) -> Void)
}

class UsersListProcessor: UsersListProcessorType {
    typealias ListState = PaginatedResponse<User, String>
    
    weak var delegate: UsersListProcessorDelegate?
    
    private var api: UsersListAPI
    private var pages: [UsersListPage] = []
    private var pendingPages: Set<String> = Set()
    
    var isLoadingList = false {
        didSet {
            delegate?.didUpdateListLoadingState(isLoadingList)
        }
    }
    
    private let queue = DispatchQueue(label: "UsersListProcessor-queue")
    
    private var listState: ListState {
        let lastCursor = pages.last?.response.cursor
        let users = pages.flatMap { $0.response.users }
        return ListState(items: users, hasMore: lastCursor != nil, error: nil, cursor: lastCursor)
    }
    
    var listHasMoreItems: Bool {
        return listState.hasMore
    }
    
    private let networkTracker: NetworkStatusMulticast
    
    init(api: UsersListAPI, networkTracker: NetworkStatusMulticast = SocialPlus.shared.networkTracker) {
        self.api = api
        self.networkTracker = networkTracker
    }
    
    func setAPI(_ api: UsersListAPI) {
        self.api = api
        resetLoadingState()
    }
    
    private func resetLoadingState() {
        pages = []
        isLoadingList = false
        pendingPages = Set()
    }
    
    func reloadList(completion: @escaping (Result<[User]>) -> Void) {
        resetLoadingState()
        getNextListPage(skipCache: networkTracker.isReachable, completion: completion)
    }
    
    func getNextListPage(completion: @escaping (Result<[User]>) -> Void) {
        getNextListPage(skipCache: false, completion: completion)
    }
    
    private func getNextListPage(skipCache: Bool, completion: @escaping (Result<[User]>) -> Void) {
        isLoadingList = true
        
        let pageID = UUID().uuidString
        pendingPages.insert(pageID)
        
        api.getUsersList(
            cursor: listState.cursor,
            limit: Constants.UserList.pageSize,
            skipCache: skipCache) { [weak self] result in
                
                guard let strongSelf = self, strongSelf.pendingPages.contains(pageID) else { return }
                
                if let response = result.value {
                    let page = UsersListPage(uid: pageID, response: response)
                    strongSelf.addUniquePage(page)
                    completion(.success(strongSelf.listState.items))
                } else {
                    completion(.failure(result.error ?? APIError.unknown))
                }
                
                strongSelf.isLoadingList = false
        }
    }
    
    private func addUniquePage(_ page: UsersListPage) {
        queue.sync {
            if let index = pages.index(of: page) {
                pages[index] = page
            } else {
                pages.append(page)
            }
        }
    }
}
