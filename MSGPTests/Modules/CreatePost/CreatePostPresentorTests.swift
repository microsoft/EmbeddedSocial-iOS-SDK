//
//  CreatePostPresentorTests.swift
//  MSGP
//
//  Created by Mac User on 17.07.17.
//  Copyright © 2017 Akvelon. All rights reserved.
//

import XCTest
@testable import MSGP
import Cuckoo

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
