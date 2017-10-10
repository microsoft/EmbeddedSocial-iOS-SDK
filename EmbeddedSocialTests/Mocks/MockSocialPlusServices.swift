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
    
    var getAuthorizationMulticastAppKeyCalled = false
    var getAuthorizationMulticastAppKeyReceivedAppKey: String?
    var getAuthorizationMulticastAppKeyReturnValue: AuthorizationMulticastType!
    
    func getAuthorizationMulticast(appKey: String) -> AuthorizationMulticastType {
        getAuthorizationMulticastAppKeyCalled = true
        getAuthorizationMulticastAppKeyReceivedAppKey = appKey
        return getAuthorizationMulticastAppKeyReturnValue
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
    
    //MARK: - getAppConfiguration
    
    var getAppConfigurationConfigFilenameCalled = false
    var getAppConfigurationConfigFilenameReceivedConfigFilename: String?
    var getAppConfigurationConfigFilenameReturnValue: AppConfigurationType!
    
    func getAppConfiguration(configFilename: String) -> AppConfigurationType {
        getAppConfigurationConfigFilenameCalled = true
        getAppConfigurationConfigFilenameReceivedConfigFilename = configFilename
        return getAppConfigurationConfigFilenameReturnValue
    }
    
    //MARK: - getStartupCommands
    
    var getStartupCommandsLaunchArgsSettingsCalled = false
    var getStartupCommandsLaunchArgsSettingsReceivedArguments: (launchArgs: LaunchArguments, settings: Settings)?
    var getStartupCommandsLaunchArgsSettingsReturnValue: [Command]!
    
    func getStartupCommands(launchArgs: LaunchArguments, settings: Settings) -> [Command] {
        getStartupCommandsLaunchArgsSettingsCalled = true
        getStartupCommandsLaunchArgsSettingsReceivedArguments = (launchArgs: launchArgs, settings: settings)
        return getStartupCommandsLaunchArgsSettingsReturnValue
    }
    
}
