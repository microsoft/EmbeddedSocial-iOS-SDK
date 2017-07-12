//
//  CreatePostCreatePostInitializer.swift
//  MSGP-Framework
//
//  Created by generamba setup on 12/07/2017.
//  Copyright © 2017 akvelon. All rights reserved.
//

import UIKit

class CreatePostModuleInitializer: NSObject {

    //Connect with object on storyboard
    @IBOutlet weak var createpostViewController: CreatePostViewController!

    override func awakeFromNib() {

        let configurator = CreatePostModuleConfigurator()
        configurator.configureModuleForViewInput(viewInput: createpostViewController)
    }

}
