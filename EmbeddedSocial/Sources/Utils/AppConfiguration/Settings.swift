//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

struct Settings {
    let serverURL: String
    let appKey: String
    let numberOfCommentsToShow: Int
    let numberOfRepliesToShow: Int
    let showGalleryView: Bool
    let userRelationsEnabled: Bool
    
    init?(config: [String: Any]) {
        guard let serverURL = config["serverURL"] as? String,
            let appKey = config["appKey"] as? String,
            let numberOfCommentsToShow = config["numberOfCommentsToShow"] as? NSNumber,
            let numberOfRepliesToShow = config["numberOfRepliesToShow"] as? NSNumber,
            let showGalleryView = config["showGalleryView"] as? Bool,
            let userRelationsEnabled = config["userRelationsEnabled"] as? Bool else {
                return nil
        }
        
        self.serverURL = serverURL
        self.appKey = appKey
        self.numberOfCommentsToShow = numberOfCommentsToShow.intValue
        self.numberOfRepliesToShow = numberOfRepliesToShow.intValue
        self.showGalleryView = showGalleryView
        self.userRelationsEnabled = userRelationsEnabled
    }
}
