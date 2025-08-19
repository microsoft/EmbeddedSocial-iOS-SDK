//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest
@testable import EmbeddedSocial

class MockReplyCellModuleOutput: ReplyCellModuleOutput {
    var showMenuCalled = false
    
    func showMenu(reply: Reply) {
        showMenuCalled = true
    }
    
    var removedCalled = false
    
    func removed(reply: Reply) {
        removedCalled = true
    }
}

class ReplyCellPresenterTests: XCTestCase {
    
    var presenter: ReplyCellPresenter!
    var interactor: MockReplyCellInteractor!
    var view: MockReplyCell!
    var router: MockReplyCellRouter!
    var loginOpener: MockLoginModalOpener!
    var loginParent: UIViewController!
    var actionStrategy: CommonAuthorizedActionStrategy!
    var userHolder: MyProfileHolder!
    var moduleOutput: MockReplyCellModuleOutput!
    
    override func setUp() {
        super.setUp()
        
        interactor = MockReplyCellInteractor()
        view = MockReplyCell()
        router = MockReplyCellRouter()
        interactor.output = presenter
        
        loginOpener = MockLoginModalOpener()
        loginParent = UIViewController()
        userHolder = MyProfileHolder()
        actionStrategy = CommonAuthorizedActionStrategy(myProfileHolder: userHolder, loginParent: loginParent, loginOpener: loginOpener)
        
        moduleOutput = MockReplyCellModuleOutput()
        
        presenter = ReplyCellPresenter(actionStrategy: actionStrategy)
        presenter.router = router
        presenter.view = view
        presenter.interactor = interactor
        let mockUserHolder = MyProfileHolder()
        presenter.myProfileHolder = mockUserHolder
        presenter.moduleOutput = moduleOutput

        presenter.reply = Reply(replyHandle: UUID().uuidString)
        presenter.reply.userHandle = mockUserHolder.me?.uid
    }
    
    override func tearDown() {
        super.tearDown()
        presenter.reply = nil
        presenter.myProfileHolder = nil
        presenter = nil
        interactor = nil
        view = nil
        router = nil
        loginOpener = nil
        loginParent = nil
        userHolder = nil
        actionStrategy = nil
        moduleOutput = nil
    }
    
    func testThatLiked() {
        presenter.like()
        
        XCTAssertEqual(presenter.reply.liked, true)
        
        presenter.like()
        
        XCTAssertEqual(presenter.reply.liked, false)
    }
    
    func testThatOpenLikes() {
        presenter.likesPressed()
        
        XCTAssertEqual(router.openLikesCount, 1)
    }
    
    func testThatOpenOptions() {
        presenter.optionsPressed()
        XCTAssertTrue(moduleOutput.showMenuCalled)
    }
    
    func testThatOpenUser() {
        presenter.avatarPressed()
        
        XCTAssertEqual(router.openUserCount, 1)
    }
    
    
}
