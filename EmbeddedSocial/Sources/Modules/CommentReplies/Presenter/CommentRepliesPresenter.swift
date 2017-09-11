//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

enum RepliesCellAction {
    case like, profile, toLikes, extra
}

struct ReplyViewModel {
    
    typealias ActionHandler = (RepliesCellAction, Int) -> Void
    
    var userName: String = ""
    var userHandle: String = ""
    var title: String = ""
    var text: String = ""
    var isLiked: Bool = false
    var totalLikes: String = ""
    var timeCreated: String = ""
    var userImageUrl: String? = nil
    var replyHandle: String = ""
    
    var cellType: String = ReplyCell.reuseID
    var onAction: ActionHandler?
}

class CommentRepliesPresenter: CommentRepliesModuleInput, CommentRepliesViewOutput, CommentRepliesInteractorOutput {

    var view: CommentRepliesViewInput?
    var interactor: CommentRepliesInteractorInput!
    var router: CommentRepliesRouterInput!
    
    var commentCell: CommentCell!
    var comment: Comment!
    
    var scrollType: RepliesScrollType = .none
    
    var replies = [Reply]()
    
    private var formatter = DateFormatterTool()
    fileprivate var shouldFetchRestOfReplies = false
    fileprivate var loadMoreCellViewModel = LoadMoreCellViewModel()
    
    private var cursor: String?
    private let maxLimit: Int = 30000
    private let myProfileHolder: UserHolder
    
    init(myProfileHolder: UserHolder) {
        self.myProfileHolder = myProfileHolder
    }
    
    //MARK Internal
    private func viewModel(with reply: Reply) -> ReplyViewModel {
        
        var viewModel = ReplyViewModel()
        viewModel.userHandle = reply.userHandle!
        viewModel.replyHandle = reply.replyHandle
        viewModel.userName = User.fullName(firstName: reply.userFirstName, lastName: reply.userLastName)
        viewModel.text = reply.text ?? ""
        
        viewModel.totalLikes = L10n.Post.likesCount(Int(reply.totalLikes))
        
        viewModel.timeCreated =  reply.createdTime == nil ? "" : formatter.shortStyle.string(from: reply.createdTime!, to: Date())!
        viewModel.userImageUrl = reply.userPhotoUrl
        
        viewModel.isLiked = reply.liked
        
        
        viewModel.cellType = CommentCell.reuseID
        viewModel.onAction = { [weak self] action, index in
            self?.handle(action: action, index: index)
        }
        
        return viewModel
    }
    
    private func handle(action: RepliesCellAction, index: Int) {
        
        let replyHandle = replies[index].replyHandle
        let reply = replies[index]
        let userHandle = replies[index].userHandle!
        
        switch action {
        case .like:
            guard myProfileHolder.me != nil else {
                router.openLogin(from: view as? UIViewController ?? UIViewController())
                return
            }
            
            let status = replies[index].liked
            let action: RepliesSocialAction = status ? .unlike : .like
            
            replies[index].liked = !status
            
            if action == .like {
                replies[index].totalLikes += 1
            } else if action == .unlike && replies[index].totalLikes > 0 {
                replies[index].totalLikes -= 1
            }
            
            view?.refreshReplyCell(index: index)
            interactor.replyAction(replyHandle: replyHandle!, action: action)
            
        case .profile:
            router.openUser(userHandle: userHandle, from: view as! UIViewController)
            
        case .toLikes:
            router.openLikes(replyHandle: replyHandle!, from: view as! UIViewController)
            
        case .extra:
            if reply.userHandle == SocialPlus.shared.me?.uid {
                router.openMyReplyOptions(reply: reply, from: view as! UIViewController)
            } else {
                router.openOtherReplyOptions(reply: reply, from: view as! UIViewController)
            }
        }
        
    }
    
    // MARK: CommentRepliesViewOutput
    
    func loadCellModel() -> LoadMoreCellViewModel {
        return loadMoreCellViewModel
    }
    
    func mainCommentCell() -> CommentCell {
        return commentCell
    }
    
    func refresh() {
        cursor = nil
        loadMoreCellViewModel.cellHeight = LoadMoreCell.cellHeight
        loadMoreCellViewModel.startLoading()
        interactor.fetchReplies(commentHandle: comment.commentHandle, cursor: cursor, limit: Constants.CommentReplies.pageSize)
    }
    
    func replyView(index: Int) -> ReplyViewModel {
        return viewModel(with: replies[index])
    }
    
    func canFetchMore() -> Bool {
        if cursor == nil || cursor == "" {
            return false
        }
        
        return true
    }
    
    func viewIsReady() {
        guard let commentHandle = comment.commentHandle else {
            return
        }
        
        switch scrollType {
        case .bottom:
            interactor.fetchReplies(commentHandle: commentHandle, cursor: cursor, limit: maxLimit)
        default:
            interactor.fetchReplies(commentHandle: commentHandle, cursor: cursor, limit: Constants.CommentReplies.pageSize)
        }
        
    }
    
