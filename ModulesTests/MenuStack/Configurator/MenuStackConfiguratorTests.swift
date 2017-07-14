//
//  MenuStackMenuStackConfiguratorTests.swift
//  MSGP-Framework
//
//  Created by igor.popov on 12/07/2017.
//  Copyright © 2017 akvelon. All rights reserved.
//

import XCTest

class MenuStackModuleConfiguratorTests: XCTestCase {

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
        let viewController = MenuStackViewControllerMock()
        let configurator = MenuStackModuleConfigurator()

        //when
        configurator.configureModuleForViewInput(viewInput: viewController)

        //then
        XCTAssertNotNil(viewController.output, "MenuStackViewController is nil after configuration")
        XCTAssertTrue(viewController.output is MenuStackPresenter, "output is not MenuStackPresenter")

        let presenter: MenuStackPresenter = viewController.output as! MenuStackPresenter
        XCTAssertNotNil(presenter.view, "view in MenuStackPresenter is nil after configuration")
        XCTAssertNotNil(presenter.router, "router in MenuStackPresenter is nil after configuration")
        XCTAssertTrue(presenter.router is MenuStackRouter, "router is not MenuStackRouter")

        let interactor: MenuStackInteractor = presenter.interactor as! MenuStackInteractor
        XCTAssertNotNil(interactor.output, "output in MenuStackInteractor is nil after configuration")
    }

    class MenuStackViewControllerMock: MenuStackViewController {

        var setupInitialStateDidCall = false

        override func setupInitialState() {
            setupInitialStateDidCall = true
        }
    }
}
