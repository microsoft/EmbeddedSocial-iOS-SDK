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
    
    init(uid: String = UUID().uuidString, url: String? = nil) {
        self.uid = uid
        self.url = url
    }
}

extension Photo: Equatable {
    static func ==(_ lhs: Photo, rhs: Photo) -> Bool {
        return lhs.uid == lhs.uid && lhs.url == rhs.url
    }
}
