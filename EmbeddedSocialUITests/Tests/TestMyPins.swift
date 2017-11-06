//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest

class TestMyPinsOnline: TestOnlineHome {
    
    override func setUp() {
        super.setUp()
        
        feedName = "pins"
        serviceName = "pins"
    }
    
    override func openScreen() {
        navigate(to: .myPins)
    }
    
    /*
     As all posts on this screen are already pinned:
     "Pin" and "Unpin" actions are reversed and v.v.
     */
    
    override func checkIsPinned(_ post: PostItem, at index: UInt) {
        super.checkIsUnpinned(post, at: index)
    }
    
    override func checkIsUnpinned(_ post: PostItem, at index: UInt) {
        super.checkIsPinned(post, at: index)
    }
    
}

class TestMyPinsOffline: TestOfflineHome {
    
    override func setUp() {
        super.setUp()
        
        feedName = "pins"
        serviceName = "pins"
    }
    
    override func openScreen() {
        navigate(to: .myPins)
    }
    
    /*
     As all posts on this screen are already pinned:
     "Pin" and "Unpin" actions are reversed and v.v.
     */
    
    override func checkIsPinned(_ post: PostItem, at index: UInt) {
        super.checkIsUnpinned(post, at: index)
    }
    
    override func checkIsUnpinned(_ post: PostItem, at index: UInt) {
        super.checkIsPinned(post, at: index)
    }
    
}
