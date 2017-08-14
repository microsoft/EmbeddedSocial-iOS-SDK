//
//  CommentRepliesCommentRepliesConfiguratorTests.swift
//  EmbeddedSocial-Framework
//
//  Created by generamba setup on 14/08/2017.
//  Copyright © 2017 akvelon. All rights reserved.
//

import XCTest

class CommentRepliesModuleConfiguratorTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testConfigureModuleForViewController() {

        //given
        let viewController = CommentRepliesViewControllerMock()
        let configurator = CommentRepliesModuleConfigurator()

        //when
        configurator.configureModuleForViewInput(viewInput: viewController)

        //then
        XCTAssertNotNil(viewController.output, "CommentRepliesViewController is nil after configuration")
        XCTAssertTrue(viewController.output is CommentRepliesPresenter, "output is not CommentRepliesPresenter")

        let presenter: CommentRepliesPresenter = viewController.output as! CommentRepliesPresenter
        XCTAssertNotNil(presenter.view, "view in CommentRepliesPresenter is nil after configuration")
        XCTAssertNotNil(presenter.router, "router in CommentRepliesPresenter is nil after configuration")
        XCTAssertTrue(presenter.router is CommentRepliesRouter, "router is not CommentRepliesRouter")

        let interactor: CommentRepliesInteractor = presenter.interactor as! CommentRepliesInteractor
        XCTAssertNotNil(interactor.output, "output in CommentRepliesInteractor is nil after configuration")
    }

    class CommentRepliesViewControllerMock: CommentRepliesViewController {

        var setupInitialStateDidCall = false

        override func setupInitialState() {
            setupInitialStateDidCall = true
        }
    }
}
