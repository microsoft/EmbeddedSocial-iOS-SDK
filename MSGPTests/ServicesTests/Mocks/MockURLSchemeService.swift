//
//  MockURLSchemeService.swift
//  MSGP
//
//  Created by Vadim Bulavin on 7/20/17.
//  Copyright © 2017 Akvelon. All rights reserved.
//

import Foundation
@testable import MSGP

final class MockURLSchemeService: URLSchemeServiceType {
    private(set) var openURLIsCalled = false
    private let openURLResult: Bool
    
    init(openURLResult: Bool) {
        self.openURLResult = openURLResult
    }
    
    func application(_ app: UIApplication, open url: URL, options: [AnyHashable: Any]) -> Bool {
        openURLIsCalled = true
        return openURLResult
    }
}
