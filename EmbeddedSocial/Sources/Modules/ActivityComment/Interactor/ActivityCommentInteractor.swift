//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

protocol ActivityCommentInteractorOutput: class {
    
}

protocol ActivityCommentInteractorInput {
    
}

class ActivityCommentInteractor: ActivityCommentInteractorInput {

    weak var output: ActivityCommentInteractorOutput!

}
