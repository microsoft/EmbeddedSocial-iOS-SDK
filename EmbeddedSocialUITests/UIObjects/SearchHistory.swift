//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest

class SearchHistoryItem: UICellObject {
    
    func getQuery() -> String {
        return cell.staticTexts.firstMatch.label
    }
    
}

class SearchHistory: UIFeedObject <SearchHistoryItem> {

    convenience init(_ application: XCUIApplication) {
        self.init(application, feedContainer: application.tables["Search History"].firstMatch)
    }
    
}
