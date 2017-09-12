//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

protocol ActivityInteractorOutput: class {
    
}

protocol ActivityInteractorInput {
    
}

class ActivityInteractor: ActivityInteractorInput {

    weak var output: ActivityInteractorOutput!

}
