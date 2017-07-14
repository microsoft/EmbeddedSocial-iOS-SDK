//
//  RootConfigurator.swift
//  MSGP-Framework
//
//  Created by Vadim Bulavin on 7/6/17.
//  Copyright © 2017 Microsoft Corporation. All rights reserved.
//

import UIKit

final class RootConfigurator {
    
    let router: RootRouter
    
    init(window: UIWindow) {
        router = RootRouter(window: window)
    }
}
