//
//  CommentCellCommentCellRouterInput.swift
//  EmbeddedSocial-Framework
//
//  Created by generamba setup on 01/09/2017.
//  Copyright © 2017 akvelon. All rights reserved.
//

import Foundation

protocol CommentCellRouterInput {
    func openReplies(scrollType: RepliesScrollType, commentModulePresenter: CommentCellModuleProtocol)
    func openUser(userHandle: String)
    func openImage(imageUrl: String)
}
