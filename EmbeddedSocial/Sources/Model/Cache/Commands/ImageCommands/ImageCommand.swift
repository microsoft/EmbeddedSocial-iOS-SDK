//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

class ImageCommand: OutgoingCommand {
    let photo: Photo
    private(set) var relatedHandle: String?
    
    required init?(json: [String: Any]) {
        guard let photoJSON = json["photo"] as? [String: Any],
            let photo = Photo(memento: photoJSON),
            let relatedHandle = json["relatedHandle"] as? String else {
                return nil
        }
        
        self.photo = photo
        self.relatedHandle = relatedHandle
        
        super.init(json: json)
    }
    
    required init(photo: Photo, relatedHandle: String?) {
        self.photo = photo
        self.relatedHandle = relatedHandle
        super.init(json: [:])!
    }
    
    override func encodeToJSON() -> Any {
        let json: [String: Any?] = [
            "photo": photo.encodeToJSON(),
            "type": typeIdentifier,
            "relatedHandle": relatedHandle
        ]
        return json.flatMap { $0 }
    }
    
    override func getRelatedHandle() -> String? {
        return relatedHandle
    }
    
    override func setRelatedHandle(_ relatedHandle: String?) {
        self.relatedHandle = relatedHandle
    }
    
    override func getHandle() -> String? {
        return photo.uid
    }
    
    static var allImageCommandTypes: [OutgoingCommand.Type] {
        return [
            CreateTopicImageCommand.self,
            CreateCommentImageCommand.self,
            UpdateUserImageCommand.self
        ]
    }
}
