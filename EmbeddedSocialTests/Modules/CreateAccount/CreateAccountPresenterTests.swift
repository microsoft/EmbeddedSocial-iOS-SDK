//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest
@testable import EmbeddedSocial

class CreateAccountPresenterTests: XCTestCase {
    var view: MockCreateAccountViewController!
    var interactor: MockCreateAccountInteractor!
    var moduleOutput: MockCreateAccountModuleOutput!
    var mockEditModule: MockEmbeddedEditProfileModuleInput!
    var editModule: EmbeddedEditProfilePresenter!
    
    override func setUp() {
        super.setUp()
        view = MockCreateAccountViewController()
        interactor = MockCreateAccountInteractor()
        moduleOutput = MockCreateAccountModuleOutput()
        mockEditModule = MockEmbeddedEditProfileModuleInput()
    }
    
    override func tearDown() {
        super.tearDown()
        view = nil
        interactor = nil
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
        
        XCTAssertEqual(view.setCreateAccountButtonEnabledCount, 1)
        XCTAssertEqual(view.isCreateAccountButtonEnabled, false)
    }
    
    func testThatItCreatesAccount() {
        // given
        let user = User()
        let sessionToken = UUID().uuidString
        let sut = makePresenter(user: user)
        sut.editModuleInput = mockEditModule
        mockEditModule.finalUser = user
        
        interactor.resultMaker = { .success($0, sessionToken) }
        
        // when
        sut.onCreateAccount()
        
        // then
        XCTAssertEqual(mockEditModule.setIsLoadingCount, 2)
        XCTAssertEqual(mockEditModule.isLoading, false)
        
        XCTAssertEqual(moduleOutput.onAccountCreatedCount, 1)
        XCTAssertEqual(moduleOutput.lastOnAccountCreatedUser, user)
        XCTAssertEqual(moduleOutput.lastOnAccountSessionToken, sessionToken)
    }
    
    func testThatItFailsToCreateAccount() {
        // given
        let error = APIError.unknown
        let sut = makePresenter(user: User())
        sut.editModuleInput = mockEditModule
        
        interactor.resultMaker = { _ in .failure(error) }
        
        // when
        sut.onCreateAccount()
        
        // then
        XCTAssertEqual(mockEditModule.setIsLoadingCount, 2)
        XCTAssertEqual(mockEditModule.isLoading, false)
        
        XCTAssertEqual(view.showErrorCount, 1)
        guard let e = view.lastShownError as? APIError, case APIError.unknown = e else {
            XCTFail("Unexpected error \(view.lastShownError as Optional)")
            return
        }
    }
    
    private func makePresenter(user: User) -> CreateAccountPresenter {
        let sut = CreateAccountPresenter(user: user)
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
