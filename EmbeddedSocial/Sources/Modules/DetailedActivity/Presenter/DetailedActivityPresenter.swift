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

}

fileprivate enum DetailedActivityItems: Int {
    case empty = 0
    case loaded = 2
}

extension DetailedActivityPresenter: DetailedActivityViewOutput {
    func openNextContent() {
        switch state {
        case .reply:
            router.openComment(handle: reply!.commentHandle)
        case .comment:
            router.openTopic(handle: comment!.topicHandle)
        }
    }
    
    func contentReply() -> Reply {
        return reply!
    }
    
    func contentComment() -> Comment {
        return comment!
    }

    func viewIsReady() {
        view?.setupInitialState()
    }
    
    func numberOfItems() -> Int {
        if contentIsLoaded == false {
            return DetailedActivityItems.empty.rawValue
        } else {
            return DetailedActivityItems.loaded.rawValue
        }
    }
    
    func contentState() -> DetailedActivityState {
        return state
    }
    
    func loadContent() {
        switch state {
        case .comment:
            interactor.loadComment()
        case .reply:
            interactor.loadReply()
        }
    }
    
}

extension DetailedActivityPresenter: DetailedActivityInteractorOutput {
    func failedLoadComment(error: Error) {
        comment = nil
        contentIsLoaded = false
        view?.setErrorText(text: error.localizedDescription)
    }
    
    func failedLoadReply(error: Error) {
        reply = nil
        contentIsLoaded = false
        view?.setErrorText(text: error.localizedDescription)
    }

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

extension DetailedActivityPresenter: ReplyCellModuleOutput {
    func removed(reply: Reply) {
        self.reply = nil
        router.back()
    }
    
    func showMenu(reply: Reply) {
        
    }
    
    var shouldOpenMenu: Bool {
        return false
    }
}

extension DetailedActivityPresenter: CommentCellModuleOutout {
    func removed(comment: Comment) {
        self.comment = nil
        router.back()
    }
    
    func showMenu(comment: Comment) {
        
    }
    
}
