//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

class TrendingTopicsViewController: UIViewController {
    
    @IBOutlet fileprivate weak var tableView: UITableView!
    
}

extension TrendingTopicsViewController: TrendingTopicsViewInput {
    
    func setHashtags(_ hashtags: [Hashtag]) {
        
    }
}
