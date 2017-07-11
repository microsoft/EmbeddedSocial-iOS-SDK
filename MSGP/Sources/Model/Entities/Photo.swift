//
//  Photo.swift
//  MSGP
//
//  Created by Vadim Bulavin on 7/11/17.
//  Copyright © 2017 Igor Popov. All rights reserved.
//

import Foundation

struct Photo {
    let url: String
}

extension Photo {
    init?(url: String?) {
        guard let url = url else {
            return nil
        }
        self.url = url
    }
}

extension Photo: Equatable {
    static func ==(_ lhs: Photo, rhs: Photo) -> Bool {
        return lhs.url == rhs.url
    }
}
