//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest
import Nimble
import Quick
@testable import MSGP

class SideMenuInteractorTests: QuickSpec {
    
    var clientItemsProvider: SideMenuItemsProvider?
    var sut: SideMenuInteractorInput?
    
    override func spec() {
        
        beforeEach {
            
            let itemsProvider = DummyMenuProviderMock()
            let interactor = SideMenuInteractor()
            
            interactor.clientMenuItemsProvider = itemsProvider
            
            self.sut = interactor
            self.clientItemsProvider = itemsProvider
        }
        
        describe("when building list of items") {
            it("it should return a single and proper menu item") {
                
                let items = self.sut?.clientMenuItems()
                
                let itemIndex = 0
                
                let item = items![itemIndex]
                
                expect(items!.count).to(equal(self.clientItemsProvider?.numberOfItems()))
                expect(item.title).to(equal(self.clientItemsProvider?.title(forItem: itemIndex)))
                expect(item.image).to(equal(self.clientItemsProvider?.image(forItem: itemIndex)))
            }
            
            it("it should return empty list") {
                
                let items = self.sut?.socialMenuItems()
                
                expect(items?.count).to(equal(0))
                
            }
        }
    }
}

class DummyMenuProviderMock: SideMenuItemsProvider {
    
    let itemTitle = "dummy"
    let itemDestination = UIViewController()
    let itemsCount = 2
    let itemImage = UIImage()
    
    func numberOfItems() -> Int {
        return itemsCount
    }
    
    func image(forItem index: Int) -> UIImage {
        return itemImage
    }
    
    func title(forItem index: Int) -> String {
        return "\(itemTitle)\(index)"
    }
    
    func destination(forItem index: Int) -> UIViewController {
        return itemDestination
    }
}

