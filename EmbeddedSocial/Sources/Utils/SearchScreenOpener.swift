//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

protocol SearchScreenOpener: class {
    func openSearch(with hashtag: String)
}

class MockSearchOpener: SearchScreenOpener {
    
    static let shared = MockSearchOpener()
    
    func openSearch(with hashtag: String) {
        Logger.log("opening", hashtag, event: .veryImportant)
    }
}
