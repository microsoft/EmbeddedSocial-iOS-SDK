//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

final class SearchInteractor: SearchInteractorInput {
    
    func makePeopleTab(with searchPeopleModule: SearchPeopleModuleInput) -> SearchTabInfo {
        return SearchTabInfo(searchResultsController: searchPeopleModule.searchResultsController(),
                             searchResultsHandler: searchPeopleModule.searchResultsHandler(),
                             backgroundView: searchPeopleModule.backgroundView(),
                             tab: .people)
    }
    
    func makeTopicsTab(with searchTopicsModule: SearchTopicsModuleInput) -> SearchTabInfo {
        return SearchTabInfo(searchResultsController: searchTopicsModule.searchResultsController(),
                             searchResultsHandler: searchTopicsModule.searchResultsHandler(),
                             backgroundView: searchTopicsModule.backgroundView(),
                             tab: .topics)
    }
}
