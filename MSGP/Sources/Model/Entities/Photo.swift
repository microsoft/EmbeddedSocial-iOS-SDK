//
//  Photo.swift
//  MSGP
//
//  Created by Vadim Bulavin on 7/11/17.
//  Copyright © 2017 Akvelon. All rights reserved.
//

import Foundation

struct Photo {
    let uid: String
    let url: String?
    private(set) var image: UIImage?
    
    init(uid: String = UUID().uuidString, url: String? = nil, image: UIImage? = nil) {
        self.uid = uid
        self.url = url
        self.image = image
    }
}

extension Photo: Equatable {
    static func ==(_ lhs: Photo, rhs: Photo) -> Bool {
        return lhs.uid == lhs.uid && lhs.url == rhs.url
    }
}
