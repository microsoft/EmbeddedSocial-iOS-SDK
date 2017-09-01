//
//  CommentCellCommentCellConfiguratorTests.swift
//  EmbeddedSocial-Framework
//
//  Created by generamba setup on 01/09/2017.
//  Copyright © 2017 akvelon. All rights reserved.
//

import XCTest

class CommentCellModuleConfiguratorTests: XCTestCase {

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
        let viewController = CommentCellViewControllerMock()
        let configurator = CommentCellModuleConfigurator()

        //when
        configurator.configureModuleForViewInput(viewInput: viewController)

        //then
        XCTAssertNotNil(viewController.output, "CommentCellViewController is nil after configuration")
        XCTAssertTrue(viewController.output is CommentCellPresenter, "output is not CommentCellPresenter")

        let presenter: CommentCellPresenter = viewController.output as! CommentCellPresenter
        XCTAssertNotNil(presenter.view, "view in CommentCellPresenter is nil after configuration")
        XCTAssertNotNil(presenter.router, "router in CommentCellPresenter is nil after configuration")
        XCTAssertTrue(presenter.router is CommentCellRouter, "router is not CommentCellRouter")

        let interactor: CommentCellInteractor = presenter.interactor as! CommentCellInteractor
        XCTAssertNotNil(interactor.output, "output in CommentCellInteractor is nil after configuration")
    }

    class CommentCellViewControllerMock: CommentCellViewController {

        var setupInitialStateDidCall = false

        override func setupInitialState() {
            setupInitialStateDidCall = true
        }
    }
}
