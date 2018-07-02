//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest
import UIKit
@testable import EmbeddedSocial

class ImageCacheAdapterTests: XCTestCase {
    private let timeout: TimeInterval = 5
    
    private let sut = ImageCacheAdapter.shared
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testThatImageIsNotModifiedAfterLoadingFromCache() {
        // given
        let image = UIImage(color: .yellow, size: CGSize(width: 8.0, height: 8.0))
        let photo = Photo()
        
        // when
        sut.store(image: image, for: photo)
        
        // then
        let loadedImage = sut.image(for: photo)
        XCTAssertNotNil(loadedImage)
        
        let originalImageData = UIImagePNGRepresentation(image)
        let loadedImageData = UIImagePNGRepresentation(loadedImage!)
        
        XCTAssertEqual(originalImageData, loadedImageData)
    }
    
    func testThatPhotoIsCachedByURL() {
        // given
        let photo1 = Photo(url: "http://google.com")
        let photo2 = Photo(url: "http://google.com")
        let photo3 = Photo()
        
        // when
        
        // then
        XCTAssertEqual(sut.key(for: photo1), sut.key(for: photo2))
        XCTAssertNotEqual(sut.key(for: photo1), sut.key(for: photo3))
        XCTAssertNotEqual(sut.key(for: photo2), sut.key(for: photo3))
    }
    
    func testThatPhotoIsCachedByUIDWhenWithoutURL() {
        // given
        let photo1 = Photo()
        let photo2 = Photo()
        
        // when
        
        // then
        XCTAssertNotEqual(sut.key(for: photo1), sut.key(for: photo2))
    }
    
    func testThatPhotoIsCachedByURLWithEqualUID() {
        // given
        let uid = UUID().uuidString
        let photo1 = Photo(uid: uid, url: "http://google.com")
        let photo2 = Photo(uid: uid, url: "http://google.com")
        
        // when
        
        // then
        XCTAssertEqual(sut.key(for: photo1), sut.key(for: photo2))
    }
    
    func testThatImageIsSavedByCacheKey() {
        // given
        let photos = [
            Photo(url: "http://google.com", image: UIImage(color: .green, size: CGSize(width: 8.0, height: 8.0))),
            Photo(url: "http://google.com", image: UIImage(color: .yellow, size: CGSize(width: 4.0, height: 4.0))),
            Photo(image: UIImage(color: .red, size: CGSize(width: 12.0, height: 12.0)))
        ]

        // when
        for photo in photos {
            guard let image = photo.image else { continue }
            sut.store(image: image, for: photo)
        }
        
        // then
        for lhs in photos {
            for rhs in photos {
                if sut.key(for: lhs) == sut.key(for: rhs) {
                    let image1 = sut.image(for: lhs)!
                    let image2 = sut.image(for: rhs)!
                    XCTAssertEqual(UIImagePNGRepresentation(image1), UIImagePNGRepresentation(image2))
                }
            }
        }
    }
}
