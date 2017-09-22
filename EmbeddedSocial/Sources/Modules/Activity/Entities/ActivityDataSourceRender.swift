//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

protocol DataSourceProtocol {
    func loadMore()
    var section: Section { get }
    var delegate: DataSourceDelegate? { get }
    var index: Int { get }
}

protocol DataSourceDelegate {
    func didFail(error: Error)
    func didLoad(indexPaths: [IndexPath])
}

class DataSourceBuilder {
    static func buildPendingRequestsDataSource(interactor: ActivityInteractorInput,
                                               index: Int,
                                               delegate: DataSourceDelegate) -> MyPendingRequests {
        let header = SectionHeader(name: "Pending requests", identifier: "")
        let section = Section(model: header, items: [])
        
        return MyPendingRequests(interactor: interactor,
                                 section:section,
                                 delegate: delegate,
                                 index: index)
    }
    
    static func buildMyFollowingsActivityDataSource(interactor: ActivityInteractorInput,
                                                    index: Int,
                                                    delegate: DataSourceDelegate) -> MyFollowingsActivity {
        let header = SectionHeader(name: "My followings activity", identifier: "")
        let section = Section(model: header, items: [])
        
        return MyFollowingsActivity(interactor: interactor,
                                    section: section,
                                    delegate: delegate,
                                    index: index)
    }
}

class DataSource: DataSourceProtocol {
    weak var interactor: ActivityInteractorInput!
    var section: Section
    var delegate: DataSourceDelegate?
    var index: Int
    
    func loadMore() { }
    
    init(interactor: ActivityInteractorInput,
         section: Section,
         delegate: DataSourceDelegate? = nil,
         index: Int) {
        
        self.interactor = interactor
        self.section = section
        self.delegate = delegate
        self.index = index
    }
    
    func insertedIndexes(newItemsCount: Int) -> [IndexPath] {
        // make paths for inserted items
        let range = (section.items.count - newItemsCount)..<section.items.count
        let indexPaths = range.map { IndexPath(row: $0, section: index) }
        return indexPaths
    }
}

class MyPendingRequests: DataSource {
    
    override func loadMore() {
        
        // load pendings
        interactor.loadNextPagePendigRequestItems { [weak self] (result) in
            
            guard let strongSelf = self else { return }
            
            switch result {
            case let .failure(error):
                strongSelf.delegate?.didFail(error: error)
            case let .success(models):
                let items = models.map { ActivityItem.pendingRequest($0) }
                strongSelf.section.items.append(contentsOf: items)
                
                // make paths for inserted items
                let indexPaths = strongSelf.insertedIndexes(newItemsCount: items.count)
                strongSelf.delegate?.didLoad(indexPaths: indexPaths)
            }
        }
    }
    
}

class MyFollowingsActivity: DataSource {
    
    override func loadMore() {
        // load activity
        interactor.loadNextPageFollowingActivities {  [weak self] (result) in
            
            guard let strongSelf = self else { return }
            
            switch result {
            case let .failure(error):
                strongSelf.delegate?.didFail(error: error)
            case let .success(models):
                let items = models.map { ActivityItem.myActivity($0) }
                strongSelf.section.items.append(contentsOf: items)
                
                // make paths for inserted items
                let indexPaths = strongSelf.insertedIndexes(newItemsCount: items.count)
                strongSelf.delegate?.didLoad(indexPaths: indexPaths)
            }
        }
    }
}

class MyFollowersActivity: DataSource {
    
    override func loadMore() {
        
    }
}
