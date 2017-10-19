//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

typealias MenuItems = [SideMenuSectionModel]

public enum SideMenuType {
    case tab, dual, single
}

protocol SideMenuModuleInput: class {
    
    var user: User? { get set }
    func close()
    func openSocialItem(index: Int)
    func openMyProfile()
    func openLogin()
    
    /* Notifications */
    func updateNotificationsCount()
}

class SideMenuPresenter: SideMenuModuleInput, SideMenuViewOutput, SideMenuInteractorOutput {
    
    enum SideMenuTabs: Int {
        case client, social, none
    }
    
    var user: User? {
        didSet {
            selectedMenuItem = .none
            view.showAccountInfo(visible: accountViewAvailable)
            buildItems()
            view.reload()
        }
    }
    
    enum SelectedMenuItem: Equatable {
        case none
        case item(IndexPath, SideMenuTabs)
        case accountHeader
        
        static func == (lhs: SelectedMenuItem, rhs: SelectedMenuItem) -> Bool {
            switch (lhs, rhs) {
            case (.none, .none):
                return true
            case (let item(lhsPath, lhsTab), let item(rhsPath, rhsTab)) :
                return lhsPath == rhsPath && lhsTab == rhsTab
            case (.accountHeader, .accountHeader):
                return true
            default:
                return false
            }
        }
    }
    
    private var selectedMenuItem: SelectedMenuItem = .none {
        didSet {
            buildItems()
            view.reload()
            view.showAccountInfo(visible: accountViewAvailable)
        }
    }
    
    weak var view: SideMenuViewInput!
    var interactor: SideMenuInteractorInput!
    var router: SideMenuRouterInput!
    
    // Menu Configuration
    var configuration: SideMenuType = .tab {
        didSet {
            // Setting default tab
            tab = (configuration == .tab) ? .social : .none
        }
    }
    
    // Current Tab
    private var tab: SideMenuTabs = .none {
        didSet {
            buildItems()
            view.reload()
        }
    }
    
    private var accountViewAvailable: Bool {
        return !(configuration == .tab && tab == .client)
    }
    
    private var tabBarViewAvailable: Bool {
        return configuration == .tab
    }
    
    func accountInfo() -> SideMenuHeaderModel {
        
        let isSelected = selectedMenuItem == .accountHeader
        
        if let user = self.user, let firstname = user.firstName, let lastname = user.lastName {
            
            let accountName = "\(firstname) \(lastname)"
            
            return SideMenuHeaderModel(title: accountName, image: user.photo!, isSelected: isSelected)
        } else {
            let photo = Photo(image:(UIImage(asset: AppConfiguration.shared.theme.assets.userPhotoPlaceholder)))
            
            return SideMenuHeaderModel(title: L10n.SideMenu.signIn, image: photo, isSelected: isSelected)
        }
    }
    
    private var items = MenuItems()
    
    // MARK: View Output
    
    func viewDidAppear() {
        updateNotificationsCount()
    }
    
    func viewIsReady() {
        view.setupInitialState()
        buildItems()
        view.reload()
        view.showTabBar(visible: tabBarViewAvailable )
        view.showAccountInfo(visible: accountViewAvailable)
        if self.tab != .none {
            view.selectBar(with: tab.rawValue)
        }
    }
    
    func itemsCount(in section: Int) -> Int {
        return items[section].isCollapsed ? 0 : items[section].items.count
    }
    
    func sectionsCount() -> Int {
        return items.count
    }
    
    func section(with index: Int) -> SideMenuSectionModel {
        return items[index]
    }
    
    func item(at index: IndexPath) -> SideMenuItemModelProtocol {
        return items[index.section].items[index.row]
    }
    
    func headerTitle(for section: Int) -> String {
        return items[section].title
    }
    
    func didSwitch(to tab: Int) {
        assert(configuration == .tab)
        switch tab {
        case 0:
            self.tab = .client
        case 1:
            self.tab = .social
        default:
            fatalError("Unsupported")
        }
        view.showAccountInfo(visible: accountViewAvailable)
        view.selectBar(with: tab)
    }
    
    func didTapAccountInfo() {
        
        selectedMenuItem = .accountHeader
        
        if user == nil {
            router.openLoginScreen()
        } else {
            router.openMyProfile()
        }
    }
    
