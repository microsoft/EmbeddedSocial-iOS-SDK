//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import UIKit

protocol SearchPeopleViewInput: class {
    func setupInitialState(listView: UIView)
    
    func setIsEmpty(_ isEmpty: Bool)
}
