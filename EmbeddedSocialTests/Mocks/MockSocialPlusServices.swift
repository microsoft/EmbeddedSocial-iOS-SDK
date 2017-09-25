//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation
@testable import EmbeddedSocial

class MockSocialPlusServices: SocialPlusServicesType {
    
    //MARK: - getURLSchemeService
    
    var getURLSchemeServiceCalled = false
    var getURLSchemeServiceReturnValue: URLSchemeServiceType!
    
    func getURLSchemeService() -> URLSchemeServiceType {
        getURLSchemeServiceCalled = true
        return getURLSchemeServiceReturnValue
    }
    
    //MARK: - getSessionStoreRepositoriesProvider
    
    var getSessionStoreRepositoriesProviderCalled = false
    var getSessionStoreRepositoriesProviderReturnValue: SessionStoreRepositoryProviderType!
    
    func getSessionStoreRepositoriesProvider() -> SessionStoreRepositoryProviderType {
        getSessionStoreRepositoriesProviderCalled = true
        return getSessionStoreRepositoriesProviderReturnValue
    }
    
    //MARK: - getThirdPartyConfigurator
    
    var getThirdPartyConfiguratorCalled = false
    var getThirdPartyConfiguratorReturnValue: ThirdPartyConfiguratorType!
    
    func getThirdPartyConfigurator() -> ThirdPartyConfiguratorType {
        getThirdPartyConfiguratorCalled = true
        return getThirdPartyConfiguratorReturnValue
    }
    
    //MARK: - getCoreDataStack
    
    var getCoreDataStackCalled = false
    var getCoreDataStackReturnValue: CoreDataStack!
    
    func getCoreDataStack() -> CoreDataStack {
        getCoreDataStackCalled = true
        return getCoreDataStackReturnValue
    }
    
    //MARK: - getCache
    
    var getCacheCoreDataStackCalled = false
    var getCacheCoreDataStackReceivedCoreDataStack: CoreDataStack?
    var getCacheCoreDataStackReturnValue: CacheType!
    
    func getCache(coreDataStack: CoreDataStack) -> CacheType {
        getCacheCoreDataStackCalled = true
        getCacheCoreDataStackReceivedCoreDataStack = coreDataStack
        return getCacheCoreDataStackReturnValue
    }
    
    //MARK: - getNetworkTracker
    
    var getNetworkTrackerCalled = false
    var getNetworkTrackerReturnValue: NetworkTrackerType!
    
    func getNetworkTracker() -> NetworkTrackerType {
        getNetworkTrackerCalled = true
        return getNetworkTrackerReturnValue
    }
    
    //MARK: - getAuthorizationMulticast
    
    var getAuthorizationMulticastCalled = false
    var getAuthorizationMulticastReturnValue: AuthorizationMulticastType!
    
    func getAuthorizationMulticast() -> AuthorizationMulticastType {
        getAuthorizationMulticastCalled = true
        return getAuthorizationMulticastReturnValue
    }
    
    //MARK: - getDaemonsController
    
    var getDaemonsControllerCacheCalled = false
    var getDaemonsControllerCacheReceivedCache: CacheType?
    var getDaemonsControllerCacheReturnValue: Daemon!
    
    func getDaemonsController(cache: CacheType) -> Daemon {
        getDaemonsControllerCacheCalled = true
        getDaemonsControllerCacheReceivedCache = cache
        return getDaemonsControllerCacheReturnValue
    }
    
}

/*final class MockSocialPlusServices: SocialPlusServicesType {
    
    var thirdPartyConfigurator: ThirdPartyConfiguratorType!
    var urlSchemeService: URLSchemeServiceType!
    var sessionStoreRepositoriesProvider: SessionStoreRepositoryProviderType!
    var authorizationMulticast: AuthorizationMulticastType!
    
    func getURLSchemeService() -> URLSchemeServiceType {
        return urlSchemeService
    }
    
    func getSessionStoreRepositoriesProvider() -> SessionStoreRepositoryProviderType {
        return sessionStoreRepositoriesProvider
    }
    
    func getThirdPartyConfigurator() -> ThirdPartyConfiguratorType {
        return thirdPartyConfigurator
    }
    
    func getCoreDataStack() -> CoreDataStack {
        return CoreDataHelper.makeEmbeddedSocialInMemoryStack()
    }
    
    func getCache(coreDataStack stack: CoreDataStack) -> CacheType {
        let database = TransactionsDatabaseFacade(incomingRepo: CoreDataRepository(context: stack.backgroundContext),
                                                  outgoingRepo: CoreDataRepository(context: stack.backgroundContext))
        return Cache(database: database)
    }
    
    func getNetworkTracker() -> NetworkTrackerType {
        return NetworkTracker()
    }
    
    func getAuthorizationMulticast() -> AuthorizationMulticastType {
        return authorizationMulticast!
    }
    
    var getDaemonsControllerCalled = false
    var getDaemonsControllerInputCache: CacheType?
    var getDaemonsControllerReturnValue: Daemon = MockDaemon()
    
    func getDaemonsController(cache: CacheType) -> Daemon {
        getDaemonsControllerCalled = true
        getDaemonsControllerInputCache = cache
        return getDaemonsControllerReturnValue
    }
}
*/
