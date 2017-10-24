//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest

class FollowRequestItem {
    
    private var application: XCUIApplication
    private var cell: XCUIElement
    
    private var profileImage: XCUIElement
    private var acceptButton: XCUIElement
    private var declineButton: XCUIElement
    
    init(_ application: XCUIApplication, cell: XCUIElement) {
        self.application = application
        self.cell = cell
        
        profileImage = self.cell.images.element
        acceptButton = self.cell.buttons["Accept"].firstMatch
        declineButton = self.cell.buttons["Reject"].firstMatch
    }
    
    func accept() {
        acceptButton.tap()
    }
    
    func decline() {
        declineButton.tap()
    }
    
    //UILabel values cannot be read when element has an accessibility identifier
    //and should be verified by searching of static texts inside cells
    //https://forums.developer.apple.com/thread/10428
    
    func isExists(text: String) -> Bool {
        return self.cell.staticTexts[text].exists
    }
    
    func asUIElement() -> XCUIElement {
        return cell
    }
    
}

class ActivityFollowRequests {
    
    private var application: XCUIApplication
    private var requestsTable: XCUIElement
    
    init(_ application: XCUIApplication) {
        self.application = application
        requestsTable = self.application.tables["ActivityFeed"].firstMatch
    }
    
    func getRequestsCount() -> UInt {
//        var count: UInt = 0
//        for _ in 0..<requestsTable.cells.count {
//            guard requestsTable.cells["FollowRequestCell"].exists else {
//                break
//            }
//            count += 1
//        }
        return requestsTable.cells.matching(identifier: "FollowRequestCell").count
    }
    
    func getRequestItem(at index: UInt, withScroll scroll: Bool = true) -> FollowRequestItem {
        let cell = requestsTable.cells.matching(identifier: "FollowRequestCell").element(boundBy: index)
        
        if scroll {
            scrollToElement(cell, application)
        }
        
        let requestItem = FollowRequestItem(application, cell: cell)
        return requestItem
    }
    
    func getRandomRequestItem() -> (index: UInt, requestItem: FollowRequestItem) {
        let randomIndex = Random.randomUInt(getRequestsCount())
        return (randomIndex, getRequestItem(at: randomIndex))
    }
    
    func asUIElement() -> XCUIElement {
        return requestsTable
    }
    
}
