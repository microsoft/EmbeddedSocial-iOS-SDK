//
//  MenuMenuInteractor.swift
//  MSGP-Framework
//
//  Created by igor.popov on 10/07/2017.
//  Copyright © 2017 akvelon. All rights reserved.
//

class MenuInteractor: MenuInteractorInput {
    
    func cellViewModel(path: IndexPath) -> MenuCellViewModel {
        
        return MenuCellViewModel(title: "item #\(path.row)", pictureName: "icon_home")
        
    }
    
    weak var output: MenuInteractorOutput!

}
