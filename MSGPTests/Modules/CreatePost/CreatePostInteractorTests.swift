//
//  CreatePostInteractorTests.swift
//  MSGP
//
//  Created by Mac User on 17.07.17.
//  Copyright © 2017 Akvelon. All rights reserved.
//

import XCTest
@testable import MSGP
import Cuckoo

class CreatePostInteractorTests: XCTestCase {
    
    let intercator = CreatePostInteractor()
    let presenter = MockCreatePostPresenter()
    
    override func setUp() {
        super.setUp()
        intercator.output = presenter
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testThatDataPosting() {
        let title = "title"
        let body = "body"
        let image = UIImage()
        
        intercator.postTopic(image: image, title: title, body: body)
        XCTAssert(presenter.postCreated)
        XCTAssert(presenter.postCreationFailed == false)
    }
    
}
