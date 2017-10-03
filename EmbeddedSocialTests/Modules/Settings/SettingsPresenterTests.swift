//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest
@testable import EmbeddedSocial

class SettingsPresenterTests: XCTestCase {
    var profileHolder: MyProfileHolder!
    var router: MockSettingsRouter!
    var view: MockSettingsView!
    var interactor: MockSettingsInteractor!
    var sut: SettingsPresenter!
    
    override func setUp() {
        super.setUp()
        router = MockSettingsRouter()
        profileHolder = MyProfileHolder()
        view = MockSettingsView()
        interactor = MockSettingsInteractor()
        
        sut = SettingsPresenter(myProfileHolder: profileHolder)
        sut.router = router
        sut.view = view
        sut.interactor = interactor
    }
    
    override func tearDown() {
        super.tearDown()
        router = nil
        profileHolder = nil
        view = nil
        interactor = nil
        sut = nil
    }
    
    func testThatBlockedUsersListIsOpened() {
        sut.onBlockedList()
        XCTAssertEqual(router.openBlockedListCount, 1)
    }
    
    func testThatItSetsInitialStateForPrivateUser() {
        testThatItSetsInitialState(visibility: ._private, switchIsOn: true)
    }
    
    func testThatItSetsInitialStateForPublicUser() {
        testThatItSetsInitialState(visibility: ._public, switchIsOn: false)
    }
    
    func testThatItSetsInitialState(visibility: Visibility, switchIsOn: Bool) {
        // given
        let user = User(visibility: visibility)
        profileHolder.me = user
        
        // when
        sut.viewIsReady()
        
        // then
        XCTAssertTrue(view.setSwitchIsOn_Called)
        XCTAssertEqual(view.setSwitchIsOn_ReceivedIsOn, switchIsOn)
    }
    
    func testThatItUpdatesPrivacy() {
        // given
        let visibility = Visibility._public
        let user = User(visibility: visibility)
        profileHolder.me = user
        interactor.switchVisibilityReturnValue = .success(visibility.switched)
        
        // when
        sut.onPrivacySwitch()
        
        // then
        XCTAssertTrue(view.setPrivacySwitchEnabled_Called)
        XCTAssertEqual(view.setPrivacySwitchEnabled_ReceivedIsEnabled, true)
        
        XCTAssertEqual(profileHolder.setMeCount, 2)
    }
    
    func testThatItShowsErrorWhenTryingToUpdatePrivacy() {
        // given
        let error = APIError.unknown
        profileHolder.me = User(visibility: ._public)
        interactor.switchVisibilityReturnValue = .failure(error)
        
        // when
        sut.onPrivacySwitch()
        
        // then
        XCTAssertTrue(view.setPrivacySwitchEnabled_Called)
        XCTAssertEqual(view.setPrivacySwitchEnabled_ReceivedIsEnabled, true)
        
        XCTAssertTrue(view.showError_Called)
        guard let shownError = view.showError_ReceivedError as? APIError, case .unknown = shownError else {
            XCTFail("Error must be shown")
            return
        }
        
        XCTAssertEqual(profileHolder.setMeCount, 1)
    }
}
