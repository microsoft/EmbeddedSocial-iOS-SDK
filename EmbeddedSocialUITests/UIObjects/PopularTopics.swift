//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest

enum PopularTopicSection: String {
    case today    = "Today"
    case thisWeek = "This week"
    case all      = "All time"
}

class PopularTopics: UIObject {
    
    func select(section: PopularTopicSection) {
        application.buttons[section.rawValue].tap()
    }
    
}
