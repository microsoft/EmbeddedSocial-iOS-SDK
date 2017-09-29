//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

protocol ActivityCommentModuleInput: class {
    
}

class ActivityCommentPresenter: ActivityCommentModuleInput, ActivityCommentViewOutput, ActivityCommentInteractorOutput {

    weak var view: ActivityCommentViewInput!
    var interactor: ActivityCommentInteractorInput!
    var router: ActivityCommentRouterInput!

    func viewIsReady() {

    }
}
