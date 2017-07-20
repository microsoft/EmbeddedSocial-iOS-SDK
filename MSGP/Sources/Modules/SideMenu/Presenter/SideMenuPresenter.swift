//
//  SideMenuSideMenuPresenter.swift
//  MSGP-Framework
//
//  Created by igor.popov on 17/07/2017.
//  Copyright © 2017 akvelon. All rights reserved.
//

typealias MenuItems = [SideMenuSectionModel]

public enum SideMenuType {
    case tab, dual, single
}

class SideMenuPresenter: SideMenuModuleInput, SideMenuViewOutput, SideMenuInteractorOutput {

    func accountInfo() -> SideMenuHeaderModel? {
        
        guard let user = self.user else {
            return nil
        }
        
        guard let firstname = user.firstName, let lastname = user.lastName else {
            return nil
        }
        
        guard let accountPhoto = user.photo else {
            return nil
        }
        
        let accountName = "\(firstname) \(lastname)"
        
        return SideMenuHeaderModel(accountName: accountName, accountPhoto: accountPhoto)
    }
    
    enum SideMenuTabs: Int {
        case client, social
    }
    
    var user: User?
    weak var view: SideMenuViewInput!
    var interactor: SideMenuInteractorInput!
    var router: SideMenuRouterInput!
    var configation: SideMenuType! {
        didSet {
            tab = (configation == .tab) ? .social : nil
        }
    }
    
    var tab: SideMenuTabs? {
        didSet {
            buildItems()
            view.reload()
        }
    }
    
    var accountViewAvailable: Bool {
        return !(configation == .tab && tab == .client) && (user != nil)
    }
    
    var items = MenuItems()
    
    func viewIsReady() {
        view.setupInitialState()
        buildItems()
        view.reload()
        view.showTabBar(visible: configation == .tab)
        view.showAccountInfo(visible: accountViewAvailable)
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
        assert(configation == .tab)
        self.tab = SideMenuTabs(rawValue: tab)
        view.showAccountInfo(visible: accountViewAvailable)
    }
    
    func didToggleSection(with index: Int) {
        items[index].setCollapsed(collapsed: !items[index].isCollapsed)
        view.reload(section: index)
    }
    
    func showUser(user: User) {
        self.user = user
        view.showAccountInfo(visible: accountViewAvailable)
        buildItems()
        view.reload()
    }
    
    func buildItems() {
        
        items = MenuItems()
        
        let collapsible = (configation == .dual)
        
        let socialItems = interactor.socialMenuItems()
        let clientItems = interactor.clientMenuItems()
        let socialSection = SideMenuSectionModel(title: "Social",
                                                 collapsible: collapsible,
                                                 isCollapsed: false,
                                                 items: socialItems)
        let clientSection = SideMenuSectionModel(title: "Example App",
                                                 collapsible: collapsible,
                                                 isCollapsed: false,
                                                 items: clientItems)
        
        switch configation! {
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
        
        if path.section == 0 {
            router.open(viewController: interactor.targetForSocialMenuItem(with: path.row), sender: view)
        } else if path.section == 1 {
            router.open(viewController: interactor.targetForClientMenuItem(with: path.row), sender: view)
        }
    }
    
    // MARK: Module Input
    
    func open(viewController: UIViewController) {
        router.open(viewController: viewController, sender: view)
    }
}
