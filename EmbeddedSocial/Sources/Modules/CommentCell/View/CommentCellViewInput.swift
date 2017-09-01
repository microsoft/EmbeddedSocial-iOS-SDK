//
//  CommentCellCommentCellViewInput.swift
//  EmbeddedSocial-Framework
//
//  Created by generamba setup on 01/09/2017.
//  Copyright © 2017 akvelon. All rights reserved.
//

protocol CommentCellViewInput: class {
    func configure(comment: Comment)
    func setupInitialState()
}
