//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

protocol URLSchemeServiceType {
    func application(_ app: UIApplication, open url: URL, options: [AnyHashable: Any]) -> Bool
}

protocol SocialPlusServicesType {
    func getURLSchemeService() -> URLSchemeServiceType
    
    func getSessionStoreRepositoriesProvider() -> SessionStoreRepositoryProviderType
    
    func getThirdPartyConfigurator() -> ThirdPartyConfiguratorType
    
    func getCoreDataStack() -> CoreDataStack
    
    func getCache(coreDataStack: CoreDataStack) -> CacheType
    
    func getNetworkTracker() -> NetworkTrackerType
}

struct SocialPlusServices: SocialPlusServicesType {
    func getURLSchemeService() -> URLSchemeServiceType {
        return URLSchemeService()
    }
    
    func getSessionStoreRepositoriesProvider() -> SessionStoreRepositoryProviderType {
        return SessionStoreRepositoryProvider()
    }
    
    func getThirdPartyConfigurator() -> ThirdPartyConfiguratorType {
        return ThirdPartyConfigurator()
    }
    
    func getCoreDataStack() -> CoreDataStack {
        let model = CoreDataModel(name: "EmbeddedSocial", bundle: Bundle(for: SocialPlus.self))
        let builder = CoreDataStackBuilder(model: model)
        let result = builder.makeStack()
        
        switch result {
        case let .success(stack):
            return stack
        case let .failure(error):
            fatalError(error.localizedDescription)
        }
    }
    
    func getCache(coreDataStack stack: CoreDataStack) -> CacheType {
        let database = TransactionsDatabaseFacade(incomingRepo: CoreDataRepository(context: stack.backgroundContext),
                                                  outgoingRepo: CoreDataRepository(context: stack.backgroundContext))
        return Cache(database: database)
    }
    
    func getNetworkTracker() -> NetworkTrackerType {
        return NetworkTracker()
    }
}
