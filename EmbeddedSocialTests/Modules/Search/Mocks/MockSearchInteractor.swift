//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

@testable import EmbeddedSocial

final class MockSearchInteractor: SearchInteractorInput {
    private(set) var makePageInfoCount = 0
    var pageInfoToReturn: SearchPageInfo?
    
    func makePageInfo(from searchPeopleModule: SearchPeopleModuleInput) -> SearchPageInfo {
        makePageInfoCount += 1
        guard let pageInfo = pageInfoToReturn else {
            fatalError("Please provide page info to return")
        }
        return pageInfo
    }
}
