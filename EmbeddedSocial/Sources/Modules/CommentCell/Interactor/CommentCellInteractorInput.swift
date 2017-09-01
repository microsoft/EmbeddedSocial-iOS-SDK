//
//  CommentCellCommentCellInteractorInput.swift
//  EmbeddedSocial-Framework
//
//  Created by generamba setup on 01/09/2017.
//  Copyright © 2017 akvelon. All rights reserved.
//

import Foundation

protocol CommentCellInteractorInput {
    func commentAction(commentHandle: String, action: CommentSocialAction)
}
