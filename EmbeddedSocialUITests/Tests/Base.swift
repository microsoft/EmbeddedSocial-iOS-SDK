//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest

import Embassy
import EnvoyAmbassador

class UITestBase: XCTestCase {
    
    var eventLoopThreadCondition: NSCondition!
    var eventLoopThread: Thread!
    var loop: SelectorEventLoop!
    var router: APIRouter!
    var server: DefaultHTTPServer!
    var app: XCUIApplication!
    var startServerOnDemand = false
    var startAppOnDemand = false
    
    override func setUp() {
        super.setUp()
        
        setUpProperties()
        
        continueAfterFailure = false
        
        loop = try! SelectorEventLoop(selector: try! KqueueSelector())
        router = APIRouter()
        server = DefaultHTTPServer(eventLoop: loop, interface: "localhost", port: 8080, app: router.app)
        
        setUpRouter()
        
        if !startServerOnDemand {
            startServer()
        }
        
        app = XCUIApplication()
        app.launchEnvironment["EmbeddedSocial_MOCK_SERVER"] = "http://localhost:8080"
        
        if !startAppOnDemand {
            app.launch()
        }
        
        APIConfig.values = [:]
    }
    
    func setUpProperties() {
        
    }
    
    func startServer() {
        try! server.start()
        
        eventLoopThreadCondition = NSCondition()
        eventLoopThread = Thread(target: self, selector: #selector(runEventLoop), object: nil)
        eventLoopThread.start()
    }
    
    func stopServer() {
        server.stopAndWait()
        eventLoopThreadCondition.lock()
        loop.stop()
        while loop.running {
            if !eventLoopThreadCondition.wait(until: Date().addingTimeInterval(10)) {
                fatalError("Join eventLoopThread timeout")
            }
        }
    }
    
    func setUpRouter() {
        
    }
    
    func runEventLoop() {
        loop.runForever()
        eventLoopThreadCondition.lock()
        eventLoopThreadCondition.signal()
        eventLoopThreadCondition.unlock()
    }
    
    override func tearDown() {
        super.tearDown()
        app.terminate()
        stopServer()
    }
}

class BaseSideMenuTest: UITestBase {
    
    var sideMenu: SideMenu!
    
    override func setUp() {
        super.setUp()
        sideMenu = SideMenu(app)
    }
    
    func openScreen() {}
    
    func navigate(to menuItem: SideMenuItem) {
        sideMenu.navigate(to: menuItem)
    }
    
}

class BaseFeedTest: BaseSideMenuTest {
    
    var feed: Feed!
    var feedName: String!
    
    override func setUp() {
        super.setUp()
        feed = Feed(app)
    }
    
}

protocol OnlineTest {}

protocol OfflineTest {
    
    func makePullToRefreshWithoutReachability(with element: XCUIElement)
    
}

extension OfflineTest {
    
    func makePullToRefreshWithoutReachability(with element: XCUIElement) {
        let startTouchPosition = element.coordinate(withNormalizedOffset: CGVector(dx: 0, dy: 0))
        let finishTouchPosition = element.coordinate(withNormalizedOffset: CGVector(dx: 0, dy: 6))
        
        APIConfig.isReachable = false
        startTouchPosition.press(forDuration: 0, thenDragTo: finishTouchPosition)
    }
    
}
