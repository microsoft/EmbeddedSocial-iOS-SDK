//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

protocol ActivityModuleInput: class {
    
}

class ActivityPresenter: ActivityModuleInput, ActivityViewOutput, ActivityInteractorOutput {

    weak var view: ActivityViewInput!
    var interactor: ActivityInteractorInput!
    var router: ActivityRouterInput!

    func viewIsReady() {

    }
}
