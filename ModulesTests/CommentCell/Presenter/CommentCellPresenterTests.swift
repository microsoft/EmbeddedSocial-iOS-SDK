//
//  CommentCellCommentCellPresenterTests.swift
//  EmbeddedSocial-Framework
//
//  Created by generamba setup on 01/09/2017.
//  Copyright © 2017 akvelon. All rights reserved.
//

import XCTest

class CommentCellPresenterTest: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    class MockInteractor: CommentCellInteractorInput {

    }

    class MockRouter: CommentCellRouterInput {

    }

    class MockViewController: CommentCellViewInput {

        func setupInitialState() {

        }
    }
}
