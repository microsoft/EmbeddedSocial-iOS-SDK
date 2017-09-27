//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

@testable import EmbeddedSocial

class MockFeedModuleInput: FeedModuleInput {
    
    private(set) var setFeedCount = 0
    
    var feedType: FeedType? {
        didSet {
            setFeedCount += 1
        }
    }
    
    private(set) var setLayoutCount = 0

    var layout = FeedModuleLayoutType.grid {
        didSet {
            setLayoutCount += 1
        }
    }
    
    var isEmpty = false
    
    private(set) var refreshDataCount = 0

    func refreshData() {
        refreshDataCount += 1
    }
    
    private(set) var registerHeaderCount = 0
    
    func registerHeader<T: UICollectionReusableView>(withType type: T.Type,
                        size: CGSize,
                        configurator: @escaping (T) -> Void) {
        registerHeaderCount += 1
    }
    
    func moduleHeight() -> CGFloat {
        return 0.0
    }
    
    private(set) var setHeaderHeightCount = 0
    private(set) var headerHeight: CGFloat?

    func setHeaderHeight(_ height: CGFloat) {
        headerHeight = height
        setHeaderHeightCount += 1
    }
    
    private(set) var lockScrollingCount = 0
    func lockScrolling() {
        lockScrollingCount += 1
    }
}
