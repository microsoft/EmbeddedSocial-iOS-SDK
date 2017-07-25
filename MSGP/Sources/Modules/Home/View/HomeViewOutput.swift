//
//  HomeHomeViewOutput.swift
//  MSGP-Framework
//
//  Created by igor.popov on 24/07/2017.
//  Copyright © 2017 akvelon. All rights reserved.
//

protocol HomeViewOutput {

    /**
        @author igor.popov
        Notify presenter that view is ready
    */

    func viewIsReady()
    
    func numberOfItems() -> Int
    func itemModel(for path: IndexPath) -> TopicCellData
    
    func didTapChangeLayout()
    func didPullRefresh()
    
}
