//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import UIKit

class TabMenuContainerModuleInitializer: NSObject {

    //Connect with object on storyboard
    @IBOutlet weak var tabmenucontainerViewController: TabMenuContainerViewController!

    override func awakeFromNib() {

        let configurator = TabMenuContainerModuleConfigurator()
        configurator.configureModuleForViewInput(viewInput: tabmenucontainerViewController)
    }

}
