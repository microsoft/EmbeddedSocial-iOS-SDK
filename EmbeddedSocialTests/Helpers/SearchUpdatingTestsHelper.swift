//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest
@testable import EmbeddedSocial

final class SearchUpdatingTestsHelper {
    let sut: SearchResultsUpdating
    let executeQueryExpectation: XCTestExpectation
    let testCase: XCTestCase
    
    var searchQueryHasRunValidator: ((String, UISearchBar) -> Void)?
    
    init(sut: SearchResultsUpdating,
         executeQueryExpectation: XCTestExpectation,
         testCase: XCTestCase) {
        self.sut = sut
        self.executeQueryExpectation = executeQueryExpectation
        self.testCase = testCase
    }
    
    func validateThatItUpdatesSearchResults() {
        // given
        let runQueryTimeout: TimeInterval = 1
        let query = UUID().uuidString
        let searchBar = UISearchBar()
        searchBar.text = query
        
        // when
        sut.updateSearchResults(for: searchBar)
        testCase.wait(for: [executeQueryExpectation], timeout: runQueryTimeout)
        
        // then
        searchQueryHasRunValidator?(query, searchBar)
    }
    
    func validateThatItThrottlesSearchUpdates() {
        // given
        let runQueryTimeout: TimeInterval = 1
        let searchBar = UISearchBar()
        let updatesCount = 5
        
        var queries: [String] = []
        for _ in 0..<updatesCount {
            queries.append(UUID().uuidString)
        }
        
        // when
        for i in 0..<updatesCount {
            searchBar.text = queries[i]
            sut.updateSearchResults(for: searchBar)
        }
        testCase.wait(for: [executeQueryExpectation], timeout: runQueryTimeout)
        
        // then
        // only the last query has been run
        searchQueryHasRunValidator?(queries.last!, searchBar)
    }
}
