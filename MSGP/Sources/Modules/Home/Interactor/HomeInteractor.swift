//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

enum PostDataFetchError: Error {
    case failedToFetch(message: String)
    
    var message: String {
        switch self {
        case .failedToFetch(message: let message):
            return message
        }
    }
}

struct HomePostItem {
    var title: String = ""
    var text: String = ""
    var liked: String = ""
    var timeUpdated: String = ""
    var postImage: Photo = Photo()
}

struct HomePostsFeed {
    var items: [HomePostItem]
}

struct PostData {
    var title: String?
    var text: String?
    var liked: String?
    var timeUpdated: String?
    var imageURL: String?
}

extension PostData {
    
    static var mockedCounter: Int = 0
    static func postItemMock() -> PostData {
        
        var item = PostData()
        item.title = "Mocked Post Title \(mockedCounter)"
        item.text = "Mocked Post Text \(mockedCounter)"
        mockedCounter += 1
        return item
    }
}

struct PostDataFetchResult {
    var posts: [PostData]?
    var error: PostDataFetchError?
    var offset: String?
}

extension PostDataFetchResult {
    
    static func postsFetchResultMock() -> PostDataFetchResult {
        var result = PostDataFetchResult()
        
        result.error = nil
        result.offset = nil
        
        let number = arc4random() % 5 + 1
        
        for _ in 0..<number {
            result.posts?.append(PostData.postItemMock())
        }
        return result
    }
}

protocol PostServiceProtocol {
    func fetchPosts(offset: String?, limit: Int, callback: ((PostDataFetchResult) -> Void)?)
}

class PostServiceMock: PostServiceProtocol {
    
    func fetchPosts(offset: String?, limit: Int, callback: ((PostDataFetchResult) -> Void)?) {
        
        
        
    }
}

class HomeInteractor: HomeInteractorInput {
    
    weak var output: HomeInteractorOutput!
    
    var items = [PostData]()
    var offset: String = ""
    var postService: PostServiceProtocol! = PostServiceMock()
    
    func fetchPosts(with limit: Int) {
        postService.fetchPosts(offset: offset, limit: limit) { (result) in
            
            guard result.error == nil else {
                
                self.output.didFail(error: result.error!)
                
                return
            }
            
            let feed = self.buildHomePostsFeed(from: result.posts!)
            
            if self.offset.isEmpty {
                self.output.didFetch(feed: feed)
            } else {
                self.output.didFetchMore(feed: feed)
            }
            
            self.offset = result.offset ?? ""
        }
    }
    
    private func postImagePlaceholder() -> UIImage {
        return UIImage(asset: .placeholderPostNoimage)
    }
    
    private func buildHomePostsFeed(from posts: [PostData]) -> HomePostsFeed {
        
        var items = [HomePostItem]()
        for post in posts {
            
            var item = HomePostItem()
            
            item.title = post.title!
            item.text = post.text!
            item.liked = post.liked ?? ""
            item.timeUpdated = post.timeUpdated!
            item.postImage = Photo(url: post.imageURL, imagePlaceholder: postImagePlaceholder())
            
            items.append(item)
        }
        
        let feed = HomePostsFeed(items: items)
        return feed
    }
}
