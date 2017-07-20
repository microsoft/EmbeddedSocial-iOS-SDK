//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest
import UIKit
@testable import MSGP

class ImageCacheAdapterTests: XCTestCase {
    private let sut = ImageCacheAdapter.shared
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testThatImageIsCachedByID() {
        // given
        let image = UIImage(color: .yellow, size: CGSize(width: 8.0, height: 8.0))
        let photo = Photo()
        
        // when
        sut.store(image: image, for: photo)
        let loadedImage = sut.image(for: photo)

        // then
        XCTAssertNotNil(loadedImage)
        
        let originalImageData = UIImagePNGRepresentation(image)
        let loadedImageData = UIImagePNGRepresentation(loadedImage!)
        
        XCTAssertEqual(originalImageData, loadedImageData)
    }
}
