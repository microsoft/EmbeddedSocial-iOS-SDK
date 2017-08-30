//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation
import SnapKit

public final class SocialPlus {
    public static let shared = SocialPlus()
    
    fileprivate let queue = DispatchQueue(label: "Social Plus read-write queue")

    private(set) var sessionStore: SessionStore!
    private(set) var serviceProvider: SocialPlusServicesType!
    private(set) var coordinator: CrossModuleCoordinator!
    private(set) var coreDataStack: CoreDataStack!
    private(set) var cache: CacheType!
    private(set) var networkTracker: NetworkTrackerType!
    
    var authorization: Authorization {
        return sessionStore.authorization
    }
    
    private init() {
        setupServices(with: SocialPlusServices())
        coreDataStack = serviceProvider.getCoreDataStack()
        cache = serviceProvider.getCache(coreDataStack: coreDataStack)
        networkTracker = serviceProvider.getNetworkTracker()
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
        _ = APISettings.shared
        networkTracker.startTracking()
        
        coordinator = CrossModuleCoordinator(cache: cache)
        coordinator.setup(launchArguments: args, loginHandler: self)
        
        if sessionStore.isLoggedIn {
            coordinator.onSessionCreated(user: sessionStore.user!, sessionToken: sessionStore.sessionToken!)
        } else {
            coordinator.openPopularScreen()
        }
        
        let service = SocialService()
        service.getMyFollowers(cursor: nil, limit: 30) { result in
            withExtendedLifetime(service) {
                print(result)
            }
        }
    }
    
    private func setupCoreDataStack() {
        let model = CoreDataModel(name: "EmbeddedSocial", bundle: Bundle(for: type(of: self)))
        let builder = CoreDataStackBuilder(model: model)
        coreDataStack = builder.makeStack().value
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
    var me: User? {
        set {
            guard let newValue = newValue, newValue != me else { return }
            queue.async {
                self.sessionStore.updateSession(withUser: newValue)
                try? self.sessionStore.saveCurrentSession()
                DispatchQueue.main.async {
                    self.coordinator.updateUser(newValue)
                }
            }
        }
        get {
            return queue.sync { sessionStore.user }
        }
    }
}

extension SocialPlus: LogoutController {
    func logOut(with error: Error) {
        logOut()
        coordinator.showError(error)
    }
    
    func logOut() {
        try? sessionStore.deleteCurrentSession()
        setupServices(with: SocialPlusServices())
        coordinator.logOut()
    }
}
