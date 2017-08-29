//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

final class SearchInteractor: SearchInteractorInput {
    
    func makePageInfo(from searchPeopleModule: SearchPeopleModuleInput) -> SearchPageInfo {
        return SearchPageInfo(searchResultsController: searchPeopleModule.searchResultsController(),
                              searchResultsHandler: searchPeopleModule.searchResultsHandler(),
                              backgroundView: searchPeopleModule.backgroundView())
    }
}
