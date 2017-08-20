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
    
    var commentView: CommentViewModel?
    
    var scrollType: RepliesScrollType?
    
    var replies = [Reply]()
    
    private var formatter = DateFormatterTool()
    fileprivate var shouldFetchRestOfReplies = false
    
    private var cursor: String?
    private let maxLimit: Int = 10
    private let normalLimit: Int = 10000
    
    private func viewModel(with reply: Reply) -> ReplyViewModel {
        
        var viewModel = ReplyViewModel()
        viewModel.userHandle = reply.userHandle!
        viewModel.replyHandle = reply.replyHandle!
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
        
        let replyHandle = replies[index].replyHandle!
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
            interactor.replyAction(replyHandle: replyHandle, action: action)
            
            
        case .profile:
            router.openUser(userHandle: userHandle, from: view as! UIViewController)
        }
        
    }
    
    func didPostAction(replyHandle: String, action: RepliesSocialAction, error: Error?) {
        
        if error != nil {
            
            guard let index = replies.enumerated().first(where: { $0.element.replyHandle == replyHandle })?.offset else {
                return
            }
            
            let status = replies[index].liked
            
            replies[index].liked = !status
            
            switch action {
            case .like:
                replies[index].totalLikes -= 1
            default:
                replies[index].totalLikes += 1
            }
            
            view?.refreshReplyCell(index: index)
        }
    
    }
    
    func refreshCommentCell(commentView: CommentViewModel) {
        self.commentView = commentView
        view?.refreshCommentCell()
    }
    
    func replyView(index: Int) -> ReplyViewModel {
        return viewModel(with: replies[index])
    }

    func fetchedMore(replies: [Reply], cursor: String?) {
        self.cursor = cursor
        self.replies.append(contentsOf: replies)
        view?.reloadTable(scrollType: .none)
    }
    
    func replyPosted(reply: Reply) {
        reply.userHandle = SocialPlus.shared.me?.uid
        replies.append(reply)
        view?.replyPosted()
    }
    
    func replyFailPost(error: Error) {
        
    }
    
    func viewIsReady() {
        if (commentView?.comment?.totalReplies)! > 0 {
            interactor.fetchReplies(commentHandle: (commentView?.commentHandle)!, cursor: cursor, limit: normalLimit)
        } else {
            view?.reloadTable(scrollType: scrollType ?? .none)
        }
        
    }
    
    func fetchMore() {
        if shouldFetchRestOfReplies {
            interactor.fetchReplies(commentHandle: (commentView?.commentHandle)!, cursor: cursor, limit: maxLimit)
        } else {
            interactor.fetchMoreReplies(commentHandle: (commentView?.commentHandle)!, cursor: cursor, limit: normalLimit)
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
    
    func mainComment() -> CommentViewModel {
        return commentView!
    }
    
    func numberOfItems() -> Int {
        return replies.count
    }
    
    func postReply(text: String) {
        interactor.postReply(commentHandle: (commentView?.commentHandle)!, text: text)
    }
    
    func fetched(replies: [Reply], cursor: String?) {
        self.cursor = cursor
        self.replies = replies
        view?.reloadTable(scrollType: .none)
    }
}
