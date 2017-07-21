//
//  MockSocialPlusServices.swift
//  MSGP
//
//  Created by Vadim Bulavin on 7/20/17.
//  Copyright © 2017 Akvelon. All rights reserved.
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
