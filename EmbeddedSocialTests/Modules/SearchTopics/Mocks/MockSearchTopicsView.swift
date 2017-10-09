//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import UIKit
@testable import EmbeddedSocial

class MockSearchTopicsView: SearchTopicsViewInput {
    
    //MARK: - setupInitialState
    
    var setupInitialStateWithCalled = false
    var setupInitialStateWithReceivedFeedViewController: UIViewController?
    
    func setupInitialState(with feedViewController: UIViewController) {
        setupInitialStateWithCalled = true
        setupInitialStateWithReceivedFeedViewController = feedViewController
    }
    
    //MARK: - setIsEmpty
    
    var setIsEmptyCalled = false
    var setIsEmptyReceivedIsEmpty: Bool?
    
    func setIsEmpty(_ isEmpty: Bool) {
        setIsEmptyCalled = true
        setIsEmptyReceivedIsEmpty = isEmpty
    }
    
}
