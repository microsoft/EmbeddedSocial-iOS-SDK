//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest
@testable import EmbeddedSocial

class LoginPresenterTests: XCTestCase {
    var view: MockLoginViewInput!
    var interactor: MockLoginInteractor!
    var router: MockLoginRouter!
    var moduleOutput: MockLoginModuleOutput!

    var sut: LoginPresenter!
    
    override func setUp() {
        super.setUp()
        view = MockLoginViewInput()
        interactor = MockLoginInteractor()
        router = MockLoginRouter()
        moduleOutput = MockLoginModuleOutput()
        
        sut = LoginPresenter(source: .menu)
        sut.view = view
        sut.interactor = interactor
        sut.router = router
        sut.moduleOutput = moduleOutput
    }
    
    override func tearDown() {
        super.tearDown()
        view = nil
        interactor = nil
        router = nil
        moduleOutput = nil
        sut = nil
    }
    
    func testThatItSetsViewInitialState() {
        // given
        
        // when
        sut.viewIsReady()
        
        // then
        XCTAssertEqual(view.setupInitialStateCount, 1)
    }
    
    func testThatItIsLoggedInWithFacebook() {
        sut.onFacebookSignInTapped()
        validateLoggedIn(withProvider: .facebook)
    }
    
    func testThatItIsLoggedInWithTwitter() {
        sut.onTwitterSignInTapped()
        validateLoggedIn(withProvider: .twitter)
    }
    
    func testThatItIsLoggedInWithGoogle() {
        sut.onGoogleSignInTapped()
        validateLoggedIn(withProvider: .google)
    }
    
    func testThatItIsLoggedInWithMicrosoft() {
        sut.onMicrosoftSignInTapped()
        validateLoggedIn(withProvider: .microsoft)
    }
    
    private func validateLoggedIn(withProvider provider: AuthProvider) {
        XCTAssertNotNil(view.isLoading)
        XCTAssertTrue(view.isLoading!)
        
        XCTAssertEqual(interactor.loginCount, 1)
        XCTAssertEqual(interactor.lastProvider, provider)
    }
}
