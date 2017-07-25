//
//  HomeHomeRouterInput.swift
//  MSGP-Framework
//
//  Created by igor.popov on 24/07/2017.
//  Copyright © 2017 akvelon. All rights reserved.
//

import Foundation

enum HomeAction {
    
    typealias PostReference = String

    case liked(post: PostReference)
    case open(post: PostReference)
    
}

protocol HomeRouterInput {
    
    func open(with action:HomeAction)

}
