//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation
import XCTest

class PostDetails {
    
    var post: Post
    var comments: CommentsFeed!
    
    private var app: XCUIApplication!
    private var detailsContainer: XCUIElement!
    
    init(_ app: XCUIApplication) {
        self.app = app
        
        self.detailsContainer = self.app.collectionViews.firstMatch
        self.comments = CommentsFeed(app, containerView: detailsContainer)
        self.post = Post(self.detailsContainer.cells.element, self.app)
    }
}
