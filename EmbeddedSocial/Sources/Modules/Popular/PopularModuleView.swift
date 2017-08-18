//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

protocol PopularModuleViewInput: class {
    func setCurrentFeedType(to index: Int)
    func setFeedTypesAvailable(types: [String])
}

protocol PopularModuleViewOutput {
    func viewIsReady()
    func feedTypeDidChange(to index: Int)
}

class PopularModuleView: UIViewController, PopularModuleViewInput {

    var output: PopularModuleViewOutput!
    
    private lazy var feedControl: UISegmentedControl = {
  
        let control = UISegmentedControl()
        control.addTarget(self, action: #selector(onOptionChange(_:)), for: .valueChanged)
        
        return control
    }()
    
    // MARK: Private
    @objc private func onOptionChange(_ sender: UISegmentedControl) {
        output.feedTypeDidChange(to: sender.selectedSegmentIndex)
    }
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        output.viewIsReady()
    }
    
    // MARK: Input
    func setFeedTypesAvailable(types: [String]) {
        
        feedControl.removeAllSegments()
        for (index, type) in types.enumerated() {
            feedControl.setTitle(type, forSegmentAt: index)
        }
    }
    
    func setCurrentFeedType(to index: Int) {
        feedControl.selectedSegmentIndex = index
    }
}
