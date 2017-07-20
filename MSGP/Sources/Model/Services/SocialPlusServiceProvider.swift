//
//  SocialPlusServiceProvider.swift
//  MSGP
//
//  Created by Vadim Bulavin on 7/20/17.
//  Copyright © 2017 Akvelon. All rights reserved.
//

import Foundation

protocol URLSchemeServiceType {
    func application(_ app: UIApplication, open url: URL, options: [AnyHashable: Any]) -> Bool
}

protocol SocialPlusServicesType {
    func getURLSchemeService() -> URLSchemeServiceType
    
    func getDatabaseFacadeServicesProvider() -> DatabaseFacadeServicesProviderType
}

struct SocialPlusServices: SocialPlusServicesType {
    func getURLSchemeService() -> URLSchemeServiceType {
        return URLSchemeService()
    }
    
    func getDatabaseFacadeServicesProvider() -> DatabaseFacadeServicesProviderType {
        return DatabaseFacadeServicesProvider()
    }
}
