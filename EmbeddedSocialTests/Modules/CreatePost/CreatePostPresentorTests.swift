//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest
@testable import EmbeddedSocial

class CreatePostPresentorTests: XCTestCase {
    
    let presenter = CreatePostPresenter()
    let interactor = MockCreatePostInteractor()
    let view = MockCreatePostViewController()
    let user =  User(uid: "test", firstName: "First name", lastName: "Last name", email: "email@test.com", bio: nil, photo: nil, credentials: CredentialsList(provider: AuthProvider(rawValue: 0)!, accessToken: "token", socialUID: "uid"))
    
    override func setUp() {
        super.setUp()
        presenter.interactor = interactor
        presenter.user = user
        view.output = presentor
        presenter.view = view
        interactor.output = presenter
    }
    
    override func tearDown() {
        super.tearDown()
        presenter.interactor = nil
        presenter.view = nil
        presenter.post = nil
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
        XCTAssertEqual(view.topicCreatedCount, 1)
    }
    
    func testThatViewShowedError() {
        let error = TestError()
        presenter.postCreationFailed(error: error)
        
        XCTAssertEqual(view.errorShowedCount, 1)
    }
    
    func testThatUserShowedCorrect() {
        view.show(user: user)

        XCTAssertEqual(view.userShowedCount, 1)
    }
    
    func testThatPostIsUpdating() {
        
        //given
        var post = Post()
        post.topicHandle = "handle"
        presenter.post = post
        
        //when
        presenter.post(photo: nil, title: "title", body: "test")
        
        //then
        XCTAssertEqual(interactor.updateTopicCount, 1)
        XCTAssertEqual(view.topicUpdatedCount, 1)
    }
    
    
}


class TestError: Error {
    let name = "Error"
}
