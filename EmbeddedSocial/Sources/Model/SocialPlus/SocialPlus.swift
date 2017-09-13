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
    fileprivate(set) var authorizationMulticast: AuthorizationMulticastType!
    private(set) var daemonsController: Daemon!
    
    var networkTracker: NetworkTrackerType {
        return serviceProvider.getNetworkTracker()
    }
    
    var authorization: Authorization {
        return sessionStore.authorization
    }
    
    private init() {
        setupServices(with: SocialPlusServices())
    }
    
    func setupServices(with serviceProvider: SocialPlusServicesType) {
        self.serviceProvider = serviceProvider
        
        let database = SessionStoreDatabaseFacade(services: serviceProvider.getSessionStoreRepositoriesProvider())
        sessionStore = SessionStore(database: database)
        try? sessionStore.loadLastSession()
        
        coreDataStack = serviceProvider.getCoreDataStack()
        cache = serviceProvider.getCache(coreDataStack: coreDataStack)
        authorizationMulticast = serviceProvider.getAuthorizationMulticast()
        authorizationMulticast.authorization = sessionStore.authorization
        daemonsController = serviceProvider.getDaemonsController(cache: cache)
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
    }
}

extension SocialPlus: LoginModuleOutput {
    
    func onSessionCreated(with info: SessionInfo) {
        sessionStore.createSession(withUser: info.user, sessionToken: info.token)
        try? sessionStore.saveCurrentSession()
        coordinator.onSessionCreated(with: info)
        authorizationMulticast.authorization = sessionStore.authorization
        daemonsController.start()
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
        daemonsController.stop()
        try? sessionStore.deleteCurrentSession()
        setupServices(with: SocialPlusServices())
        coordinator.logOut()
    }
}
