//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

protocol SearchViewInput: class {
    
    func setupInitialState(_ pageInfo: SearchTabInfo)
    
    func showError(_ error: Error)
}
