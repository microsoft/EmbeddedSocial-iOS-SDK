//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

protocol DetailedActivityModuleInput: class {
    
}

class DetailedActivityPresenter: DetailedActivityModuleInput {

    weak var view: DetailedActivityViewInput?
    var interactor: DetailedActivityInteractorInput!
    var router: DetailedActivityRouterInput!
    
    var state: DetailedActivityState = .comment
    var contentIsLoaded = false
    var comment: Comment?
    var reply: Reply?
    
    func loadContent() {
        switch state {
        case .comment:
            break
        case .reply:
            break
        }
    }

}

extension DetailedActivityPresenter: DetailedActivityViewOutput {
    
    func contentReply() -> Reply {
        return reply!
    }
    
    func contentComment() -> Comment {
        return comment!
    }

    func viewIsReady() {
        
    }
    
    func numberOfItems() -> Int {
        if contentIsLoaded == false {
            return 0
        } else {
            return 2
        }
    }
    
    func contentState() -> DetailedActivityState {
        return state
    }
    
}

extension DetailedActivityPresenter: DetailedActivityInteractorOutput {
    func loaded(reply: Reply) {
        contentIsLoaded = true
        self.reply = reply
        view?.reloadAllContent()
    }
    
    func loaded(comment: Comment) {
        contentIsLoaded = true
        self.comment = comment
        view?.reloadAllContent()
    }
}
