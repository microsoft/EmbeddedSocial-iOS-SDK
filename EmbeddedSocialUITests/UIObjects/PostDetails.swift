//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation
import XCTest

class PostDetails {
    
    private var app: XCUIApplication!
    private var detailsContainer: XCUIElement!
//    private var commentsContainer: XCUIElement!
    
    var post: Post
    
    init(_ app: XCUIApplication) {
        self.app = app
        
        self.detailsContainer = self.app.collectionViews.firstMatch
//        self.commentsContainer = self.app.collectionViews.element(boundBy: 1)
        self.post = Post(self.detailsContainer.cells.element(boundBy: 0), self.app)
    }
}
