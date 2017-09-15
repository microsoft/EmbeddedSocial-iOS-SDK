//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

final class FollowingRouter: FollowingRouterInput {
    
    weak var searchPeopleOpener: SearchPeopleOpener?
    
    init(searchPeopleOpener: SearchPeopleOpener?) {
        self.searchPeopleOpener = searchPeopleOpener
    }
    
    func openSuggestedUsers() {
        
    }
    
    func openSearchPeople() {
        searchPeopleOpener?.openSearchPeople()
    }
}
