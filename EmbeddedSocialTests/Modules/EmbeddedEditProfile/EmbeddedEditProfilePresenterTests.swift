//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest
@testable import EmbeddedSocial

class EmbeddedEditProfilePresenterTests: XCTestCase {
    var view: MockEmbeddedEditProfileView!
    var router: MockEmbeddedEditProfileRouter!
    var interactor: MockEmbeddedEditProfileInteractor!
    var moduleOutput: MockEmbeddedEditProfileModuleOutput!
    var sut: EmbeddedEditProfilePresenter!
    
    private static let initialUser = User()
    
    override func setUp() {
        super.setUp()
        view = MockEmbeddedEditProfileView()
        router = MockEmbeddedEditProfileRouter()
        interactor = MockEmbeddedEditProfileInteractor()
        moduleOutput = MockEmbeddedEditProfileModuleOutput()
        
        sut = EmbeddedEditProfilePresenter(user: User())
        sut.view = view
        sut.interactor = interactor
        sut.router = router
        sut.moduleOutput = moduleOutput
    }
    
    override func tearDown() {
        super.tearDown()
        view = nil
        router = nil
        interactor = nil
        moduleOutput = nil
    }
    
    func testThatItSetsInitialState() {
        // given
        
        // when
        sut.setupInitialState()
        
        // then
        XCTAssertNotNil(view.lastSetupInitialStateUser)
        XCTAssertEqual(view.setupInitialStateCount, 1)
        
        XCTAssertEqual(moduleOutput.setRightNavigationButtonEnabledCount, 1)
        XCTAssertEqual(moduleOutput.isRightNavigationButtonEnabled, false)
    }
    
    func testThatItCreatesUserAndUpdatesView() {
        // given
        let firstName = UUID().uuidString
        let lastName = UUID().uuidString
        let bio = UUID().uuidString
        
        moduleOutput.viewController = UIViewController()
        router.imageToReturn = UIImage(color: .yellow, size: CGSize(width: 8.0, height: 8.0))
        
        // when
        sut.onFirstNameChanged(firstName)
        sut.onLastNameChanged(lastName)
        sut.onBioChanged(bio)
        sut.onSelectPhoto()
        
        // then
        let user = sut.getFinalUser()
        XCTAssertEqual(user.firstName, firstName)
        XCTAssertEqual(user.lastName, lastName)
        XCTAssertEqual(user.bio, bio)
        XCTAssertEqual(user.photo?.image, router.imageToReturn)
        
        XCTAssertEqual(router.openImagePickerCount, 1)
        
        XCTAssertEqual(view.setUserCount, 1)
        XCTAssertEqual(view.lastSetUser, user)
        
        XCTAssertEqual(moduleOutput.setRightNavigationButtonEnabledCount, 3)
        XCTAssertEqual(moduleOutput.isRightNavigationButtonEnabled, true)
    }
    
    func testThatItSetsViewLoading() {
        // given
        
        // when
        sut.setIsLoading(true)
        
        // then
        XCTAssertEqual(view.isLoading, true)
        XCTAssertEqual(moduleOutput.isRightNavigationButtonEnabled, false)
        XCTAssertEqual(moduleOutput.setRightNavigationButtonEnabledCount, 1)
    }
    
    func testThatItReturnsModuleView() {
        // given
        
        // when
        let view = sut.getModuleView()
        
        // then
        XCTAssertEqual(view, self.view)
    }
    
    private func makePresenter(with user: User = EmbeddedEditProfilePresenterTests.initialUser) -> EmbeddedEditProfilePresenter {
        let sut = EmbeddedEditProfilePresenter(user: user)
        sut.view = view
        sut.interactor = interactor
        sut.router = router
        sut.moduleOutput = moduleOutput
        return sut
    }
}
