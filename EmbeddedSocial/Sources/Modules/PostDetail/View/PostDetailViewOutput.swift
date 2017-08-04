//
//  PostDetailPostDetailViewOutput.swift
//  EmbeddedSocial-Framework
//
//  Created by generamba setup on 31/07/2017.
//  Copyright © 2017 akvelon. All rights reserved.
//

protocol PostDetailViewOutput {

    /**
        @author generamba setup
        Notify presenter that view is ready
    */

    func viewIsReady()
    func numberOfItems() -> Int
    var post: Post? {get set}
    func commentForPath(path: IndexPath) -> Comment
}
