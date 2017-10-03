//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

protocol FollowRequestsViewOutput: class {
    func viewIsReady()
    
    func onAccept(_ item: FollowRequestItem)
    
    func onReject(_ item: FollowRequestItem)
    
    func onReachingEndOfPage()
    
    func onItemSelected(_ item: FollowRequestItem)
    
    func onPullToRefresh()
}
