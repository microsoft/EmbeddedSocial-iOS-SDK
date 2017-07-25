//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

class HomePresenter: HomeModuleInput, HomeViewOutput, HomeInteractorOutput {
    
    var layout: HomeLayoutType = .grid
    
    func didTapChangeLayout() {
        flip(layout: &layout)
        view.setLayout(type: layout)
    }
    
    func flip(layout: inout HomeLayoutType) {
        layout = HomeLayoutType(rawValue: layout.rawValue ^ 1)!
    }

    func itemModel(for path: IndexPath) -> TopicCellData {
        return items[path.row]
    }

    weak var view: HomeViewInput!
    var interactor: HomeInteractorInput!
    var router: HomeRouterInput!
    
    func viewIsReady() {
        view.setupInitialState()
        view.setLayout(type: layout)
    }
    
    lazy var items: [TopicCellData] = {

        return [
            TopicCellData(userName: "Willy Mates",
                          userPhoto: Photo(image: UIImage(asset: .placeholderPostUser1)),
                          postTitle: "New money !",
                          postText: "So legal, so Tender. What do you all think? Sweden took a risk here and it was worth it.", postCreation: "2h",
                          postImage: Photo(image: UIImage(asset: .placeholderPostImage))),
            TopicCellData(userName: "Gilly Dogs",
                          userPhoto: Photo(image: UIImage(asset: .placeholderPostUser1)),
                          postTitle: "About layouts",
                          postText: "The present disambiguation page holds the title of a primary topic, and an article needs to be written about it. It is believed to qualify as a broad-concept article. It may be written directly at this page or drafted elsewhere and then moved over here. Related titles should be described in Layout, while unrelated titles should be moved to Layout (disambiguation).", postCreation: "2h",
                          postImage: Photo(image: UIImage(asset: .placeholderPostImage))),
            TopicCellData(userName: "Doleres",
                          userPhoto: Photo(image: UIImage(asset: .placeholderPostUser1)),
                          postTitle: "New money !",
                          postText: "So legal, so Tender. What do you all think? Sweden took a risk here and it was worth it.", postCreation: "2h",
                          postImage: Photo(image: UIImage(asset: .placeholderPostImage))),
            TopicCellData(userName: "Github",
                          userPhoto: Photo(image: UIImage(asset: .placeholderPostUser1)),
                          postTitle: "N0 code today",
                          postText: "func numberOfItems() -> Int { return items.count }", postCreation: "2h",
                          postImage: Photo(image: UIImage(asset: .placeholderPostImage))),
            TopicCellData(userName: "Riarden Steel",
                          userPhoto: Photo(image: UIImage(asset: .placeholderPostUser1)),
                          postTitle: "New money !",
                          postText: "Best steel in the World.", postCreation: "2h",
                          postImage: Photo(image: UIImage(asset: .placeholderPostImage))),
        ]
    }()
    
    func numberOfItems() -> Int {
        return items.count
    }
    
    func didPullRefresh() {
        items.append(<#T##newElement: TopicCellData##TopicCellData#>)
    }
}
