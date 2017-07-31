//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest
@testable import MSGP

class SocialPlusTests: XCTestCase {
    private let sut = SocialPlus.shared
    
    override func setUp() {
        super.setUp()
        sut.setupServices(with: SocialPlusServices())
    }
    
    override func tearDown() {
        super.tearDown()
        sut.setupServices(with: SocialPlusServices())
    }
    
    func testThatURLIsOpened() {
        testThatURLIsOpened(mockResult: true)
        testThatURLIsOpened(mockResult: false)
    }
    
    func testThatURLIsOpened(mockResult: Bool) {
        // given
        let urlSchemeService = MockURLSchemeService(openURLResult: mockResult)
        let socialPlusServicesProvider = MockSocialPlusServices(urlSchemeService: urlSchemeService,
                                                                sessionStoreRepositoriesProvider: SessionStoreRepositoryProvider())
        let url = URL(string: "http://google.com")
        
        // when
        sut.setupServices(with: socialPlusServicesProvider)
        
        XCTAssertNotNil(url)
        let actualResult = sut.application(UIApplication.shared, open: url!, options: [:])
        
        // then
        XCTAssertEqual(mockResult, actualResult)
        XCTAssertTrue(urlSchemeService.openURLIsCalled)
    }
    
    func testThatItConfiguresAllServicesOnStartWithLoggedInUser() {
        // given
        let credentials = CredentialsList(provider: .facebook, accessToken: UUID().uuidString, socialUID: UUID().uuidString)
        let user = User(uid: UUID().uuidString, credentials: credentials)
        let sessionToken = UUID().uuidString
        
        let userRepo = MockKeyValueRepository<User>()
        userRepo.mementoToLoad = user.memento
        
        let sessionTokenRepo = MockKeyValueRepository<String>()
        sessionTokenRepo.mementoToLoad = sessionToken.memento
        
        let thirdPartiesConfigurator = MockThirdPartyConfigurator()
        
        let repoProvider = MockSessionStoreRepositoryProvider(userRepository: userRepo, sessionTokenRepository: sessionTokenRepo)
        
        var servicesProvider = MockSocialPlusServices(urlSchemeService: URLSchemeService(),
                                                      sessionStoreRepositoriesProvider: repoProvider)
        servicesProvider.thirdPartyConfigurator = thirdPartiesConfigurator
        
        sut.setupServices(with: servicesProvider)
        
        let args = LaunchArguments(app: UIApplication.shared,
                                   window: UIWindow(),
                                   launchOptions: [:],
                                   menuHandler: nil,
                                   menuConfiguration: .dual)
        
        // when
        sut.start(launchArguments: args)
        
        // then
        XCTAssertEqual(APISettings.shared.customHeaders, credentials.authHeader)
        XCTAssertEqual(thirdPartiesConfigurator.setupCount, 1)
    }
}
