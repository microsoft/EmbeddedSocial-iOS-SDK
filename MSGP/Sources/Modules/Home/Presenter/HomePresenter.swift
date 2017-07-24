//
//  HomeHomePresenter.swift
//  MSGP-Framework
//
//  Created by igor.popov on 24/07/2017.
//  Copyright © 2017 akvelon. All rights reserved.
//

class HomePresenter: HomeModuleInput, HomeViewOutput, HomeInteractorOutput {
    
    func itemModel(for path: IndexPath) -> TopicCellData {
        return items[path.row]
    }

    weak var view: HomeViewInput!
    var interactor: HomeInteractorInput!
    var router: HomeRouterInput!
    
    func viewIsReady() {
    
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
                          postImage: Photo(image: UIImage(asset: .placeholderPostImage)))
        ]
    }()
    
    func numberOfItems() -> Int {
        return items.count
    }
}
