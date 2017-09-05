//
//  CommentCellCommentCellViewOutput.swift
//  EmbeddedSocial-Framework
//
//  Created by generamba setup on 01/09/2017.
//  Copyright © 2017 akvelon. All rights reserved.
//

protocol CommentCellViewOutput {
    func viewIsReady()
    func like()
    func toReplies(scrollType: RepliesScrollType)
    func avatarPressed()
    func mediaPressed()
    func likesPressed()
}
