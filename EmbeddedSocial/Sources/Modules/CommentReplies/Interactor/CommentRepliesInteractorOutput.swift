//
//  CommentRepliesCommentRepliesInteractorOutput.swift
//  EmbeddedSocial-Framework
//
//  Created by generamba setup on 14/08/2017.
//  Copyright © 2017 akvelon. All rights reserved.
//

import Foundation

protocol CommentRepliesInteractorOutput: class {
    func fetched(replies: [Reply])
    func fetchedMore(replies: [Reply])
}
