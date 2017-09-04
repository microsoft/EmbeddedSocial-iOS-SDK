//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

enum RepliesCellAction {
    case like, profile
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

    weak var view: CommentRepliesViewInput?
    var interactor: CommentRepliesInteractorInput!
    var router: CommentRepliesRouterInput!
    
    var commentCell: CommentCell!
    var comment: Comment!
    
    var scrollType: RepliesScrollType = .none
    
    var replies = [Reply]()
    
    private var formatter = DateFormatterTool()
    fileprivate var shouldFetchRestOfReplies = false
    
    private var cursor: String?
    private let maxLimit: Int = 10000
    private let normalLimit: Int = 50
    
    //MARK Internal
    private func viewModel(with reply: Reply) -> ReplyViewModel {
        
        var viewModel = ReplyViewModel()
        viewModel.userHandle = reply.userHandle!
        viewModel.replyHandle = reply.replyHandle
        viewModel.userName = String(format: "%@ %@", (reply.userFirstName ?? ""), (reply.userLastName ?? ""))
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
        let userHandle = replies[index].userHandle!
        
        switch action {
        case .like:
            
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
        }
        
    }
    
    // MARK: CommentRepliesViewOutput
    
    func mainCommentCell() -> CommentCell {
        return commentCell
    }
    
    func refresh() {
        cursor = nil
        interactor.fetchReplies(commentHandle: comment.commentHandle, cursor: cursor, limit: normalLimit)
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
        
//        if (commentView?.comment?.totalReplies)! > 0 {
            switch scrollType {
            case .bottom:
                interactor.fetchReplies(commentHandle: commentHandle, cursor: cursor, limit: maxLimit)
            default:
                interactor.fetchReplies(commentHandle: commentHandle, cursor: cursor, limit: normalLimit)
            }
//        } else {
//            view?.reloadTable(scrollType: scrollType)
//        }
        
    }
    
    func fetchMore() {
        if shouldFetchRestOfReplies {
            interactor.fetchReplies(commentHandle: comment.commentHandle, cursor: cursor, limit: maxLimit)
        } else {
            interactor.fetchMoreReplies(commentHandle: comment.commentHandle, cursor: cursor, limit: normalLimit)
        }
    }
    
    func loadRestReplies() {
        if cursor == nil {
            view?.reloadTable(scrollType: .bottom)
        } else {
            shouldFetchRestOfReplies = true
            fetchMore()
        }
    }
    
    func numberOfItems() -> Int {
        return replies.count
    }
    
    func postReply(text: String) {
        interactor.postReply(commentHandle: comment.commentHandle, text: text)
    }
    
    // MARK: CommentRepliesInteractorOutput
    func fetched(replies: [Reply], cursor: String?) {
        self.cursor = cursor
        appendWithReplacing(original: &self.replies, appending: replies)
        view?.reloadTable(scrollType: scrollType)
        scrollType = .none
    }
    
    func fetchedMore(replies: [Reply], cursor: String?) {
        self.cursor = cursor
        appendWithReplacing(original: &self.replies, appending: replies)
        view?.reloadTable(scrollType: .none)
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
