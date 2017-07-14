//
//  File.swift
//  MSGP
//
//  Created by Igor Popov on 7/11/17.
//  Copyright © 2017 Igor Popov. All rights reserved.
//

import Foundation
import SlideMenuControllerSwift

public enum NavigationStackFormat {
    case tab, dual, single
}

class NavigationStack {
    
    enum StoryboardItems: String {
        case container = "NavigationStackContainer"
        case menu = "NavigationStackMenu"
        case tab = "TabMenuContainerViewController"
        
        func identifier() -> String {
            return self.rawValue
        }
    }
    
    var navigationController: UINavigationController?
    var presenter: SlideMenuController?
    var menu: UIViewController?
    var container: UIViewController?
    var window: UIWindow?
    
    var storyboard: UIStoryboard {
        return UIStoryboard(name: "MenuStack", bundle: Bundle(for: type(of: self)))
    }
    
    var format: NavigationStackFormat?
    
    init(window: UIWindow, format: NavigationStackFormat = .single) {
        
        self.window = window
        
        self.container = self.storyboard.instantiateViewController(withIdentifier: StoryboardItems.container.identifier())
        self.navigationController = UINavigationController(rootViewController: self.container!)
        self.menu = instantiateViewController(with: format)
        self.presenter = SlideMenuController(mainViewController: self.navigationController!, leftMenuViewController: self.menu!)
        
        window.rootViewController = self.presenter
        self.window?.backgroundColor = UIColor(red: 236.0, green: 238.0, blue: 241.0, alpha: 1.0)
    }
    
    func instantiateViewController(with format: NavigationStackFormat) -> UIViewController {
        
        switch format {
        case .single:
            return storyboard.instantiateViewController(withIdentifier: StoryboardItems.menu.identifier())
        case .tab:
            return storyboard.instantiateViewController(withIdentifier: StoryboardItems.tab.identifier())
            
        default:
            assert(false)
        }
    }
    
    
}
