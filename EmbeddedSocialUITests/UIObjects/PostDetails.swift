//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest

class PostDetails: UIObject, UIElementConvertible {
    
    var post: PostItem
    var comments: CommentsFeed!
    
    private var detailsContainer: XCUIElement!
    
    override init(_ application: XCUIApplication) {
        detailsContainer = application.collectionViews.firstMatch
        comments = CommentsFeed(application, feedContainer: detailsContainer)
        post = PostItem(application, cell: detailsContainer.cells.element)
        super.init(application)
    }

    func asUIElement() -> XCUIElement {
        return detailsContainer
    }
    
}
