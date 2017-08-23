//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation
import SVProgressHUD

protocol PopularModuleViewInput: class {
    func setCurrentFeedType(to index: Int)
    func setFeedTypesAvailable(types: [String])
    func lockFeedControl()
    func unlockFeedControl()
    func handleError(error: Error)
    func embedFeedViewController(_ viewController: UIViewController)
}

protocol PopularModuleViewOutput {
    func viewIsReady()
    func feedTypeDidChange(to index: Int)
}

class PopularModuleView: UIViewController {
    
    var output: PopularModuleViewOutput!
    @IBOutlet var container: UIView!
    @IBOutlet var feedControl: UISegmentedControl!
    
    // MARK: Private
    
    fileprivate var isLockedUI = 0 {
        didSet {
            
            guard isLockedUI >= 0 else {
                fatalError()
            }
            
            feedControl.isEnabled = isLockedUI == 0
            container.isUserInteractionEnabled = isLockedUI == 0
            
            if isLockedUI == 0 {
                SVProgressHUD.dismiss()
            } else {
                SVProgressHUD.show()
                SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.none)
            }
            
            Logger.log(isLockedUI, feedControl.isEnabled)
        }
    }
    
    @objc private func onOptionChange(_ sender: UISegmentedControl) {
        output.feedTypeDidChange(to: sender.selectedSegmentIndex)
    }
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        
        feedControl.tintColor = Palette.green
        feedControl.addTarget(self,
                              action: #selector(onOptionChange(_:)),
                              for: .valueChanged)
        
        output.viewIsReady()
    }
    
    deinit {
        Logger.log()
    }
}

extension PopularModuleView: PopularModuleViewInput {
    
    func embedFeedViewController(_ viewController: UIViewController) {
        viewController.willMove(toParentViewController: self)
        addChildViewController(viewController)
        container.addSubview(viewController.view)
        viewController.view.snp.makeConstraints { $0.edges.equalToSuperview() }
        viewController.didMove(toParentViewController: self)
    }
    
    func handleError(error: Error) {
        showErrorAlert(error)
    }
    
    func lockFeedControl() {
        isLockedUI += 1
    }
    
    func unlockFeedControl() {
        isLockedUI -= 1
    }
    
    func setFeedTypesAvailable(types: [String]) {
        
        feedControl.removeAllSegments()
        for (index, type) in types.enumerated() {
            feedControl.insertSegment(withTitle: type, at: index, animated: false)
        }
    }
    
    func setCurrentFeedType(to index: Int) {
        feedControl.selectedSegmentIndex = index
    }
}


