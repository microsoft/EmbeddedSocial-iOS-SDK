//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

protocol TrendingTopicsViewInput: class {
    func setupInitialState()
    
    func setHashtags(_ hashtags: [Hashtag])
    
    func showError(_ error: Error)
    
    func setIsLoading(_ isLoading: Bool)
}
