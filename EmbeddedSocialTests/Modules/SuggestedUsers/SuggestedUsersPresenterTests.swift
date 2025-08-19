//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest
import Nimble
@testable import EmbeddedSocial

class SuggestedUsersPresenterTests: XCTestCase {
    var view: MockSuggestedUsersView!
    var userListModule: MockUserListModuleInput!
    var sut: SuggestedUsersPresenter!
    var userHolder: MyProfileHolder!
    var interactor: MockSuggestedUsersInteractor!
    
    override func setUp() {
        super.setUp()
        view = MockSuggestedUsersView()
        userListModule = MockUserListModuleInput()
        userHolder = MyProfileHolder()
        interactor = MockSuggestedUsersInteractor()
        sut = SuggestedUsersPresenter(userHolder: userHolder)
        
        sut.view = view
        sut.usersList = userListModule
        sut.interactor = interactor
    }
    
    override func tearDown() {
        super.tearDown()
        view = nil
        userListModule = nil
        sut = nil
        userHolder = nil
        interactor = nil
    }
    
    func testInitialSetupWithPermission() {
        interactor.isFriendsListPermissionGranted = true
        sut.viewIsReady()
        expect(self.view.setupInitialStateUserListViewCalled).to(beTrue())
        expect(self.userListModule.setupInitialStateCalled).to(beTrue())
        expect(self.userListModule.listView).to(equal(self.view.setupInitialStateUserListViewReceivedUserListView))
    }
    
    func testInitialSetupWithoutPermission() {
        interactor.isFriendsListPermissionGranted = false
        let creds = CredentialsList(provider: .facebook, accessToken: "1", socialUID: "2")
        interactor.requestFriendsListPermissionResult = .success(creds)
        sut.viewIsReady()
        expect(self.interactor.requestFriendsListPermissionCalled).toEventually(beTrue())
        expect(self.userHolder.setMeCount).to(equal(1))
        expect(self.userHolder.me?.credentials).to(equal(creds))
        expect(self.view.setupInitialStateUserListViewCalled).to(beTrue())
        expect(self.userListModule.setupInitialStateCalled).to(beTrue())
        expect(self.userListModule.listView).to(equal(self.view.setupInitialStateUserListViewReceivedUserListView))
    }
    
    func testThatItShowsErrorWhenSocialRequestFails() {
        interactor.isFriendsListPermissionGranted = true
        sut.viewIsReady()
        sut.didFailToPerformSocialRequest(listView: userListModule.listView, error: APIError.unknown)
        
        expect(self.view.showErrorCalled).to(beTrue())
        expect(self.view.showErrorReceivedError).to(matchError(APIError.unknown))
    }
    
    func testThatItShowsErrorWhenFailsToLoadList() {
        interactor.isFriendsListPermissionGranted = true
        sut.viewIsReady()
        sut.didFailToLoadList(listView: userListModule.listView, error: APIError.unknown)
        
        expect(self.view.showErrorCalled).to(beTrue())
        expect(self.view.showErrorReceivedError).to(matchError(APIError.unknown))
    }
}
