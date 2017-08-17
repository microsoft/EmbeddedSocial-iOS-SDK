//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

typealias MenuItems = [SideMenuSectionModel]

public enum SideMenuType {
    case tab, dual, single
}

class SideMenuPresenter: SideMenuModuleInput, SideMenuViewOutput, SideMenuInteractorOutput {
    
    enum SideMenuTabs: Int {
        case client, social
    }
    
    var user: User? {
        didSet {
            view.showAccountInfo(visible: accountViewAvailable)
            buildItems()
            view.reload()
        }
    }
    
    weak var view: SideMenuViewInput!
    var interactor: SideMenuInteractorInput!
    var router: SideMenuRouterInput!
    var configuration: SideMenuType = .tab {
        didSet {
            tab = (configuration == .tab) ? .social : nil
        }
    }
    
    var tab: SideMenuTabs? {
        didSet {
            buildItems()
            view.reload()
        }
    }
    
    var accountViewAvailable: Bool {
        return !(configuration == .tab && tab == .client)
    }
    
    var tabBarViewAvailable: Bool {
        return configuration == .tab
    }
    
    func accountInfo() -> SideMenuHeaderModel {
        
        if let user = self.user, let firstname = user.firstName, let lastname = user.lastName {
            
            let accountName = "\(firstname) \(lastname)"
            
            return SideMenuHeaderModel(title: accountName, image: user.photo!)
        } else {
            let photo = Photo(image:(UIImage(asset: .userPhotoPlaceholder)))
            
            return SideMenuHeaderModel(title: L10n.SideMenu.signIn, image: photo)
        }
    }
    
    var items = MenuItems()
    
    func viewIsReady() {
        view.setupInitialState()
        buildItems()
        view.reload()
        view.showTabBar(visible: tabBarViewAvailable )
        view.showAccountInfo(visible: accountViewAvailable)
        if let tab = self.tab {
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
    
    func item(at index: IndexPath) -> SideMenuItemModel {
        return items[index.section].items[index.row]
    }
    
    func headerTitle(for section: Int) -> String {
        return items[section].title
    }
    
    func didSwitch(to tab: Int) {
        assert(configuration == .tab)
        self.tab = SideMenuTabs(rawValue: tab)
        view.showAccountInfo(visible: accountViewAvailable)
        view.selectBar(with: self.tab!.rawValue)
    }
    
    func didTapAccountInfo() {
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

    func buildItems() {
        
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
            
            switch tab! {
            case .social:
                items.append(socialSection)
            case .client:
                items.append(clientSection)
            }
            
        case .dual:
            items.append(contentsOf: [socialSection, clientSection])
        case .single:
            items.append(clientSection)
        }
    }
    
    func didSelectItem(with path: IndexPath) {
        
        let index = path.row
        
        switch configuration {
        case .tab:
            
            switch tab! {
            case .social:
                router.open(viewController: interactor.targetForSocialMenuItem(with: index), sender: view)
            case .client:
                router.open(viewController: interactor.targetForClientMenuItem(with: index), sender: view)
            }
            
        case .dual:
            if path.section == 0 {
                router.open(viewController: interactor.targetForSocialMenuItem(with: path.row), sender: view)
            } else if path.section == 1 {
                router.open(viewController: interactor.targetForClientMenuItem(with: path.row), sender: view)
            }
        case .single:
           router.open(viewController: interactor.targetForSocialMenuItem(with: index), sender: view)
        }
}
    
    // MARK: Module Input
    
    func open(viewController: UIViewController) {
        router.open(viewController: viewController, sender: view)
    }
    
    func close() {
        router.close()
    }
}
