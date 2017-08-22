//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

@testable import EmbeddedSocial

final class MockSearchPeopleView: UIViewController, SearchPeopleViewInput {
    private(set) var setupInitialStateCount = 0
    private(set) var listView: UIView?
    
    func setupInitialState(listView: UIView) {
        self.listView = listView
        setupInitialStateCount += 1
    }
}