    func didToggleSection(with index: Int) {
        items[index].setCollapsed(collapsed: !items[index].isCollapsed)
        view.reload(section: index)
    }
    
    private func buildItems() {
        
        items = MenuItems()
        
        let collapsible = (configuration == .dual)
        
        let socialItems = interactor.socialMenuItems()
        let clientItems = interactor.clientMenuItems()
        let socialSection = SideMenuSectionModel(title: L10n.SideMenu.social,
                                                 collapsible: collapsible,
                                                 isCollapsed: false,
                                                 items: socialItems)
        let clientSection = SideMenuSectionModel(title: "Example App",
                                                 collapsible: collapsible,
                                                 isCollapsed: false,
                                                 items: clientItems)
        
        switch configuration {
        case .tab:
            switch tab {
            case .social:
                items.append(socialSection)
            case .client:
                items.append(clientSection)
            case .none:
                fatalError("Unexpected")
            }
            
        case .dual:
            items.append(contentsOf: [socialSection, clientSection])
        case .single:
            items.append(clientSection)
        }
        
        // Mark item as selected
        
        if case let .item(path, tab) = selectedMenuItem {
            if self.tab == tab {
                items[path.section].items[path.row].isSelected = true
            }
        }
    }
    
    func didSelectItem(with path: IndexPath) {
        
        selectedMenuItem = .item(path, tab)
        
        let index = path.row
        
        switch configuration {
        case .tab:
            
            switch tab {
            case .social:
                router.open(interactor.targetForSocialMenuItem(with: index))
            case .client:
                router.open(interactor.targetForClientMenuItem(with: index))
            case .none:
                fatalError("Unexpected")
            }
            
        case .dual:
            if path.section == 0 {
                router.open(interactor.targetForSocialMenuItem(with: path.row))
            } else if path.section == 1 {
                router.open(interactor.targetForClientMenuItem(with: path.row))
            }
        case .single:
            router.open(interactor.targetForSocialMenuItem(with: index))
        }
    }
    
    // MARK: Module Input
    func openLogin() {
        selectedMenuItem = .accountHeader
        router.openLoginScreen()
    }
    
    func openMyProfile() {
        
        selectedMenuItem = .accountHeader
        
        if user == nil {
            router.openLoginScreen()
        } else {
            router.openMyProfile()
        }
    }
    
    private func getSocialItemIndexPath(index: Int, configuation: SideMenuType) -> IndexPath {
        switch configuration {
        case .tab, .single:
            return IndexPath(row: index, section: 0)
            
        case .dual:
            return IndexPath(row: index, section: 0)
        }
    }
    
    func openSocialItem(index: Int) {
        
        let viewController = interactor.targetForSocialMenuItem(with: index)
        router.open(viewController)
        
        let itemPath = getSocialItemIndexPath(index: index, configuation: configuration)
        
        selectedMenuItem = .item(itemPath, tab)
        view.reload()
    }
    
    func close() {
        router.close()
    }
    
    // MARK: Notifications
    
    private func stringFromNotificationsCount(_ count: UInt32) -> String? {
       
        if count >= 1 && count <= 99 {
            return "\(count)"
        }
        else if count > 99{
            return "99+"
        }
        else {
            return nil
        }
    }
    
    private func updateNotification(count: UInt32) {
        
        // due to menu state activity activity item can be unavailable
        guard let itemIndex = interactor.getSocialItemIndex(for: .activity) else {
            return
        }
        
        let itemPath = getSocialItemIndexPath(index: itemIndex, configuation: configuration)
        let item = items[itemPath.section].items[itemPath.row]
        guard let notificationItem = item  as? SideMenuItemModelWithNotification else {
            fatalError("Model mismatch")
        }
        
        // update model
        notificationItem.countText = stringFromNotificationsCount(count)
        
        // update UI
        view.reload(item: itemPath)
    }
    
    func updateNotificationsCount() {
        interactor.getNotificationsCount { [weak self] (result) in
 
            switch result {
            case .success(let count):
                self?.updateNotification(count: count)
            case .failure(let error):
                Logger.log(error, event: .veryImportant)
            }
        }
    }
}
