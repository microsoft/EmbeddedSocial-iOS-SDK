//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest
@testable import EmbeddedSocial

class DetailedActivityPresenterTests: XCTestCase {
    
    var presenter: DetailedActivityPresenter!
    let interactor = MockDetailedActivityInteractor()
    let view = MockDetailedActivityViewController()
    let router = MockDetailedActivityRouter()
    
    var myProfileHolder: MyProfileHolder!
    
    override func setUp() {
        presenter = DetailedActivityPresenter()
        presenter.interactor = interactor
        presenter.view = view
        presenter.router = router
        interactor.output = presenter
        view.output = presenter
    }
    
    override func tearDown() {
        super.tearDown()
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
        
        XCTAssertEqual(view.setupInitialStateCount, 1)
    }

    func testThatCommentLoaded() {
        
        presenter.state = .comment
        presenter.loadContent()
        
        XCTAssertNotNil(presenter.comment)
        XCTAssertEqual(view.reloadAllContentCount, 1)
    }
    
    func testThatReplyLoaded() {
        
        presenter.state = .reply
        presenter.loadContent()
        
        XCTAssertNotNil(presenter.reply)
        XCTAssertEqual(view.reloadAllContentCount, 1)
    }

    
}
