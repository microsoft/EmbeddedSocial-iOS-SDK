//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest
@testable import EmbeddedSocial

class PostDetailsPresenterTests: XCTestCase {
    
    var presenter: PostDetailPresenter!
    let interactor = MockPostDetailsInteractor()
    let view = MockPostDetailViewController()
    let router = MockPostDetailRouter()
    
    var post: PostViewModel!
    
    var myProfileHolder: MyProfileHolder!
    
    override func setUp() {
        super.setUp()
        
        let user = User(uid: "User",
                        firstName: "first name",
                        lastName: "last name",
                        photo: Photo(uid: "photoHandle"),
                        followerStatus: .empty)
        
        var tempPost = Post(topicHandle: "topicHandle")
        tempPost.createdTime = Date()
        tempPost.user = user
        tempPost.title = "ttile"
        
        post = PostViewModel(with: tempPost, cellType: "", actionHandler: { (action, path) in
            
        })
        myProfileHolder = MyProfileHolder()
        presenter = PostDetailPresenter(myProfileHolder: myProfileHolder)
        presenter.interactor = interactor
        presenter.view = view
        presenter.topicHandle = "topicHandle"
        presenter.router = router
        interactor.output = presenter
        view.output = presenter
    }
    
    override func tearDown() {
        super.tearDown()
        post = nil
        presenter.topicHandle = nil
        presenter.interactor = nil
        interactor.output = nil
        presenter.view = nil
        presenter.router = nil
        view.output = nil
        presenter = nil
        myProfileHolder = nil
    }
    
    
    func testThatStateSetup() {
            
        presenter.viewIsReady()
        
        XCTAssertEqual(view.setupCount, 1)
    }
    
    func testThatCommentPosted() {
        
        //given
        let comment = Comment()
        comment.text = "Text"
        let photo = Photo(uid: "testid", url: "Url", image: UIImage())
        
        //when
        presenter.postComment(photo: photo, comment: comment.text!)
        
        //then
        XCTAssertEqual(presenter.comments.count, 1)
        XCTAssertEqual(view.commentPostFailed, 0)
    }
    
    func testThatNumberOfItemsCorrect() {
        
        //given
        presenter.comments = [Comment()]
        
        //when
        
        //then
        XCTAssertEqual(presenter.numberOfItems(), 1)
    }
    
    func testThatFetchMore() {
        
        //given
//        In interactor default fetching 1 element
        
        //when
        presenter.fetchMore()
        
        //then
        XCTAssertEqual(presenter.comments.count, 1)
    }
    
    
}
