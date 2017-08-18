//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

class PopularModuleConfigurator {
    
    var viewController: UIViewController!
    
    func configure() {
        
        let view = PopularModuleView()
        
        let presenter = PopularModulePresenter()
        presenter.view = view
        
        presenter.feedModule = configuredFeedConfigurator.view
        
        view.output = presenter
    }
    
    private lazy var configuredFeedConfigurator: FeedModuleConfigurator = {
       
        let configurator = FeedModuleConfigurator()
        
        configurator.configure()
        
        return configurator.
        
    }()
    
}
