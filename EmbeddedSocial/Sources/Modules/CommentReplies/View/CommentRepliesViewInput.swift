//
//  CommentRepliesCommentRepliesViewInput.swift
//  EmbeddedSocial-Framework
//
//  Created by generamba setup on 14/08/2017.
//  Copyright © 2017 akvelon. All rights reserved.
//

protocol CommentRepliesViewInput: class {

    /**
        @author generamba setup
        Setup initial state of the view
    */

    func setupInitialState()
    func reloadTable()
}
