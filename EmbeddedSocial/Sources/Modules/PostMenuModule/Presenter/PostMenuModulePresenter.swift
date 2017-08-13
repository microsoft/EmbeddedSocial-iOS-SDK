//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

protocol PostMenuModuleModuleOutput: class {
    

}

protocol PostMenuModuleModuleInput: class {

}

enum PostMenuType {
    case myPost(post: PostHandle)
    case otherPost(user: UserHandle, post: PostHandle)
}

struct ActionViewModel {
    
    typealias ActionHandler = () -> ()
    
    var title: String = ""
    var action: ActionHandler!
}

class PostMenuModulePresenter: PostMenuModuleViewOutput, PostMenuModuleModuleInput, PostMenuModuleInteractorOutput {

    weak var view: PostMenuModuleViewInput!
    var interactor: PostMenuModuleInteractorInput!
    var router: PostMenuModuleRouterInput!
    var menuType: PostMenuType!
    
    
    func viewIsReady() {
        
        let items = itemsForMenu(type: menuType)
        view.showItems(items: items)
        
    }
    
    // MARK: Actions
    private func itemsForMenu(type: PostMenuType) -> [ActionViewModel] {
        switch type {
        case .myPost(let post):
            return buildActionListForMyPost(post: post)
        case .otherPost(let user, let post):
            return buildActionListForOtherPost(user: user, post: post)
        }
    }
    
    private func buildActionListForOtherPost(user: UserHandle, post: PostHandle) -> [ActionViewModel] {
        
        var followItem = ActionViewModel()
        followItem.title = "Follow"
        followItem.action = { [weak self] in
            self?.interactor.follow(user: user)
        }
        
        var blockItem = ActionViewModel()
        blockItem.title = "Block user"
        blockItem.action = { [weak self] in
            self?.interactor.block(user: user)
        }
        
        var reportItem = ActionViewModel()
        reportItem.title = "Report Post"
        reportItem.action = { [weak self] in
            self?.interactor.repost(user: user)
        }

        return [followItem, blockItem, reportItem]
    }
    
    
    private func buildActionListForMyPost(post: PostHandle) -> [ActionViewModel] {
        
        var editItem = ActionViewModel()
        editItem.title = "Edit Post"
        editItem.action = { [weak self] in
            self?.interactor.edit(post: post)
        }
        
        var removeitem = ActionViewModel()
        removeitem.title = "Remove Post"
        removeitem.action = { [weak self] in
            self?.interactor.remove(post: post)
        }
        
        return [editItem, removeitem]
    }
    
    // MARK: Interactor Output
    func didBlock(user: UserHandle, error: Error?) {
        Logger.log()
    }
    
    func didRepost(user: UserHandle, error: Error?) {
        Logger.log()
    }
    
    func didFollow(user: UserHandle, error: Error?) {
        Logger.log()
    }
    
    func didUnFollow(user: UserHandle, error: Error?) {
        Logger.log()
    }
    
    func didHide(post: PostHandle, error: Error?) {
        Logger.log()
    }
    
    func didEdit(post: PostHandle, error: Error?) {
        Logger.log()
    }
    
    func didRemove(post: PostHandle, error: Error?) {
        Logger.log()
    }
    
    func didReport(post: PostHandle, error: Error?) {
        Logger.log()
    }
    
}
