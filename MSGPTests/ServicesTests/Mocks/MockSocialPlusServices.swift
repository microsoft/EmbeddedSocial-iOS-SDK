//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation
@testable import MSGP

struct MockSocialPlusServices: SocialPlusServicesType {
    private let urlSchemeService: URLSchemeServiceType
    
    init(urlSchemeService: URLSchemeServiceType) {
        self.urlSchemeService = urlSchemeService
    }
    
    func getURLSchemeService() -> URLSchemeServiceType {
        return urlSchemeService
    }
    
    func getSessionStoreRepositoriesProvider() -> SessionStoreRepositoryProviderType {
        return SessionStoreRepositoryProvider()
    }
}
