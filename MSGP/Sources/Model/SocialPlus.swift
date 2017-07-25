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
    private(set) var coreDataStack: CoreDataStack!
    
    private(set) var cache: Cache!

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
        setupCoreDataStack()
        setupCache()
        
        if sessionStore.isLoggedIn {
            // FIXME: coordinator.onSessionCreated crashes if uncommented
            // coordinator.onSessionCreated(user: sessionStore.user, sessionToken: sessionStore.sessionToken)
        }
    }
    
    private func setupCoreDataStack() {
        let model = CoreDataModel(name: "MSGP", bundle: Bundle(for: type(of: self)))
        let builder = CoreDataStackFactory(model: model)
        
        builder.makeStack { [unowned self] result in
            guard let stack = result.value else {
                fatalError("*** Cannot set up Core Data stack")
            }
            self.coreDataStack = stack
        }
    }
    
    private func setupCache() {
        let incomingTransaction = QueriableRepository<IncomingTransaction>()
        let outgoingTransaction = QueriableRepository<OutgoingTransaction>()
        let database = TransactionsDatabaseFacade(incomingRepo: incomingTransaction, outgoingRepo: outgoingTransaction)
        cache = Cache(database: database)
    }
}

extension SocialPlus: LoginModuleOutput {
    
    func onSessionCreated(user: User, sessionToken: String) {
        sessionStore.createSession(withUser: user, sessionToken: sessionToken)
        try? sessionStore.saveCurrentSession()
        coordinator.onSessionCreated(user: user, sessionToken: sessionToken)
    }
}
