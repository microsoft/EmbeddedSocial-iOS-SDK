//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest
@testable import EmbeddedSocial

class CreatePostPresentorTests: XCTestCase {
    
    let presentor = CreatePostPresenter()
    let interactor = MockCreatePostInteractor()
    let view = MockCreatePostViewController()
    let user =  User(uid: "test", firstName: "First name", lastName: "Last name", email: "email@test.com", bio: nil, photo: nil, credentials: CredentialsList(provider: AuthProvider(rawValue: 0)!, accessToken: "token", socialUID: "uid"))
    
    override func setUp() {
        super.setUp()
        presentor.interactor = interactor
        presentor.user = user
        view.output = presentor
        presentor.view = view
    }
    
    override func tearDown() {
        super.tearDown()
        presentor.interactor = nil
        presentor.view = nil
    }
    
    func testThatPostInInteractorCalled() {
        let photo = Photo(uid: "test", url: nil, image: UIImage())
        let title = "Title"
        let body = "body"
        
        presentor.post(photo: photo, title: title, body: body)
        XCTAssertEqual(title, interactor.title, "should save in interactor")
        XCTAssertEqual(body, interactor.body, "should save in interactor")
        XCTAssertEqual(photo, interactor.photo, "should save in interactor")
        XCTAssertEqual(interactor.postTopicCalledCount, 1)
    }
    
    func testThatViewShowedError() {
        let error = TestError()
        presentor.postCreationFailed(error: error)
        
        XCTAssertEqual(view.errorShowedCount, 1)
    }
    
    func testThatUserShowedCorrect() {
        view.show(user: user)

        XCTAssertEqual(view.userShowedCount, 1)
    }
    
    
}


class TestError: Error {
    let name = "Error"
}
