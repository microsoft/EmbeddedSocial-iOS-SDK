//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

@testable import EmbeddedSocial

extension FeedResponseTopicView {
    
    static func loadFrom(bundle: Bundle, withName name: String) -> FeedResponseTopicView? {
        
        let type = "json"

        // Load server response from json file
        let path = bundle.path(forResource: name, ofType: type)
        let data = try? Data(contentsOf: URL(fileURLWithPath: path!))
        let json = try? JSONSerialization.jsonObject(with: data!)
        
        return loadFeedResponseFrom(source: json as Any)
    }

    static private func loadFeedResponseFrom(source: Any) -> FeedResponseTopicView? {
        let result = Decoders.decode(clazz: FeedResponseTopicView.self, source: source as AnyObject, instance: nil)
        switch result {
        case let .success(value):
            return value
        case .failure(_ ):
            fatalError("Failed parsing test json")
        }
    }
    

}
