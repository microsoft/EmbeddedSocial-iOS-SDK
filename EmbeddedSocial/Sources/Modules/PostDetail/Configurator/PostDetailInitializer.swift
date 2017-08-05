//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
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