    func fetchMore() {
        loadMoreCellViewModel.startLoading()
        view?.updateLoadingCell()
        if shouldFetchRestOfReplies {
            interactor.fetchReplies(commentHandle: comment.commentHandle, cursor: cursor, limit: maxLimit)
        } else {
            interactor.fetchMoreReplies(commentHandle: comment.commentHandle, cursor: cursor, limit: Constants.CommentReplies.pageSize)
        }
    }
    
    func loadRestReplies() {
        shouldFetchRestOfReplies = true
        scrollType = .bottom
        if cursor == nil {
            view?.reloadTable(scrollType: scrollType)
        } else {
            shouldFetchRestOfReplies = true
            fetchMore()
        }
    }
    
    func numberOfItems() -> Int {
        return replies.count
    }
    
    func postReply(text: String) {
        guard myProfileHolder.me != nil else {
            router.openLogin(from: view as? UIViewController ?? UIViewController())
            return
        }
        view?.lockUI()
        interactor.postReply(commentHandle: comment.commentHandle, text: text)
    }
    
    private func stopLoading() {
        if cursor == nil {
            loadMoreCellViewModel.cellHeight = 0.1
        }
        
        loadMoreCellViewModel.stopLoading()
    }
    
    // MARK: CommentRepliesInteractorOutput
    func fetched(replies: [Reply], cursor: String?) {
        self.cursor = cursor
        self.replies = replies
        self.replies.sort(by: { $0.0.createdTime! < $0.1.createdTime! })
        stopLoading()
        view?.reloadTable(scrollType: scrollType)
        
        scrollType = .none
    }
    
    func fetchedMore(replies: [Reply], cursor: String?) {
        self.cursor = cursor
        appendWithReplacing(original: &self.replies, appending: replies)
        self.replies.sort(by: { $0.0.createdTime! < $0.1.createdTime! })
        stopLoading()
        if cursor != nil && shouldFetchRestOfReplies == true {
            self.fetchMore()
        } else if shouldFetchRestOfReplies == true {
            view?.reloadTable(scrollType: .bottom)
            shouldFetchRestOfReplies = false
        } else {
            view?.reloadReplies()
        }
    }
    
    private func appendWithReplacing(original: inout [Reply], appending: [Reply]) {
        for appendingItem in appending {
            if let index = original.index(where: { $0.replyHandle == appendingItem.replyHandle }) {
                original[index] = appendingItem
            } else {
                original.append(appendingItem)
            }
        }
    }
    
    func replyPosted(reply: Reply) {
        if replies.contains(where: { $0.replyHandle == reply.replyHandle } ) {
            return
        }
        
        reply.userHandle = SocialPlus.shared.me?.uid
        appendWithReplacing(original: &replies, appending: [reply])
        comment.totalReplies += 1
        commentCell.configure(comment: comment)
        view?.replyPosted()
    }
    
    func replyFailPost(error: Error) {
        
    }
    
    func didPostAction(replyHandle: String, action: RepliesSocialAction, error: Error?) {
        
        if error != nil {
            
            guard let index = replies.enumerated().first(where: { $0.element.replyHandle == replyHandle })?.offset else {
                return
            }
            
            view?.refreshReplyCell(index: index)
        }
        
    }
}

extension CommentRepliesPresenter: PostMenuModuleOutput {
    
    func postMenuProcessDidStart() {
        //        view.setRefreshingWithBlocking(state: true)
    }
    
    func postMenuProcessDidFinish() {
        //        view.setRefreshingWithBlocking(state: false)
    }
    
    func didBlock(user: UserHandle) {
        Logger.log("Success")
    }
    
    func didUnblock(user: UserHandle) {
        Logger.log("Success")
    }
    
    func didRemove(reply: Reply) {
        guard let index = replies.index(where: { $0.replyHandle == reply.replyHandle }) else {
            return
        }
        
        replies.remove(at: index)
        comment.totalReplies -= 1
        commentCell.configure(comment: comment)
        view?.removeReply(index: index)
    }
    
    func didFollow(user: UserHandle) {
        for (index, item) in replies.enumerated() {
            if item.userHandle == user {
                replies[index].userStatus = .follow
                view?.refreshReplyCell(index: index)
                return
            }
        }
    }
    
    func didUnfollow(user: UserHandle) {
        for (index, item) in replies.enumerated() {
            if item.userHandle == user && item.userStatus == .follow {
                replies[index].userStatus = .none
                view?.refreshReplyCell(index: index)
                return
            }
        }
    }
    
    func didRequestFail(error: Error) {
        Logger.log("Reloading feed", error, event: .error)
    }
}
