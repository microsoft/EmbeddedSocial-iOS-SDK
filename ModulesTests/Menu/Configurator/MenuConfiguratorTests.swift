//
//  MenuMenuConfiguratorTests.swift
//  MSGP-Framework
//
//  Created by igor.popov on 10/07/2017.
//  Copyright © 2017 akvelon. All rights reserved.
//

import XCTest

class MenuModuleConfiguratorTests: XCTestCase {

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
        let viewController = MenuViewControllerMock()
        let configurator = MenuModuleConfigurator()

        //when
        configurator.configureModuleForViewInput(viewInput: viewController)

        //then
        XCTAssertNotNil(viewController.output, "MenuViewController is nil after configuration")
        XCTAssertTrue(viewController.output is MenuPresenter, "output is not MenuPresenter")

        let presenter: MenuPresenter = viewController.output as! MenuPresenter
        XCTAssertNotNil(presenter.view, "view in MenuPresenter is nil after configuration")
        XCTAssertNotNil(presenter.router, "router in MenuPresenter is nil after configuration")
        XCTAssertTrue(presenter.router is MenuRouter, "router is not MenuRouter")

        let interactor: MenuInteractor = presenter.interactor as! MenuInteractor
        XCTAssertNotNil(interactor.output, "output in MenuInteractor is nil after configuration")
    }

    class MenuViewControllerMock: MenuViewController {

        var setupInitialStateDidCall = false

        override func setupInitialState() {
            setupInitialStateDidCall = true
        }
    }
}
