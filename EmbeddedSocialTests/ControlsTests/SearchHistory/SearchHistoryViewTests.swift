//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest
import Nimble
@testable import EmbeddedSocial

class SearchHistoryViewTests: XCTestCase {
    
    func testResizeWithSingleCell() {
        let view = SearchHistoryView()
        view.searchRequests = ["1"]
        expect(view.bounds.height).to(beCloseTo(Constants.standardCellHeight, within: 0.001))
    }
    
    func testResizeWithZeroCells() {
        let view = SearchHistoryView()
        view.searchRequests = []
        expect(view.bounds.height).to(beCloseTo(0, within: 0.001))
    }
    
    func testResizeUnderMaxHeight() {
        let view = SearchHistoryView()
        view.maxHeight = 1000.0
        view.searchRequests = ["1", "2", "3", "4", "5"]
        expect(view.bounds.height).to(beCloseTo(5 * Constants.standardCellHeight, within: 0.001))
    }
    
    func testResizeAtMaxHeightBoundary() {
        let view = SearchHistoryView()
        let maxHeight = 5 * Constants.standardCellHeight
        view.maxHeight = maxHeight
        view.searchRequests = ["1", "2", "3", "4", "5"]
        expect(view.bounds.height).to(beCloseTo(maxHeight, within: 0.001))
    }
    
    func testResizeAtMaxHeightOverBoundary() {
        let view = SearchHistoryView()
        let maxHeight = 2 * Constants.standardCellHeight
        view.maxHeight = maxHeight
        view.searchRequests = ["1", "2", "3", "4", "5"]
        expect(view.bounds.height).to(beCloseTo(maxHeight, within: 0.001))
    }
    
    func testDefaultMaxHeight() {
        let view = SearchHistoryView()
        expect(view.maxHeight).to(beCloseTo(CGFloat.greatestFiniteMagnitude, within: 0.001))
    }
    
    func testResizeAfterMultipleContentChange() {
        let maxHeight = 4 * Constants.standardCellHeight
        let view = SearchHistoryView()
        view.maxHeight = maxHeight
        
        view.searchRequests = ["1", "2", "3", "4", "5"]
        expect(view.bounds.height).to(beCloseTo(maxHeight, within: 0.001))
        
        view.searchRequests = ["1", "2"]
        expect(view.bounds.height).to(beCloseTo(2 * Constants.standardCellHeight, within: 0.001))
    }
}
