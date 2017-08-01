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
    
    fileprivate let queue = DispatchQueue(label: "Social Plus read-write queue")
    
    private init() {
        setupServices(with: SocialPlusServices())
    }
    
    func setupServices(with serviceProvider: SocialPlusServicesType) {
        self.serviceProvider = serviceProvider
        let database = SessionStoreDatabaseFacade(services: serviceProvider.getSessionStoreRepositoriesProvider())
        sessionStore = SessionStore(database: database)
        try? sessionStore.loadLastSession()
    }
    
    public func application(_ app: UIApplication, open url: URL, options: [AnyHashable: Any]) -> Bool {
        return serviceProvider.getURLSchemeService().application(app, open: url, options: options)
    }
    
    public func start(launchArguments args: LaunchArguments) {
        serviceProvider.getThirdPartyConfigurator().setup(application: args.app, launchOptions: args.launchOptions)
        coordinator.setup(launchArguments: args, loginHandler: self)
        setupCoreDataStack()
        setupCache(stack: coreDataStack)
        
        if sessionStore.isLoggedIn {
            APISettings.shared.customHeaders = sessionStore.user.credentials?.authHeader ?? [:]
            coordinator.onSessionCreated(user: sessionStore.user, sessionToken: sessionStore.sessionToken)
        } else {
            APISettings.shared.customHeaders = APISettings.shared.anonymousHeaders
        }
    }
    
    private func setupCoreDataStack() {
        let model = CoreDataModel(name: "EmbeddedSocial", bundle: Bundle(for: type(of: self)))
        let builder = CoreDataStackBuilder(model: model)
        coreDataStack = builder.makeStack().value
    }
    
    private func setupCache(stack: CoreDataStack) {
        let database = TransactionsDatabaseFacade(incomingRepo: CoreDataRepository(context: stack.backgroundContext),
                                                  outgoingRepo: CoreDataRepository(context: stack.backgroundContext))
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

extension SocialPlus: UserHolder {
    var me: User {
        set {
            queue.async {
                self.sessionStore.user = newValue
                try? self.sessionStore.saveCurrentSession()
            }
        }
        get {
            return queue.sync { sessionStore.user }
        }
    }
}
