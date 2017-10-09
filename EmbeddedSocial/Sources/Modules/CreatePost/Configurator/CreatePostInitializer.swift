//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import UIKit

class CreatePostModuleInitializer: NSObject {

    //Connect with object on storyboard
    @IBOutlet weak var createpostViewController: CreatePostViewController!

    override func awakeFromNib() {

        let configurator = CreatePostModuleConfigurator()
//        configurator.configureModuleForViewInput(viewInput: createpostViewController)
    }

}
