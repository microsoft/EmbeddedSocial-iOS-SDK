//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

protocol SearchTopicsInteractorInput: class {
    func runSearchQuery(for searchBar: UISearchBar, feedModule: FeedModuleInput)
}
