//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest
import Nimble
@testable import EmbeddedSocial

class SearchHistoryStorageTests: XCTestCase {
    
    var internalStorage: MockKeyValueStorage!
    var userID: String!
    var sut: SearchHistoryStorage!
    
    override func setUp() {
        super.setUp()
        internalStorage = MockKeyValueStorage()
        userID = UUID().uuidString
        sut = SearchHistoryStorage(storage: internalStorage, userID: userID)
    }
    
    override func tearDown() {
        super.tearDown()
        internalStorage = nil
        userID = nil
        sut = nil
    }
    
    func testThatItSavesAndUsesCorrectSavingKey() {
        let scope = "123"
        sut.scope = scope
        sut.save("1")
        expect(self.internalStorage.setForKeyCalled).to(beTrue())
        expect(self.internalStorage.setForKeyReceivedArguments?.value as? [String]).to(equal(["1"]))
        expect(self.internalStorage.setForKeyReceivedArguments?.defaultName).to(equal("SearchHistoryRepository-\(scope)-\(userID!)"))
    }
    
    func testThatItGetsSearchRequests() {
        _ = sut.searchRequests()
        expect(self.internalStorage.objectForKeyCalled).to(beTrue())
    }
}
