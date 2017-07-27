//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

protocol HomeInteractorOutput: class {
    
    func didFetch(feed: HomePostsFeed)
    func didFetchMore(feed: HomePostsFeed)
    func didFail(error: PostDataFetchError)
    
}
