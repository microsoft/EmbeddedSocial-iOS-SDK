//
//  MockThirdPartyConfigurator.swift
//  MSGP
//
//  Created by Vadim Bulavin on 7/28/17.
//  Copyright © 2017 Akvelon. All rights reserved.
//

@testable import MSGP

final class MockThirdPartyConfigurator: ThirdPartyConfiguratorType {
    private(set) var setupCount = 0
    
    func setup(application: UIApplication, launchOptions: [AnyHashable : Any]) {
        setupCount += 1
    }
}
