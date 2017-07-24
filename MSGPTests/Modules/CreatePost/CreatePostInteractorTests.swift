//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest
@testable import MSGP

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
