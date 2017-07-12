//
//  CreatePostCreatePostViewOutput.swift
//  MSGP-Framework
//
//  Created by generamba setup on 12/07/2017.
//  Copyright © 2017 akvelon. All rights reserved.
//

protocol CreatePostViewOutput {

    /**
        @author generamba setup
        Notify presenter that view is ready
    */

    func viewIsReady()
    func post(image: UIImage?, title: String?, body: String!)
}
