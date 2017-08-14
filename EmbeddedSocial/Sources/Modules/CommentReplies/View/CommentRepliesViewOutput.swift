//
//  CommentRepliesCommentRepliesViewOutput.swift
//  EmbeddedSocial-Framework
//
//  Created by generamba setup on 14/08/2017.
//  Copyright © 2017 akvelon. All rights reserved.
//

protocol CommentRepliesViewOutput {

    /**
        @author generamba setup
        Notify presenter that view is ready
    */

    func viewIsReady()
    func numberOfItems() -> Int
}
