//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest
import Nimble
@testable import EmbeddedSocial

class SearchHistoryMediatorTests: XCTestCase {
    
    private class SearchBarDelegate: NSObject, UISearchBarDelegate { }
    
    var searchBar: UISearchBar!
    var storage: MockKeyValueStorage!
    var historyView: SearchHistoryView!
    var sut: SearchHistoryMediator!
    var window: UIWindow!

    override func setUp() {
        super.setUp()
        searchBar = UISearchBar()
        historyView = SearchHistoryView()
        storage = MockKeyValueStorage()
        sut = SearchHistoryMediator(searchBar: searchBar,
                                    searchBarDelegate: SearchBarDelegate(),
                                    storage: SearchHistoryStorage(storage: storage, userID: UUID().uuidString),
                                    searchHistoryView: historyView)
        
        let vc = UIViewController()
        vc.view.addSubview(searchBar)
        
        window = UIWindow()
        window.rootViewController = vc
    }
    
    override func tearDown() {
        super.tearDown()
        searchBar = nil
        storage = nil
        historyView = nil
        sut = nil
        window = nil
    }
    
    func testInit() {
        expect(self.historyView.isHidden).to(beTrue())
        expect(self.searchBar.delegate).to(beAKindOf(SearchBarMulticastDelegate.self))
    }
    
    func testThatItHandlesSearchText() {
        storage.objectForKeyReturnValue = ["1"]

        sut.handleSearchedText("1")
        
        validateThatItHandlesSearchResult("1")
    }
    
    private func validateThatItHandlesSearchResult(_ searchText: String) {
        expect(self.storage.setForKeyReceivedArguments?.value as? [String]).to(equal([searchText]))
        expect(self.historyView.isHidden).to(beTrue())
        expect(self.historyView.searchRequests).to(equal([searchText]))
    }
    
    func testTabChangeWhenSearchTextIsEmptyAndSearchBarIsInactive() {
        storage.objectForKeyReturnValue = ["1"]

        sut.activeTab = .people
        
        expect(self.historyView.searchRequests).to(equal(["1"]))
        expect(self.historyView.isHidden).to(beTrue())
    }
    
    func testTabChangeWhenSearchTextIsEmptyAndSearchBarIsActive() {
        storage.objectForKeyReturnValue = ["1"]
        searchBar.becomeFirstResponder()
        
        sut.activeTab = .people
        
        expect(self.historyView.searchRequests).to(equal(["1"]))
        expect(self.historyView.isHidden).to(beFalse())
    }
    
    func testTabChangeWhenSearchTextIsNotEmpty() {
        searchBar.text = UUID().uuidString
        storage.objectForKeyReturnValue = ["1"]
        
        sut.activeTab = .people
        
        expect(self.historyView.searchRequests).to(equal(["1"]))
        expect(self.historyView.isHidden).to(beTrue())
    }
    
    func testInitWithEmptyText() {
        setupAndValidateHistoryViewInitialState()
        expect(self.historyView.isHidden).to(beTrue())
    }
    
    func testInitWithEmptyTextAndActiveSearchBar() {
        searchBar.becomeFirstResponder()
        setupAndValidateHistoryViewInitialState()
        expect(self.historyView.isHidden).to(beFalse())
    }
    
    func testThatItConfiguresHistoryViewWhenSearchBarEditingBeginsAndSearchTextIsNotEmpty() {
        searchBar.text = UUID().uuidString
        setupAndValidateHistoryViewInitialState()
        expect(self.historyView.isHidden).to(beTrue())
    }
    
    private func setupAndValidateHistoryViewInitialState() {
        
        storage.objectForKeyReturnValue = ["1"]
        
        let superview = UIView(frame: CGRect(x: 100, y: 100, width: 100, height: 100))
        superview.addSubview(historyView)
        
        searchBar.frame = CGRect(x: 0, y: 0, width: 320, height: 44)
        
        sut.searchBarTextDidBeginEditing(searchBar)
        
        expect(self.historyView.frame.width).to(equal(searchBar.frame.width))
        expect(self.historyView.frame.origin.y).to(equal(searchBar.frame.maxY))
        expect(self.historyView.frame.origin.x).to(equal((superview.frame.width - searchBar.frame.width) / 2.0))
        expect(self.historyView.searchRequests).to(equal(["1"]))
        expect(self.historyView.maxHeight).to(equal(Constants.Search.historyMaxHeight))
    }
    
    func testCancelAction() {
        sut.searchBarCancelButtonClicked(searchBar)
        expect(self.historyView.isHidden).to(beTrue())
    }
    
    func testSearchAction() {
        let searchText = UUID().uuidString
        storage.objectForKeyReturnValue = [searchText]
        searchBar.text = searchText
        sut.searchBarSearchButtonClicked(searchBar)
        validateThatItHandlesSearchResult(searchText)
    }
    
    func testSearchTextChangeWithSomeText() {
        searchBar.text = "1"
        sut.searchBar(searchBar, textDidChange: "1")
        expect(self.historyView.isHidden).to(beTrue())
    }
    
    func testSearchTextChangeWithoutText() {
        searchBar.text = ""
        searchBar.becomeFirstResponder()
        sut.searchBar(searchBar, textDidChange: "")
        expect(self.historyView.isHidden).to(beFalse())
    }
    
    func testEndEditing() {
        sut.searchBarTextDidEndEditing(searchBar)
        expect(self.historyView.isHidden).to(beTrue())
    }
}
