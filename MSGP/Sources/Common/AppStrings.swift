//
//  AppStrings.swift
//  MSGP
//
//  Created by Mac User on 12.07.17.
//  Copyright © 2017 Igor Popov. All rights reserved.
//

import Foundation

struct Button {
    struct Title {
        static let ok = NSLocalizedString("Ok", comment: "")
        static let cancel = NSLocalizedString("Cancel", comment: "")
        static let leavePost = NSLocalizedString("Leave post", comment: "")
        static let chooseExisting = NSLocalizedString("Chose existing", comment: "")
        static let takePhoto = NSLocalizedString("Take photo", comment: "")
        static let post = NSLocalizedString("Post", comment: "")
    }
}

struct Alerts {
    struct Messages {
        static let leaveNewPost = NSLocalizedString("Going back to the feed will delete the content of this draft, are you sure you want to go back?", comment: "")
    }
    
    struct Titles {
        static let returnToFeed = NSLocalizedString("Return to feed?", comment: "")
        static let choose = NSLocalizedString("Choose please", comment: "")
    }
}

struct Titles {
    static let addPost = NSLocalizedString("Add new post", comment: "")
}
