//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation
@testable import EmbeddedSocial

class FeedModuleRouterInputMock: FeedModuleRouterInput {
    
    //MARK: - open
    
    var open_route_feedSource_Called = false
    var open_route_feedSource_ReceivedArguments: (route: FeedModuleRoutes, feedSource: FeedType)?
    
    func open(route: FeedModuleRoutes, feedSource:FeedType) {
        open_route_feedSource_Called = true
        open_route_feedSource_ReceivedArguments = (route: route, feedSource: feedSource)
    }
    
    //MARK: - open
    
    var open_route_presenter_Called = false
    var open_route_presenter_ReceivedArguments: (route: FeedModuleRoutes, presenter: FeedModulePresenter)?
    
    func open(route: FeedModuleRoutes, presenter: FeedModulePresenter) {
        open_route_presenter_Called = true
        open_route_presenter_ReceivedArguments = (route: route, presenter: presenter)
    }
    
}

