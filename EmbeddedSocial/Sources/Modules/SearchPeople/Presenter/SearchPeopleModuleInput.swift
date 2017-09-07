//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

protocol SearchPeopleModuleInput: class {
    func setupInitialState()
    
    func searchResultsHandler() -> SearchResultsUpdating
    
    func backgroundView() -> UIView?
    
    func searchResultsController() -> UIViewController
}
