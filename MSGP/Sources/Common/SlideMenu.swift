//
//  SlideMenu.swift
//  MSGP
//
//  Created by Igor Popov on 7/10/17.
//  Copyright © 2017 Igor Popov. All rights reserved.
//

import UIKit

protocol SlideMenuDelegate: class {
    
    func willOpen()
    func didOpen()
    func willClose()
    func didClose()
}

protocol SlideMenu {
    
    weak var delegate: SlideMenuDelegate? { get set }
    func embedInto(vc: UIViewController!)
    
}
