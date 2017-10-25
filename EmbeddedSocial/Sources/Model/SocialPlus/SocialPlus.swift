//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation
import SnapKit

public final class SocialPlus {
    public static let shared = SocialPlus()
    
    fileprivate let queue = DispatchQueue(label: "Social Plus read-write queue")
    
    private(set) var serviceProvider: SocialPlusServicesType!

    private(set) var sessionStore: SessionStore!
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
    
    var sessionToken: String? {
        return sessionStore.sessionToken
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
        daemonsController = serviceProvider.getDaemonsController(cache: cache)
    }
    
    public func application(_ app: UIApplication, open url: URL, options: [AnyHashable: Any]) -> Bool {
        return serviceProvider.getURLSchemeService().application(app, open: url, options: options)
    }
    
    public func updateDeviceToken(devictToken: String) {
        UserDefaults.standard.setValue(devictToken, forKey: Constants.deviceTokenStorageKey)
        UserDefaults.standard.synchronize()
    }
    
    public func didReceiveRemoteNotification(data: [AnyHashable : Any]) {
        coordinator.openActivityScreen()
    }
    
    public func start(launchArguments args: LaunchArguments) {
        let startupCommands = serviceProvider.getStartupCommands(launchArgs: args)
        startupCommands.forEach { $0.execute() }
        networkTracker.startTracking()
        
        coordinator = CrossModuleCoordinator(cache: cache)
        coordinator.setup(launchArguments: args, loginHandler: self)
        
        if sessionStore.isLoggedIn {
            startSession(with: sessionStore.info!)
            if let deviceToken = UserDefaults.standard.string(forKey: Constants.deviceTokenStorageKey) {
                let service = PushNotificationsService()
                service.updateDeviceToken(deviceToken: deviceToken)
            }
        } else {
            coordinator.openPopularScreen()
        }
        
        let c = UpdateNotificationsStatusCommand(handle: UUID().uuidString)
        cache.cacheOutgoing(c)
    }
    
    fileprivate func startSession(with info: SessionInfo) {
        coordinator.onSessionCreated(with: info)
        authorizationMulticast.authorization = sessionStore.authorization
        daemonsController.start()
    }
}

extension SocialPlus: LoginModuleOutput {
    
    func onSessionCreated(with info: SessionInfo) {
        sessionStore.createSession(withUser: info.user, sessionToken: info.token)
        try? sessionStore.saveCurrentSession()
        startSession(with: info)
    }
}

extension SocialPlus: UserHolder {
    var me: User? {
        set {
            guard let newValue = newValue else { return }
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
        UIApplication.shared.unregisterForRemoteNotifications()
        UserDefaults.standard.set(nil, forKey: Constants.deviceTokenStorageKey)
        UserDefaults.standard.synchronize()
        daemonsController.stop()
        try? sessionStore.deleteCurrentSession()
        setupServices(with: SocialPlusServices())
        coreDataStack.reset { [weak self] result in
            guard let error = result.error else {
                self?.coordinator.logOut()
                return
            }
            
            self?.coordinator.showError(error)
        }
    }
}
