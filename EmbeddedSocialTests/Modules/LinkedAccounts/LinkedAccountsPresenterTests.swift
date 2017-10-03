//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest
import Nimble
@testable import EmbeddedSocial

class LinkedAccountsPresenterTests: XCTestCase {
    
    var interactor: MockLinkedAccountsInteractor!
    var view: MockLinkedAccountsView!
    var sut: LinkedAccountsPresenter!
    
    override func setUp() {
        super.setUp()
        interactor = MockLinkedAccountsInteractor()
        view = MockLinkedAccountsView()
        sut = LinkedAccountsPresenter()
        sut.view = view
        sut.interactor = interactor
    }
    
    override func tearDown() {
        super.tearDown()
        interactor = nil
        view = nil
        sut = nil
    }
    
    func testThatItSetsInitialState() {
        // given
        interactor.getLinkedAccountsCompletionReturnValue = .success([])
        
        // when
        sut.viewIsReady()
        
        // then
        expect(self.view.setupInitialStateCalled).to(beTrue())
        validateLinkedAccountsLoaded()
    }
    
    func testThatItLoadsLinkedAccounts() {
        // given
        interactor.getLinkedAccountsCompletionReturnValue = .success([])
        
        // when
        sut.loadLinkedAccounts()
        
        // then
        validateLinkedAccountsLoaded()
    }
    
    private func validateLinkedAccountsLoaded() {
        expect(self.interactor.getLinkedAccountsCompletionCalled).toEventually(beTrue())
        expect(self.view.setSwitchesEnabledCalled).toEventually(beTrue())
        expect(self.view.setSwitchesEnabledReceivedIsEnabled).toEventually(beTrue())
    }
    
    func testThatItLoadsLinkedAccountsAndSetsCorrespondingSwitchesOn() {
        // given
        let linkedAccount1 = LinkedAccountView()
        linkedAccount1.accountId = UUID().uuidString
        linkedAccount1.identityProvider = .facebook
        
        let linkedAccount2 = LinkedAccountView()
        linkedAccount2.accountId = UUID().uuidString
        linkedAccount2.identityProvider = .google
        
        interactor.getLinkedAccountsCompletionReturnValue = .success([linkedAccount1, linkedAccount2])
        
        // when
        sut.loadLinkedAccounts()
        
        // then
        validateLinkedAccountsLoaded()
        validateLinkedAccountSet(linkedAccount1, index: 0)
        validateLinkedAccountSet(linkedAccount2, index: 1)
    }
    
    private func validateLinkedAccountSet(_ linkedAccount: LinkedAccountView, index: Int) {
        let provider = linkedAccount.identityProvider?.authProvider
        expect(provider).toEventuallyNot(beNil())
        expect(self.view.setSwitchOnForAllReceivedArguments[index]?.provider).toEventually(equal(provider))
        expect(self.view.setSwitchOnForAllReceivedArguments[index]?.isOn).toEventually(beTrue())
    }
    
    func testThatItShowsErrorIfLoadLinkedAccountsFails() {
        // given
        interactor.getLinkedAccountsCompletionReturnValue = .failure(APIError.unknown)

        // when
        sut.loadLinkedAccounts()
        
        // then
        validateLinkedAccountsLoaded()
        expect(self.view.showErrorCalled).toEventually(beTrue())
        expect(self.view.showErrorReceivedError).toEventually(matchError(APIError.unknown))
    }
    
    // MARK: - Facebook Switch Value Changes
    
    func testFacebook_switchTurnOnAction_whenAPISucceeds() {
        testThatItHandlesSwitchTurnOnAction(with: .facebook, switchValueChange: sut.onFacebookSwitchValueChanged)
    }
    
    func testFacebook_switchTurnOnAction_whenLoginFails() {
        testThatItHandlesSwitchTurnOnActionWithLoginError(with: .facebook, switchValueChange: sut.onFacebookSwitchValueChanged)
    }
    
    func testFacebook_switchTurnOnAction_whenLinkAccountFails() {
        testThatItHandlesSwitchTurnOnActionWithLinkAccountError(with: .facebook, switchValueChange: sut.onFacebookSwitchValueChanged)
    }
    
    func testFacebook_turnOffAction() {
        testThatItHandlesSwitchTurnOffAction(with: .facebook, switchValueChange: sut.onFacebookSwitchValueChanged)
    }
    
    // MARK: - Google Switch Value Changes

    func testGoogle_switchTurnOnAction_whenAPISucceeds() {
        testThatItHandlesSwitchTurnOnAction(with: .google, switchValueChange: sut.onGoogleSwitchValueChanged)
    }
    
    func testGoogle_switchTurnOnAction_whenLoginFails() {
        testThatItHandlesSwitchTurnOnActionWithLoginError(with: .google, switchValueChange: sut.onGoogleSwitchValueChanged)
    }
    
    func testGoogle_switchTurnOnAction_whenLinkAccountFails() {
        testThatItHandlesSwitchTurnOnActionWithLinkAccountError(with: .google, switchValueChange: sut.onGoogleSwitchValueChanged)
    }
    
    func testGoogle_turnOffAction() {
        testThatItHandlesSwitchTurnOffAction(with: .google, switchValueChange: sut.onGoogleSwitchValueChanged)
    }
    
    // MARK: - Microsoft Switch Value Changes
    
    func testMicrosoft_switchTurnOnAction_whenAPISucceeds() {
        testThatItHandlesSwitchTurnOnAction(with: .microsoft, switchValueChange: sut.onMicrosoftSwitchValueChanged)
    }
    
