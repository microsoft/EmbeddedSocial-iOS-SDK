//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import UIKit

protocol SearchPeopleInteractorInput: class {    
    func makeBackgroundListHeaderView() -> UIView
    
    func runSearchQuery(for searchController: UISearchController, usersListModule: UserListModuleInput)
}
