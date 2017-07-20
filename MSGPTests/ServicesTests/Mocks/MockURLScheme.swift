//
//  MockURLScheme.swift
//  MSGP
//
//  Created by Vadim Bulavin on 7/20/17.
//  Copyright © 2017 Akvelon. All rights reserved.
//

import Foundation
@testable import MSGP

struct MockURLScheme: URLScheme {
    private let result: Bool
    
    init(result: Bool) {
        self.result = result
    }
    
    func application(_ application: UIApplication, open url: URL, options: [AnyHashable: Any]) -> Bool {
        return result
    }
}
