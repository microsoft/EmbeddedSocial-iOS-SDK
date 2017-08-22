//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

@testable import EmbeddedSocial

class MockFeedModuleInput: FeedModuleInput {
    private(set) var setFeedCount = 0
    private(set) var feedType: FeedType?
    private(set) var refreshDataCount = 0
    private(set) var registerHeaderCount = 0
    private(set) var setLayoutCount = 0

    var layout = FeedModuleLayoutType.grid {
        didSet {
            setLayoutCount += 1
        }
    }
    
    func setFeed(_ feed: FeedType) {
        feedType = feed
        setFeedCount += 1
    }
    
    func refreshData() {
        refreshDataCount += 1
    }
    
    func registerHeader<T: UICollectionReusableView>(withType type: T.Type,
                        size: CGSize,
                        configurator: @escaping (T) -> Void) {
        registerHeaderCount += 1
    }
    
    func moduleHeight() -> CGFloat {
        return 0.0
    }
}
