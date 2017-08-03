//
//  PostDetailPostDetailInitializer.swift
//  EmbeddedSocial-Framework
//
//  Created by generamba setup on 31/07/2017.
//  Copyright © 2017 akvelon. All rights reserved.
//

import UIKit

class PostDetailModuleInitializer: NSObject {

    //Connect with object on storyboard
    @IBOutlet weak var postdetailViewController: PostDetailViewController!

    override func awakeFromNib() {

        let configurator = PostDetailModuleConfigurator()
//        configurator.configureModuleForViewInput(viewInput: postdetailViewController)
    }

}
