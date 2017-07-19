//
//  SideMenuSideMenuConfiguratorTests.swift
//  MSGP-Framework
//
//  Created by igor.popov on 17/07/2017.
//  Copyright © 2017 akvelon. All rights reserved.
//

import XCTest

class SideMenuModuleConfiguratorTests: XCTestCase {

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
        let viewController = SideMenuViewControllerMock()
        let configurator = SideMenuModuleConfigurator()

        //when
        configurator.configureModuleForViewInput(viewInput: viewController)

        //then
        XCTAssertNotNil(viewController.output, "SideMenuViewController is nil after configuration")
        XCTAssertTrue(viewController.output is SideMenuPresenter, "output is not SideMenuPresenter")

        let presenter: SideMenuPresenter = viewController.output as! SideMenuPresenter
        XCTAssertNotNil(presenter.view, "view in SideMenuPresenter is nil after configuration")
        XCTAssertNotNil(presenter.router, "router in SideMenuPresenter is nil after configuration")
        XCTAssertTrue(presenter.router is SideMenuRouter, "router is not SideMenuRouter")

        let interactor: SideMenuInteractor = presenter.interactor as! SideMenuInteractor
        XCTAssertNotNil(interactor.output, "output in SideMenuInteractor is nil after configuration")
    }

    class SideMenuViewControllerMock: SideMenuViewController {

        var setupInitialStateDidCall = false

        override func setupInitialState() {
            setupInitialStateDidCall = true
        }
    }
}
