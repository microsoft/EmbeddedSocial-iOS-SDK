//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

public final class SocialPlus {
    public static let shared = SocialPlus()
    
    private(set) var sessionStore: SessionStore!
    fileprivate var serviceProvider: SocialPlusServicesType!
    
    fileprivate let coordinator = CrossModuleCoordinator()

    private init() {
        setupServices(with: SocialPlusServices())
        try? sessionStore.loadLastSession()
    }
    
    func setupServices(with serviceProvider: SocialPlusServicesType) {
        self.serviceProvider = serviceProvider
        let database = SessionStoreDatabaseFacade(services: serviceProvider.getSessionStoreRepositoriesProvider())
        sessionStore = SessionStore(database: database)
    }
    
    public func application(_ app: UIApplication, open url: URL, options: [AnyHashable: Any]) -> Bool {
        return serviceProvider.getURLSchemeService().application(app, open: url, options: options)
    }
    
    public func start(launchArguments args: LaunchArguments) {
        ThirdPartyConfigurator.setup(application: args.app, launchOptions: args.launchOptions)
        coordinator.setup(launchArguments: args, loginHandler: self)
        if sessionStore.isLoggedIn {
            // FIXME: Handle navigation for logged in user
        }
    }
}

extension SocialPlus: LoginModuleOutput {
    
    func onSessionCreated(user: User, sessionToken: String) {
        sessionStore.createSession(withUser: user, sessionToken: sessionToken)
        try? sessionStore.saveCurrentSession()
        coordinator.onSessionCreated(user: user, sessionToken: sessionToken)
    }
}
