//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest
import Nimble
import Quick
@testable import EmbeddedSocial

class SideMenuPresenterTest: QuickSpec {
    
    
    var view: MockViewController!
    var interactor: SideMenuInteractorInput!
    var router: MockRouter!
    var presenter: SideMenuPresenter!
    
    
    override func spec() {
        
        beforeSuite {
       
            
            self.router = MockRouter()
            self.interactor = MockInteractor()
            self.view = MockViewController()
            
            self.presenter = SideMenuPresenter()
            self.presenter.view = self.view
            self.presenter.router = self.router as SideMenuRouterInput!
            self.presenter.interactor = self.interactor
            
            self.view.output = self.presenter
        }
        
        describe("when module is initialized with dual") {
            
            beforeEach {
                self.presenter.configation = .dual
                self.presenter.viewIsReady()
            }
            
            
            it("dual mode should have tab bar") {
                expect(self.view.didShowTabBar).to(beTruthy())
            }
            
            context("when we are on social") {
                
                it("should show social tab by default with account info") {
                    expect(self.view.didShowAccountInfo).to(beTruthy())
                }
                
                it("should have single section") {
                    expect(self.view.numberOfSections()).to(equal(1))
                }
            }
            
            context("when we are on client tab") {
                
                presenter.didSwitch(to: 0)
                
                it("should switch tab") {
                    expect(self.presenter.tab).to(equal(.client))
                }
                
                it("should have single section") {
                    expect(self.view.numberOfSections()).to(equal(1))
                }
                
                it("should have no social header") {
                    expect(self.view.isAccountInfoVisible).to(beFalsy())
                }
            }
            
            
        }
        
        describe("when module is initialized with single") {
            
            self.presenter.configation = .single
            self.presenter.viewIsReady()
            
            it("should build ") {
                
            }
        }
        
    }
}

class MockInteractor: SideMenuInteractorInput {
    
    func socialMenuItems() -> [MenuItemModel] {
        return [MenuItemModel(title: "social item 1", image: UIImage())]
    }
    
    func clientMenuItems() -> [MenuItemModel] {
        return [MenuItemModel(title: "client item 1", image: UIImage())]
    }
    
    func targetForSocialMenuItem(with index: Int) -> UIViewController {
        return UIViewController()
    }
    
    func targetForClientMenuItem(with index: Int) -> UIViewController {
        return UIViewController()
    }
}

class MockRouter: SideMenuRouterInput {
    
    var didOpen = false
    var openedController: UIViewController?
    
    func open(viewController: UIViewController) {
        openedController = viewController
        didOpen = true
    }
}

class MockViewController: SideMenuViewInput {
    
    func reload() {
        
    }
    
    func reload(section: Int) {
        
    }
    
    var didReload = false
    var didReloadTimes = 0
    var didShowTabBar = false
    var didShowAccountInfo = false
    var didSetupInitialState = false
    var output: SideMenuViewOutput!
    
    var isTabBarVisible = false
    var isAccountInfoVisible = false
    
    func showTabBar(visible: Bool) {
        isTabBarVisible = visible
    }
    
    func showAccountInfo(visible: Bool) {
        isAccountInfoVisible = visible
    }
    
    func setupInitialState() {
        didSetupInitialState = true
    }
    
    func numberOfSections() -> Int {
        return output.sectionsCount()
    }
    
    func numberOfRowsInSection(section: Int) -> Int {
        return output.itemsCount(in: section)
    }
    
}
