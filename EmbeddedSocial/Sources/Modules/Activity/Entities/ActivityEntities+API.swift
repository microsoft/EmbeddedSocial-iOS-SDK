//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

extension ActionItem {
    
    init?(with model: ActivityView) {
        
        guard let rawTypeValue = model.activityType?.rawValue else { return nil }
        guard let type = ActivityType(rawValue: rawTypeValue) else { return nil }
        
        guard let actorUsers = model.actorUsers,
            let actedOnUserName = model.actedOnUser?.firstName,
            let postDate = model.createdTime
            else { return nil }
        
        self.type = type
        
        for user in actorUsers {
            if let firstName = user.firstName, let lastName = user.lastName {
                self.actorNameList.append((firstName, lastName))
            }
        }
        
        self.unread = model.unread ?? true
        self.actedOnName = actedOnUserName
        
        self.postDate = postDate
        self.profileImageURL = model.actorUsers?.first?.photoUrl
        self.contentImageURL = model.actedOnContent?.blobHandle
    }
}



extension ActivityFetchResult where T == ActivityItem   {
    
    init?(with response: FeedResponseActivityView) {
        
        if let dataItems = response.data {
            
            for source in dataItems {
                
                guard let item = ActionItem(with: source) else { return nil }
                self.items.append(ActivityItem.follower(item))
                
            }
            
        }
        
        cursor = response.cursor
    }
}

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
#endif
