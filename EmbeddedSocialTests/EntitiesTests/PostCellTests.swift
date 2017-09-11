//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest
import UIKit
@testable import EmbeddedSocial

class PostCellTests: XCTestCase {
    
    
    func testSka() {
        
        let aaaa = 1 + 1
        
    }
    
    func testThatItCalculatesProperHeight() {
        
        // given
        
        let cell = PostCell.sizingCell()
        
        
        let post = Post.mock(seed: 10)
        let model = PostViewModel(with: post, cellType: "some")
        cell.configure(with: model, collectionView: nil)
        
        
        let resultA = cell.getHeight(with: 200)
        
        
        
        let resultB = cell.getHeight(with: 200)
        
        XCTAssertTrue(resultA < resultB)
    }
    
    
}

