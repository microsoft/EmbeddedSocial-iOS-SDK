//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

protocol SearchTopicsModuleOutput: class {    
    func didFailToLoadSearchQuery(_ error: Error)
    
    func didSelectHashtag(_ hashtag: Hashtag)
    
    func didStartLoadingSearchTopicsQuery()
    
    func didLoadSearchTopicsQuery()
}
