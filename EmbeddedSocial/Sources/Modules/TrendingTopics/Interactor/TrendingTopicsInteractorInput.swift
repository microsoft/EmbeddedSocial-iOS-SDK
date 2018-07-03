//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

protocol TrendingTopicsInteractorInput: class {
    func getTrendingHashtags(completion: @escaping (Result<[Hashtag]>) -> Void)
    
    func reloadTrendingHashtags(completion: @escaping (Result<[Hashtag]>) -> Void)
}
