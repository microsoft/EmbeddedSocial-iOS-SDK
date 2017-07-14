//
//  MenuStackMenuStackPresenterTests.swift
//  MSGP-Framework
//
//  Created by igor.popov on 12/07/2017.
//  Copyright © 2017 akvelon. All rights reserved.
//

import XCTest

class MenuStackPresenterTest: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    class MockInteractor: MenuStackInteractorInput {

    }

    class MockRouter: MenuStackRouterInput {

    }

    class MockViewController: MenuStackViewInput {

        func setupInitialState() {

        }
    }
}
