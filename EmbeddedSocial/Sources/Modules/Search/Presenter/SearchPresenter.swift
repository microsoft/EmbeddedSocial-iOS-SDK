//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

final class SearchPresenter {
    weak var view: SearchViewInput!
    var peopleSearchModule: SearchPeopleModuleInput!
    var interactor: SearchInteractorInput!
}

extension SearchPresenter: SearchViewOutput {
    
    func viewIsReady() {
        peopleSearchModule.setupInitialState()
        
        let pageInfo = interactor.makePageInfo(from: peopleSearchModule)
        view.setupInitialState(pageInfo)
    }
}
