//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

protocol FeedModuleInput: class {
    
    var feedView: CollectionView? { get }
    func setFeed(_ feed: FeedType)
    func refreshData()
    
}
