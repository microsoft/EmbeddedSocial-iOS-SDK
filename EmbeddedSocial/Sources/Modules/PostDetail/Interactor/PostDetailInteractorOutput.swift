//
//  PostDetailPostDetailInteractorOutput.swift
//  EmbeddedSocial-Framework
//
//  Created by generamba setup on 31/07/2017.
//  Copyright © 2017 akvelon. All rights reserved.
//

import Foundation

protocol PostDetailInteractorOutput: class {
    func didFetch(comments: [Comment])
    func didFetchMore(comments: [Comment])
    func didFail(error: CommentsServiceError)
}
