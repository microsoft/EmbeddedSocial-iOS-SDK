//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

protocol ActivityInteractorOutput: class {
    
}

protocol ActivityInteractorInput {
    
}

class ActivityInteractor {
    
    weak var output: ActivityInteractorOutput!

}

extension ActivityInteractor: ActivityInteractorInput {
    
}


