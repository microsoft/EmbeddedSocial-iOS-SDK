//
//  HomeHomeViewInput.swift
//  MSGP-Framework
//
//  Created by igor.popov on 24/07/2017.
//  Copyright © 2017 akvelon. All rights reserved.
//

protocol HomeViewInput: class {

    /**
        @author igor.popov
        Setup initial state of the view
    */

    func setupInitialState()
    
    func setLayout(type: HomeLayoutType)
}
