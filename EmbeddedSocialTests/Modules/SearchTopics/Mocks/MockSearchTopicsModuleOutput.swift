//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

@testable import EmbeddedSocial

class MockSearchTopicsModuleOutput: SearchTopicsModuleOutput {
    
    //MARK: - didFailToLoadSearchQuery
    
    var didFailToLoadSearchQueryCalled = false
    var didFailToLoadSearchQueryReceivedError: Error?
    
    func didFailToLoadSearchQuery(_ error: Error) {
        didFailToLoadSearchQueryCalled = true
        didFailToLoadSearchQueryReceivedError = error
    }
    
    //MARK: - didSelectHashtag
    
    var didSelectHashtagCalled = false
    var didSelectHashtagReceivedHashtag: Hashtag?
    
    func didSelectHashtag(_ hashtag: Hashtag) {
        didSelectHashtagCalled = true
        didSelectHashtagReceivedHashtag = hashtag
    }
    
    //MARK: - didStartLoadingSearchTopicsQuery
    
    var didStartLoadingSearchTopicsQueryCalled = false
    
    func didStartLoadingSearchTopicsQuery() {
        didStartLoadingSearchTopicsQueryCalled = true
    }
    
    //MARK: - didLoadSearchTopicsQuery
    
    var didLoadSearchTopicsQueryCalled = false
    
    func didLoadSearchTopicsQuery() {
        didLoadSearchTopicsQueryCalled = true
    }
}
