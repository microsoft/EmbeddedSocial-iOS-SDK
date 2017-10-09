//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation
import XCTest

class PostDetails {
    var app: XCUIApplication!
    var detailsContainer: XCUIElement!
    var commentsContainer: XCUIElement!
    var post: Post
    
    init(_ app: XCUIApplication) {
        self.app = app
        self.detailsContainer = self.app.collectionViews.element(boundBy: 0)
        self.commentsContainer = self.app.collectionViews.element(boundBy: 1)
        self.post = Post(self.detailsContainer.cells.element(boundBy: 0), self.app)
    }
}
