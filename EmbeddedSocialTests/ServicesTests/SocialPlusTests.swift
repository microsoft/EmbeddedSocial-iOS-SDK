//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest
@testable import EmbeddedSocial

class SocialPlusTests: XCTestCase {
    var sessionStoreRepositoryProvider: MockSessionStoreRepositoryProvider!
    var authorizationMulticast: MockAuthorizationMulticast!
    var urlSchemeService: MockURLSchemeService!
    var thirdPartyConfigurator: MockThirdPartyConfigurator!
    var daemonsController: MockDaemon!
    var servicesProvider: MockSocialPlusServices!
    var cache: MockCache!
    var networkTracker: MockNetworkTracker!
    var appConfiguration: MockAppConfiguration!
    
    var sut = SocialPlus.shared
    
    override func setUp() {
        super.setUp()
        
        sessionStoreRepositoryProvider = makeSessionStoreRepositoryProvider()
        authorizationMulticast = MockAuthorizationMulticast()
        urlSchemeService = MockURLSchemeService()
        thirdPartyConfigurator = MockThirdPartyConfigurator()
        daemonsController = MockDaemon()
        cache = MockCache()
        networkTracker = MockNetworkTracker()
        appConfiguration = MockAppConfiguration()
        
        servicesProvider = MockSocialPlusServices()
        servicesProvider.getURLSchemeServiceReturnValue = urlSchemeService
        servicesProvider.getSessionStoreRepositoriesProviderReturnValue = sessionStoreRepositoryProvider
        servicesProvider.getThirdPartyConfiguratorReturnValue = thirdPartyConfigurator
        servicesProvider.getDaemonsControllerCacheReturnValue = daemonsController
        servicesProvider.getAuthorizationMulticastReturnValue = authorizationMulticast
        servicesProvider.getCoreDataStackReturnValue = CoreDataHelper.makeEmbeddedSocialInMemoryStack()
        servicesProvider.getCacheCoreDataStackReturnValue = cache
        servicesProvider.getNetworkTrackerReturnValue = networkTracker
        servicesProvider.getAppConfigurationReturnValue = appConfiguration
        servicesProvider.getStartupCommandsReturnValue = []
        
        urlSchemeService.openURLReturnValue = true
        
        sut.setupServices(with: servicesProvider)
    }
    
    override func tearDown() {
        super.tearDown()
        
        sessionStoreRepositoryProvider = nil
        authorizationMulticast = nil
        urlSchemeService = nil
        thirdPartyConfigurator = nil
        daemonsController = nil
        servicesProvider = nil
        cache = nil
        networkTracker = nil
        appConfiguration = nil
        
        sut.setupServices(with: SocialPlusServices())
    }
    
    func testThatURLIsOpened() {
        testThatURLIsOpened(openURLReturnValue: true)
        testThatURLIsOpened(openURLReturnValue: false)
    }
    
    func testThatURLIsOpened(openURLReturnValue: Bool) {
        // given
        let url = URL(string: "http://google.com")
        
        // when
        urlSchemeService.openURLReturnValue = openURLReturnValue
        let isOpened = sut.application(UIApplication.shared, open: url!, options: [:])
        
        // then
        XCTAssertEqual(openURLReturnValue, isOpened)
        XCTAssertTrue(urlSchemeService.openURLIsCalled)
    }
    
    func testThatItConfiguresAllServicesOnStartWithLoggedInUser() {
        // given
        let args = makeLaunchArguments()
        
        // when
        sut.start(launchArguments: args)
        
        // then
        validateThirdPartyConfiguratorCalled(with: args)
        
        XCTAssertTrue(daemonsController.startCalled)
        
        XCTAssertTrue(servicesProvider.getAuthorizationMulticastCalled)
        XCTAssertEqual(sut.authorization, authorizationMulticast.authorization)
        
        XCTAssertTrue(servicesProvider.getCoreDataStackCalled)
        
        XCTAssertTrue(servicesProvider.getCacheCoreDataStackCalled)
    }
    
    private func validateThirdPartyConfiguratorCalled(with args: LaunchArguments) {
        let receivedArgs = thirdPartyConfigurator.setupApplicationLaunchOptionsReceivedArguments
        XCTAssertEqual(receivedArgs?.application, args.app)
        XCTAssertTrue(NSDictionary(dictionary: receivedArgs?.launchOptions ?? [:]).isEqual(to: args.launchOptions))
    }
    
    private func makeSessionStoreRepositoryProvider() -> MockSessionStoreRepositoryProvider {
        let credentials = CredentialsList(provider: .facebook, accessToken: UUID().uuidString, socialUID: UUID().uuidString)
        let user = User(uid: UUID().uuidString, credentials: credentials)
        let sessionToken = UUID().uuidString
        
        let userRepo = MockKeyValueRepository<User>()
        userRepo.mementoToLoad = user.memento
        
        let sessionTokenRepo = MockKeyValueRepository<String>()
        sessionTokenRepo.mementoToLoad = sessionToken.memento
        
        return MockSessionStoreRepositoryProvider(userRepository: userRepo, sessionTokenRepository: sessionTokenRepo)
    }
    
    private func makeLaunchArguments() -> LaunchArguments {
        return LaunchArguments(app: UIApplication.shared,
                               window: UIWindow(),
                               launchOptions: [:],
                               menuHandler: nil,
                               menuConfiguration: .dual)
    }
}
