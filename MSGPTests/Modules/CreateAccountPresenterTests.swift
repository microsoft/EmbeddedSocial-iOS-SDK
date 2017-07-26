//
//  CreateAccountPresenterTests.swift
//  MSGP
//
//  Created by Vadim Bulavin on 7/25/17.
//  Copyright © 2017 Akvelon. All rights reserved.
//

import XCTest
@testable import MSGP

class CreateAccountPresenterTests: XCTestCase {
    var view: MockCreateAccountViewController!
    var interactor: MockCreateAccountInteractor!
    var router: MockCreateAccountRouter!
    var moduleOutput: MockCreateAccountModuleOutput!
    
    var sut: CreateAccountPresenter!
    
    private let initialSocialUser: SocialUser = {
        let credentials = CredentialsList(provider: .facebook, accessToken: "", socialUID: "")
        return SocialUser(credentials: credentials, firstName: nil, lastName: nil, email: nil, photo: nil)
    }()
    
    override func setUp() {
        super.setUp()
        view = MockCreateAccountViewController()
        interactor = MockCreateAccountInteractor()
        router = MockCreateAccountRouter()
        moduleOutput = MockCreateAccountModuleOutput()
        
        sut = CreateAccountPresenter(user: initialSocialUser)
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
    
    func testThatItSetsInitialState() {
        // given: initial user
        
        // when
        sut.viewIsReady()
        
        // then
        XCTAssertNotNil(view.lastSetupInitialStateUser)
        XCTAssertEqual(view.setupInitialStateCount, 1)
        
        XCTAssertEqual(view.setCreateAccountButtonEnabledCount, 1)
        XCTAssertNotNil(view.isCreateAccountButtonEnabled)
        XCTAssertFalse(view.isCreateAccountButtonEnabled!)
    }
    
    func testThatItChangesInputs() {
        // given
        let firstName = UUID().uuidString
        let lastName = UUID().uuidString
        let bio = UUID().uuidString
        
        // when
        sut.onFirstNameChanged(firstName)
        sut.onLastNameChanged(lastName)
        sut.onBioChanged(bio)

        // then
        XCTAssertEqual(view.setCreateAccountButtonEnabledCount, 3)
        XCTAssertNotNil(view.isCreateAccountButtonEnabled)
        XCTAssertTrue(view.isCreateAccountButtonEnabled!)
    }
    
    func testThatItCreatesAccountFromInputAndSetsLoadingStateOnView() {
        // given
        let firstName = UUID().uuidString
        let lastName = UUID().uuidString
        let bio = UUID().uuidString
        
        // when
        sut.onFirstNameChanged(firstName)
        sut.onLastNameChanged(lastName)
        sut.onBioChanged(bio)
        
        sut.onCreateAccount()
        
        // then
        XCTAssertEqual(interactor.createAccountCount, 1)
        XCTAssertNotNil(interactor.lastSocialUser)
        XCTAssertEqual(interactor.lastSocialUser?.firstName, firstName)
        XCTAssertEqual(interactor.lastSocialUser?.lastName, lastName)
        XCTAssertEqual(interactor.lastSocialUser?.bio, bio)
        
        // stopped loading
        XCTAssertNotNil(view.isLoading)
        XCTAssertFalse(view.isLoading!)
        
        // button enabled
        XCTAssertNotNil(view.isCreateAccountButtonEnabled)
        XCTAssertTrue(view.isCreateAccountButtonEnabled!)
    }
    
    func testThatItFailsToCreateAccount() {
        // given
        let errorToShow = Error.custom("")
        
        // when
        interactor.resultMaker = { _ in .failure(errorToShow) }
        sut.onCreateAccount()

        // then
        XCTAssertEqual(interactor.createAccountCount, 1)
        XCTAssertNotNil(interactor.lastSocialUser)
        XCTAssertEqual(interactor.lastSocialUser, initialSocialUser)
        
        // stopped loading
        XCTAssertNotNil(view.isLoading)
        XCTAssertFalse(view.isLoading!)
        
        // button enabled
        XCTAssertNotNil(view.isCreateAccountButtonEnabled)
        XCTAssertTrue(view.isCreateAccountButtonEnabled!)
        
        // error shown
        XCTAssertEqual(view.showErrorCount, 1)
        XCTAssertNotNil(view.lastShownError)
        
        guard case CreateAccountPresenterTests.Error.custom = view.lastShownError! else {
            XCTFail("Error \(view.lastShownError!) does not match \(errorToShow)")
            return
        }
    }
    
    func testThatItSucceedsToSelectImage() {
        // given
        
        // when
        sut.onSelectPhoto()
        
        // then
        XCTAssertEqual(router.openImagePickerCount, 1)
        
        XCTAssertEqual(view.setUserCount, 1)
        XCTAssertNotNil(view.lastSetUser)
        XCTAssertEqual(view.lastSetUser?.photo?.image, router.lastReturnedImage)
    }
    
    func testThatItFailsToSelectImage() {
        // given
        let view = MockCreateAccountViewPlainObject()
        
        // when
        sut.view = view
        sut.onSelectPhoto()

        // then
        XCTAssertEqual(router.openImagePickerCount, 0)
        
        XCTAssertEqual(view.setUserCount, 0)
        XCTAssertNil(view.lastSetUser)
    }
}

extension CreateAccountPresenterTests {
    enum Error: LocalizedError {
        case custom(String)
        
        public var errorDescription: String? {
            switch self {
            case let .custom(text): return text
            }
        }
    }
}
