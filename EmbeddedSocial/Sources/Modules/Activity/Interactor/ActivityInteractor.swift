//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

struct ActivityItem {
    
}

struct ActivityFeedResult {
    
}

protocol ActivityInteractorOutput: class {
    
    func didFetchAll(result: ActivityFeedResult)
    func didFetchMore(resukt: ActivityFeedResult)
    
}

protocol ActivityInteractorInput {
    
    func fetchAll()
    func fetchMore()
    
}

class ActivityInteractor: ActivityInteractorInput {

    weak var output: ActivityInteractorOutput!
    
    func fetchAll() {
        
    }
    
    func fetchMore() {
        
    }
    

}
