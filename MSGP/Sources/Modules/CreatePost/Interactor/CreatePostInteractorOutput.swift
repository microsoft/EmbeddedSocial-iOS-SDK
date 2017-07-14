//
//  CreatePostCreatePostInteractorOutput.swift
//  MSGP-Framework
//
//  Created by generamba setup on 12/07/2017.
//  Copyright © 2017 akvelon. All rights reserved.
//

import Foundation

protocol CreatePostInteractorOutput: class {
    func created(post: PostTopicResponse)
    func postCreationFailed(error: Error)
}
