//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest

class TrendingTopicItem: UICellObject {
    
    func getName() -> String {
        return cell.staticTexts.firstMatch.label
    }
    
}

class TrendingTopicsFeed: UIFeedObject <TrendingTopicItem> {
    
    convenience init(_ application: XCUIApplication) {
        self.init(application, feedContainer: application.tables["TrendingTopics"].firstMatch)
    }
    
}
