//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

protocol PostMenuModuleInteractorInput {
    
    typealias UserHandle = String
    typealias PostHandle = String
    
    func block(user: UserHandle)
    func repost(user: UserHandle)
    func follow(user: UserHandle)
    func unfollow(user: UserHandle)
    func hide(post: PostHandle)
    func edit(post: PostHandle)
    func remove(post: PostHandle)
    
}

protocol PostMenuModuleInteractorOutput: class {
    
}

class PostMenuModuleInteractor: PostMenuModuleInteractorInput {

    weak var output: PostMenuModuleInteractorOutput!

}
