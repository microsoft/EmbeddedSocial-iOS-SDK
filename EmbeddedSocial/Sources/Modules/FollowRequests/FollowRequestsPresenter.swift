//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

final class FollowRequestsPresenter {
    weak var view: FollowRequestsViewInput!
    var interactor: FollowRequestsInteractorInput!
    var router: FollowRequestsRouterInput!
}

extension FollowRequestsPresenter: FollowRequestsViewOutput {
    
}
