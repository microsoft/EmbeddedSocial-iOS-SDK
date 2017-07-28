//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation
@testable import MSGP

struct MockSocialPlusServices: SocialPlusServicesType {
    private let urlSchemeService: URLSchemeServiceType
    private let sessionStoreRepositoriesProvider: SessionStoreRepositoryProviderType
    
    var thirdPartyConfigurator: ThirdPartyConfiguratorType = MockThirdPartyConfigurator()

    init(urlSchemeService: URLSchemeServiceType, sessionStoreRepositoriesProvider: SessionStoreRepositoryProviderType) {
        self.urlSchemeService = urlSchemeService
        self.sessionStoreRepositoriesProvider = sessionStoreRepositoriesProvider
    }
    
    func getURLSchemeService() -> URLSchemeServiceType {
        return urlSchemeService
    }
    
    func getSessionStoreRepositoriesProvider() -> SessionStoreRepositoryProviderType {
        return sessionStoreRepositoriesProvider
    }
    
    func getThirdPartyConfigurator() -> ThirdPartyConfiguratorType {
        return thirdPartyConfigurator
    }
}
