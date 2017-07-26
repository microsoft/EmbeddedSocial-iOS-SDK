//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

enum HomeAction {
    
    typealias PostReference = String

    case liked(post: PostReference)
    case open(post: PostReference)
    
}

protocol HomeRouterInput {
    
    func open(with action:HomeAction)

}
