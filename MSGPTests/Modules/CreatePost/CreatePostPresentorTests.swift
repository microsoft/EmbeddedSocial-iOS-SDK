//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest
@testable import MSGP

class CreatePostPresentorTests: XCTestCase {
    
    let presentor = CreatePostPresenter()
    let interactor = MockCreatePostInteractor()
    let view = MockCreatePostViewController()
    
    override func setUp() {
        super.setUp()
        presentor.interactor = interactor
        presentor.view = view
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testThatPostInInteractorCalled() {
        let image = UIImage()
        let title = "Title"
        let body = "body"
        
        presentor.post(image: nil, title: title, body: body)
        XCTAssertEqual(title, interactor.title, "should save in interactor")
        XCTAssertEqual(body, interactor.body, "should save in interactor")
        XCTAssertEqual(image, interactor.image, "should save in interactor")
    }
    
    func testThatViewShowedError() {
        let error = TestError()
        presentor.postCreationFailed(error: error)
        
        XCTAssert(view.errorWasShowed, "should show error")
    }
    
    func testThatUIConfigsCorrect() {
        presentor.viewIsReady()
        view.setupInitialState()
        XCTAssertEqual(view.title, Titles.addPost)
        XCTAssertNil(view.navigationItem.leftBarButtonItem)
        XCTAssertNil(view.navigationItem.rightBarButtonItem)
    }
    
}


class TestError: Error {
    let name = "Error"
}
