//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest
@testable import EmbeddedSocial

class EditProfilePresenterTests: XCTestCase {
    var interactor: MockEditProfileInteractor!
    var view: MockEditProfileView!
    var moduleOutput: MockEditProfileModuleOutput!
    var mockEditModule: MockEmbeddedEditProfileModuleInput!

    override func setUp() {
        super.setUp()
        interactor = MockEditProfileInteractor()
        view = MockEditProfileView()
        moduleOutput = MockEditProfileModuleOutput()
        mockEditModule = MockEmbeddedEditProfileModuleInput()
    }
    
    override func tearDown() {
        super.tearDown()
        interactor = nil
        view = nil
        moduleOutput = nil
        mockEditModule = nil
    }
    
    func testThatItSetsInitialState() {
        // given
        let user = User()
        let sut = makePresenter(user: user)
        sut.editModuleInput = makeEditModule(user: user, moduleOutput: sut)
        
        // when
        sut.viewIsReady()
        
        // then
        XCTAssertNotNil(view.editView)
        XCTAssertEqual(view.setupInitialStateCount, 1)
        
        XCTAssertEqual(view.setBackButtonEnabledCount, 0)
        XCTAssertNil(view.isBackButtonEnabled)
        XCTAssertEqual(view.setSaveButtonEnabledCount, 1)
        XCTAssertEqual(view.isSaveButtonEnabled, false)
    }
    
    func testThatItEditsProfile() {
        // given
        let photo = Photo()
        let user = User(photo: photo)
        let sut = makePresenter(user: user)
        sut.editModuleInput = mockEditModule
        mockEditModule.finalUser = user
        
        interactor.editResult = .success(user)
        
        // when
        sut.onEditProfile()
        
        // then
        XCTAssertEqual(mockEditModule.setIsLoadingCount, 2)
        XCTAssertEqual(mockEditModule.isLoading, false)
        
        XCTAssertEqual(interactor.cachedPhoto, photo)
        XCTAssertEqual(interactor.cachePhotoCount, 1)
        
        XCTAssertEqual(view.setBackButtonEnabledCount, 2)
        XCTAssertEqual(view.isBackButtonEnabled, true)
        
        XCTAssertEqual(moduleOutput.onProfileEditedCount, 1)
        XCTAssertEqual(moduleOutput.me, user)
    }
    
    func testThatItFailsToEditProfile() {
        // given
        let error = APIError.unknown
        let sut = makePresenter(user: User())
        sut.editModuleInput = mockEditModule
        
        interactor.editResult = .failure(error)
        
        // when
        sut.onEditProfile()
        
        // then
        XCTAssertEqual(mockEditModule.setIsLoadingCount, 2)
        XCTAssertEqual(mockEditModule.isLoading, false)
        
        XCTAssertEqual(view.showErrorCount, 1)
        guard let e = view.lastShownError as? APIError, case APIError.unknown = e else {
            XCTFail("Unexpected error \(view.lastShownError as Optional)")
            return
        }
    }
    
    func testThatViewIsReturned() {
        let sut = makePresenter(user: User())
        XCTAssertEqual(sut.viewController, view)
    }
    
    func testThatItSetsRightNavigationButtonEnabled() {
        // given
        let sut = makePresenter(user: User())
        
        // when
        sut.setRightNavigationButtonEnabled(true)
        
        // then
        XCTAssertEqual(view.isSaveButtonEnabled, true)
        XCTAssertEqual(view.setSaveButtonEnabledCount, 1)
        
        // when
        sut.setRightNavigationButtonEnabled(false)
        
        // then
        XCTAssertEqual(view.isSaveButtonEnabled, false)
        XCTAssertEqual(view.setSaveButtonEnabledCount, 2)
    }
    
    private func makePresenter(user: User) -> EditProfilePresenter {
        let sut = EditProfilePresenter(user: user)
        sut.view = view
        sut.interactor = interactor
        sut.moduleOutput = moduleOutput
        return sut
    }
    
    private func makeEditModule(user: User, moduleOutput: EmbeddedEditProfileModuleOutput) -> EmbeddedEditProfilePresenter {
        let editModule = EmbeddedEditProfilePresenter(user: user)
        editModule.view = MockEmbeddedEditProfileView()
        editModule.router = MockEmbeddedEditProfileRouter()
        editModule.interactor = MockEmbeddedEditProfileInteractor()
        editModule.moduleOutput = moduleOutput
        return editModule
    }
}
