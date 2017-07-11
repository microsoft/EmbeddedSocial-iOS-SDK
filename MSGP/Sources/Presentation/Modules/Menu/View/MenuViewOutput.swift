//
//  MenuMenuViewOutput.swift
//  MSGP-Framework
//
//  Created by igor.popov on 10/07/2017.
//  Copyright © 2017 akvelon. All rights reserved.
//

protocol MenuViewOutput {

    /**
        @author igor.popov
        Notify presenter that view is ready
    */

    func viewIsReady()
    
    func needConfigureCell(path: IndexPath) -> MenuCellViewModel
    func numberOfCells() -> Int {
    <#function body#>
    }
    func didTapCell(path: IndexPath)
}
