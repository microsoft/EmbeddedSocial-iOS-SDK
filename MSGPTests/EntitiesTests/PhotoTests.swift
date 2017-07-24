//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest
@testable import MSGP

class PhotoTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
        UserDefaults.standard.set(nil, forKey: className)
    }
    
    func testMementoInitialization() {
        // given
        let photo = Photo(url: "http://google.com")
        
        // when
        let loadedPhoto = Photo(memento: photo.memento)
        
        // then
        XCTAssertNotNil(loadedPhoto)
        XCTAssertEqual(photo, loadedPhoto!)
    }
    
    func testInitialization() {
        // given
        let uid = UUID().uuidString
        let url = "http://google.com"
        let image = UIImage(color: .yellow, size: CGSize(width: 8.0, height: 8.0))
        
        // when
        let photo = Photo(uid: uid, url: url, image: image)
        
        // then
        let originalImageData = UIImagePNGRepresentation(image)
        let imageData = UIImagePNGRepresentation(photo.image!)
        XCTAssertEqual(originalImageData, imageData)
        XCTAssertEqual(photo.uid, uid)
        XCTAssertEqual(photo.url, url)
    }
    
    func testThatPhotosAreEqual() {
        // given
        let uid = UUID().uuidString
        let url = "http://google.com"
        let image = UIImage(color: .yellow, size: CGSize(width: 8.0, height: 8.0))
        
        let photo1 = Photo(uid: uid, url: url, image: image)
        let photo2 = Photo(uid: uid, url: url, image: image)
        
        // when
        let areEqual = photo1 == photo2
        
        // then
        XCTAssertTrue(areEqual)
        assertDumpsEqual(photo1, photo2)
    }
    
    func testThatPhotosAreNotEqual() {
        // given
        let uid = UUID().uuidString
        let url = "http://google.com"
        let image = UIImage(color: .yellow, size: CGSize(width: 8.0, height: 8.0))
        
        let originalPhoto = Photo(uid: uid, url: url, image: image)
        
        let modifiedPhotos = [
            Photo(uid: uid, url: url + "1", image: image),
            Photo(uid: uid, url: url, image: UIImage(color: .green, size: CGSize(width: 8.0, height: 8.0))),
            Photo(uid: UUID().uuidString, url: url, image: image)
        ]

        // when

        // then
        for modifiedPhoto in modifiedPhotos {
            let areEqual = originalPhoto == modifiedPhoto
            XCTAssertFalse(areEqual)
            assertDumpsNotEqual(originalPhoto, modifiedPhoto)
        }
    }
    
    func testMementoSerialization() {
        // given
        let uid = UUID().uuidString
        let url = "http://google.com"
        let photo = Photo(uid: uid, url: url)
        
        let expectedMemento: Memento = [
            "uid": uid,
            "url": url
        ]
        
        // when
        UserDefaults.standard.set(photo.memento, forKey: className)
        guard let loadedMemento = UserDefaults.standard.object(forKey: className) as? Memento else {
            XCTFail("Memento not loaded")
            return
        }
        let loadedPhoto = Photo(memento: loadedMemento)
        
        // then
        XCTAssertTrue((loadedMemento as NSDictionary).isEqual(to: expectedMemento))
        XCTAssertEqual(loadedPhoto, photo)
    }
}