    func testMicrosoft_switchTurnOnAction_whenLoginFails() {
        testThatItHandlesSwitchTurnOnActionWithLoginError(with: .microsoft, switchValueChange: sut.onMicrosoftSwitchValueChanged)
    }
    
    func testMicrosoft_switchTurnOnAction_whenLinkAccountFails() {
        testThatItHandlesSwitchTurnOnActionWithLinkAccountError(with: .microsoft, switchValueChange: sut.onMicrosoftSwitchValueChanged)
    }
    
    func testMicrosoft_turnOffAction() {
        testThatItHandlesSwitchTurnOffAction(with: .microsoft, switchValueChange: sut.onMicrosoftSwitchValueChanged)
    }
    
    // MARK: - Twitter Switch Value Changes
    
    func testTwitter_switchTurnOnAction_whenAPISucceeds() {
        testThatItHandlesSwitchTurnOnAction(with: .twitter, switchValueChange: sut.onTwitterSwitchValueChanged)
    }
    
    func testTwitter_switchTurnOnAction_whenLoginFails() {
        testThatItHandlesSwitchTurnOnActionWithLoginError(with: .twitter, switchValueChange: sut.onTwitterSwitchValueChanged)
    }
    
    func testTwitter_switchTurnOnAction_whenLinkAccountFails() {
        testThatItHandlesSwitchTurnOnActionWithLinkAccountError(with: .twitter, switchValueChange: sut.onTwitterSwitchValueChanged)
    }
    
    func testTwitter_turnOffAction() {
        testThatItHandlesSwitchTurnOffAction(with: .twitter, switchValueChange: sut.onTwitterSwitchValueChanged)
    }
    
    func testThatItHandlesSwitchTurnOnAction(with provider: AuthProvider, switchValueChange: (Bool) -> Void) {
        // given
        let auth = UUID().uuidString
        interactor.loginWithFromCompletionReturnValue = .success(auth)
        interactor.linkAccountAuthorizationCompletionReturnValue = .success()
        
        // when
        switchValueChange(true)
        
        // then
        expect(self.interactor.loginWithFromCompletionCalled).toEventually(beTrue())
        expect(self.interactor.loginWithFromCompletionReceivedArguments?.provider).toEventually(equal(provider))
        
        expect(self.interactor.linkAccountAuthorizationCompletionCalled).toEventually(beTrue())
        expect(self.interactor.linkAccountAuthorizationCompletionReceivedAuthorization).toEventually(equal(auth))
        
        expect(self.view.setSwitchesEnabledCalled).toEventually(beTrue())
        expect(self.view.setSwitchesEnabledReceivedIsEnabled).toEventually(beTrue())
    }
    
    func testThatItHandlesSwitchTurnOnActionWithLoginError(with provider: AuthProvider, switchValueChange: (Bool) -> Void) {
        // given
        interactor.loginWithFromCompletionReturnValue = .failure(APIError.unknown)
        interactor.linkAccountAuthorizationCompletionReturnValue = .success()
        
        // when
        switchValueChange(true)
        
        // then
        expect(self.interactor.loginWithFromCompletionCalled).toEventually(beTrue())
        expect(self.interactor.loginWithFromCompletionReceivedArguments?.provider).toEventually(equal(provider))
        
        expect(self.interactor.linkAccountAuthorizationCompletionCalled).toEventually(beFalse())
        
        expect(self.view.setSwitchesEnabledCalled).toEventually(beTrue())
        expect(self.view.setSwitchesEnabledReceivedIsEnabled).toEventually(beTrue())
        expect(self.view.showErrorCalled).toEventually(beTrue())
        expect(self.view.showErrorReceivedError).toEventually(matchError(APIError.unknown))
    }
    
    func testThatItHandlesSwitchTurnOnActionWithLinkAccountError(with provider: AuthProvider, switchValueChange: (Bool) -> Void) {
        // given
        let auth = UUID().uuidString
        interactor.loginWithFromCompletionReturnValue = .success(auth)
        interactor.linkAccountAuthorizationCompletionReturnValue = .failure(APIError.unknown)
        
        // when
        switchValueChange(true)
        
        // then
        expect(self.interactor.loginWithFromCompletionCalled).toEventually(beTrue())
        expect(self.interactor.loginWithFromCompletionReceivedArguments?.provider).toEventually(equal(provider))
        
        expect(self.interactor.linkAccountAuthorizationCompletionCalled).toEventually(beTrue())
        expect(self.interactor.linkAccountAuthorizationCompletionReceivedAuthorization).toEventually(equal(auth))
        
        expect(self.view.setSwitchesEnabledCalled).toEventually(beTrue())
        expect(self.view.setSwitchesEnabledReceivedIsEnabled).toEventually(beTrue())
        expect(self.view.showErrorCalled).toEventually(beTrue())
        expect(self.view.showErrorReceivedError).toEventually(matchError(APIError.unknown))
    }
    
    func testThatItHandlesSwitchTurnOffAction(with provider: AuthProvider, switchValueChange: (Bool) -> Void) {
        // given
        interactor.deleteLinkedAccountProviderCompletionReturnValue = .success()
        
        // when
        switchValueChange(false)
        
        // then
        expect(self.interactor.deleteLinkedAccountProviderCompletionCalled).toEventually(beTrue())
        expect(self.interactor.deleteLinkedAccountProviderCompletionReceivedProvider).toEventually(equal(provider))

        expect(self.view.setSwitchesEnabledCalled).toEventually(beTrue())
        expect(self.view.setSwitchesEnabledReceivedIsEnabled).toEventually(beTrue())
    }
}

