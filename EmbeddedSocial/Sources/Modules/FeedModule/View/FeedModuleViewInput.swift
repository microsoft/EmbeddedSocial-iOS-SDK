//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

protocol FeedModuleViewInput: class {

    var feedView: CollectionView? { get }

    func setupInitialState()
    
    func setLayout(type: FeedModuleLayoutType)
    func reload()
    func reload(with index: Int)
    func setRefreshing(state: Bool)
    
}
