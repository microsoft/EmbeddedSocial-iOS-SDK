//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

enum HomeRoutes: String {
    
    case postDetails
    case extra
    case comments
}

protocol HomeRouterInput {
    
    func open(route: HomeRoutes)

}
