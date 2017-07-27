//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

enum FeedServiceError: Error {
    case failedToFetch(message: String)
    case failedToLike(message: String)
    case failedToUnLike(message: String)
    case failedToPin(message: String)
    case failedToUnPin(message: String)
    
    var message: String {
        switch self {
        case .failedToFetch(let message),
             .failedToPin(let message),
             .failedToUnPin(let message),
             .failedToLike(let message),
             .failedToUnLike(let message):
            return message
        }
    }
}

struct PostItem {
    var userName: String = ""
    var title: String = ""
    var text: String = ""
    var liked: String = ""
    var timeUpdated: String = ""
    var imageURL: String? = nil
    var handle: String!
}

struct PostsFeed {
    var items: [PostItem]
}

struct PostFetchResult {
    var posts: [Post] = [Post]()
    var error: FeedServiceError?
    var offset: String?
}

extension PostFetchResult {
    
    static func mock() -> PostFetchResult {
        var result = PostFetchResult()
        
        result.error = nil
        result.offset = nil
        
        let number = arc4random() % 5 + 1
        
        for index in 0..<number {
            result.posts.append(Post.mock(seed: Int(index)))
        }
        return result
    }
}

protocol PostServiceProtocol {
    func fetchPosts(offset: String?, limit: Int, callback: ((PostFetchResult) -> Void))
}

class PostServiceMock: PostServiceProtocol {
    
    func fetchPosts(offset: String?, limit: Int, callback: ((PostFetchResult) -> Void)) {
        
    }
}

typealias PostHandle = String

protocol HomeInteractorInput {
    
    func fetchPosts(with limit: Int)
    
    func like(with id: PostHandle)
    func unlike(with id: PostHandle)
    func pin(with id: PostHandle)
    func unpin(with id: PostHandle)
    
}

protocol HomeInteractorOutput: class {
    
    func didFetch(feed: PostsFeed)
    func didFetchMore(feed: PostsFeed)
    func didFail(error: FeedServiceError)
    
    func didLike(post id: PostHandle)
    func didUnlike(post id: PostHandle)
    func didUnpin(post id: PostHandle)
    func didPin(post id: PostHandle)
}

class HomeInteractor: HomeInteractorInput {
    
    // TODO: refactor there 4 methods using generics ?
    
    func unlike(with id: PostHandle) {
        likesService.deleteLike(postHandle: id) { (handle, err) in
            guard err != nil else {
                self.output.didFail(error: FeedServiceError.failedToUnLike(message: err!.localizedDescription))
                return
            }
        }
    }
    
    func unpin(with id: PostHandle) {
        pinsService.deletePin(postHandle: id) { (handle, err) in
            guard err != nil else {
                self.output.didFail(error: FeedServiceError.failedToUnPin(message: err!.localizedDescription))
                return
            }
            
            self.output.didUnpin(post: handle)
        }
    }
    
    var likesService: LikesServiceProtocol!
    var pinsService: PinsServiceProtocol!
    
    func pin(with id: String) {
        pinsService.postPin(postHandle: id) { (handle, err) in
            guard err != nil else {
                self.output.didFail(error: FeedServiceError.failedToPin(message: err!.localizedDescription))
                return
            }
            
            self.output.didPin(post: handle)
        }
    }

    func like(with id: String) {
    
        likesService.postLike(postHandle: id) { (handle, err) in
            guard err != nil else {
                self.output.didFail(error: FeedServiceError.failedToLike(message: err!.localizedDescription))
                return
            }
            
            self.output.didLike(post: handle)
        }
        
    }

    weak var output: HomeInteractorOutput!
    
    var offset: String = ""
    var postService: PostServiceProtocol! = PostServiceMock()
    
    func fetchPosts(with limit: Int) {
        postService.fetchPosts(offset: offset, limit: limit) { (result) in
            
            guard result.error == nil else {
                
                self.output.didFail(error: result.error!)
                
                return
            }
            
            let feed = self.buildPostsFeed(from: result.posts)
            
            if self.offset.isEmpty {
                self.output.didFetch(feed: feed)
            } else {
                self.output.didFetchMore(feed: feed)
            }
            
            self.offset = result.offset ?? ""
        }
    }
    
    private func buildPostsFeed(from posts: [Post]) -> PostsFeed {
        
        var items = [PostItem]()
        for post in posts {
            
            var item = PostItem()
            
            item.title = post.title!
            item.text = post.text!
            item.imageURL = post.imageUrl
//            item.liked = post.liked ?? ""
//            item.timeUpdated = post.timeUpdated!
//            item.imageURL = post.imageURL!
            
            items.append(item)
        }
        
        return PostsFeed(items: items)
    }
}
