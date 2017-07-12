//
//  TabMenuContainerTabMenuContainerConfiguratorTests.swift
//  MSGP-Framework
//
//  Created by igor.popov on 12/07/2017.
//  Copyright © 2017 akvelon. All rights reserved.
//

import XCTest

class TabMenuContainerModuleConfiguratorTests: XCTestCase {

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
        let viewController = TabMenuContainerViewControllerMock()
        let configurator = TabMenuContainerModuleConfigurator()

        //when
        configurator.configureModuleForViewInput(viewInput: viewController)

        //then
        XCTAssertNotNil(viewController.output, "TabMenuContainerViewController is nil after configuration")
        XCTAssertTrue(viewController.output is TabMenuContainerPresenter, "output is not TabMenuContainerPresenter")

        let presenter: TabMenuContainerPresenter = viewController.output as! TabMenuContainerPresenter
        XCTAssertNotNil(presenter.view, "view in TabMenuContainerPresenter is nil after configuration")
        XCTAssertNotNil(presenter.router, "router in TabMenuContainerPresenter is nil after configuration")
        XCTAssertTrue(presenter.router is TabMenuContainerRouter, "router is not TabMenuContainerRouter")

        let interactor: TabMenuContainerInteractor = presenter.interactor as! TabMenuContainerInteractor
        XCTAssertNotNil(interactor.output, "output in TabMenuContainerInteractor is nil after configuration")
    }

    class TabMenuContainerViewControllerMock: TabMenuContainerViewController {

        var setupInitialStateDidCall = false

        override func setupInitialState() {
            setupInitialStateDidCall = true
        }
    }
}
