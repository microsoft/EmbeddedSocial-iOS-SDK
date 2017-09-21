//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

#if DEBUG
    extension FeedResponseActivityView {
        
        func mockResponse() -> FeedResponseActivityView {
            
            let bundle = Bundle(for: type(of: self))
            let path = bundle.path(forResource: "myActivity", ofType: "json")
            let data = try? Data(contentsOf: URL(fileURLWithPath: path!))
            let json = try? JSONSerialization.jsonObject(with: data!)
            
            
            let result = Decoders.decode(clazz: FeedResponseActivityView.self, source: json as AnyObject, instance: nil)
            switch result {
            case let .success(value):
                return value
            case let .failure(error):
                fatalError("Failed to decode with error \(error)")
            }
        }
    }
    
    extension FeedResponseUserCompactView {
        
        func mockResponse() -> FeedResponseUserCompactView {
            
            let bundle = Bundle(for: type(of: self))
            let path = bundle.path(forResource: "myPendingRequests", ofType: "json")
            let data = try? Data(contentsOf: URL(fileURLWithPath: path!))
            let json = try? JSONSerialization.jsonObject(with: data!)
            
            
            let result = Decoders.decode(clazz: FeedResponseUserCompactView.self, source: json as AnyObject, instance: nil)
            switch result {
            case let .success(value):
                return value
            case let .failure(error):
                fatalError("Failed to decode with error \(error)")
            }
        }
    }
    
    
    
#endif
