//
//  Photo+Memento.swift
//  MSGP
//
//  Created by Vadim Bulavin on 7/20/17.
//  Copyright © 2017 Akvelon. All rights reserved.
//

import Foundation

extension Photo: MementoSerializable {
    init?(memento: Memento) {
        guard let uid = memento["uid"] as? String else {
            return nil
        }
        
        self.uid = uid
        url = memento["url"] as? String
        image = nil
        imagePlaceholder = nil
    }
    
    var memento: Memento {
        let memento: [String: Any?] = [
            "uid": uid,
            "url": url
        ]
        
        return memento.flatMap { $0 }
    }
}
