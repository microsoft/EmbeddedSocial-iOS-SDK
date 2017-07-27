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
//        let image = UIImage(asset: .userPhotoPlaceholder)
//        let credentials = CredentialsList(provider: .facebook, accessToken: "", socialUID: "")
//        let me = User(uid: UUID().uuidString,
//                      firstName: "Sergei",
//                      lastName: "Larionov",
//                      email: nil,
//                      bio: "Seattle-based designer, world-class dude.",
//                      photo: Photo(image: image),
//                      credentials: credentials,
//                      followersCount: 12,
//                      followingCount: 16,
//                      visibility: ._public,
//                      followerStatus: nil,
//                      followingStatus: nil)
//        let configurator = UserProfileConfigurator()
//        configurator.configure(userID: nil, me: me)
//        
//        let navController = UINavigationController(rootViewController: configurator.viewController)
//        navController.navigationBar.isTranslucent = false
//        args.window.rootViewController = navController
        
        ThirdPartyConfigurator.setup(application: args.app, launchOptions: args.launchOptions)
        coordinator.setup(launchArguments: args, loginHandler: self)
        setupCoreDataStack()
        setupCache(stack: coreDataStack)
        
        if sessionStore.isLoggedIn {
        APISettings.shared.customHeaders = sessionStore.user.credentials.authHeader
            coordinator.onSessionCreated(user: sessionStore.user, sessionToken: sessionStore.sessionToken)
        }
    }
    
    private func setupCoreDataStack() {
        let model = CoreDataModel(name: "MSGP", bundle: Bundle(for: type(of: self)))
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
