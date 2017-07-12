//
//  CreateAccountModuleOutput.swift
//  MSGP-Framework
//
//  Created by Vadim Bulavin on 7/7/17.
//  Copyright © 2017 Microsoft Corporation. All rights reserved.
//

import Foundation

protocol CreateAccountModuleOutput: class {
    func onAccountCreated(result: Result<User>)
}
