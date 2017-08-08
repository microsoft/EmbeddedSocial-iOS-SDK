//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

protocol SideMenuModuleInput: class {
    
    var user: User? { get set }
    func close()
    
}
