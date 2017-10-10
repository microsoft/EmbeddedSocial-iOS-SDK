//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation
import SVProgressHUD

protocol PopularModuleViewInput: class {
    func setupInitialState(showGalleryView: Bool)
    func setCurrentFeedType(to index: Int)
    func setFeedTypesAvailable(types: [String])
    func lockFeedControl()
    func unlockFeedControl()
    func handleError(error: Error)
    func embedFeedViewController(_ viewController: UIViewController)
    
    func setFeedLayoutImage(_ image: UIImage)
}

protocol PopularModuleViewOutput {
    func viewIsReady()
    func feedTypeDidChange(to index: Int)
    func feedLayoutTypeChangeDidTap()
}

class PopularModuleView: UIViewController {
    
    var output: PopularModuleViewOutput!
    @IBOutlet var container: UIView!
    @IBOutlet var feedControl: UISegmentedControl! {
        didSet {
            feedControl.addTarget(self, action: #selector(onOptionChange), for: .valueChanged)
        }
    }
    
    // MARK: Private
    fileprivate lazy var layoutChangeButton: UIBarButtonItem = { [unowned self] in
        let button = UIBarButtonItem(
            image: nil,
            style: .plain,
            target: self,
            action: #selector(self.didTapChangeLayout))
        return button
        }()
    
    fileprivate var isLockedUI = 0 {
        didSet {
            
            guard isLockedUI >= 0 else {
                isLockedUI = 0
                return
            }
            
            feedControl.isEnabled = isLockedUI == 0
            container.isUserInteractionEnabled = isLockedUI == 0
            
            if isLockedUI == 0 {
                SVProgressHUD.dismiss()
            } else {
                SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.none)
                SVProgressHUD.show()
            }
            
            Logger.log(isLockedUI, feedControl.isEnabled)
        }
    }
    
    @objc private func didTapChangeLayout() {
        output.feedLayoutTypeChangeDidTap()
    }
    
    @objc private func onOptionChange(_ sender: UISegmentedControl) {
        output.feedTypeDidChange(to: sender.selectedSegmentIndex)
    }
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        output.viewIsReady()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Unlock on dismiss
        isLockedUI = 0
    }
    
    deinit {
        Logger.log()
    }
}

extension PopularModuleView: PopularModuleViewInput {
    
    func setupInitialState(showGalleryView: Bool) {
        if showGalleryView {
            navigationItem.rightBarButtonItem = layoutChangeButton
        }
        apply(theme: theme)
    }
    
    func setFeedLayoutImage(_ image: UIImage) {
        layoutChangeButton.image = image
    }
    
    func embedFeedViewController(_ viewController: UIViewController) {
        addChildController(viewController, containerView: container, pinToEdges: true)
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


extension PopularModuleView: Themeable {
    
    func apply(theme: Theme?) {
        guard let palette = theme?.palette else {
            return
        }

        view.backgroundColor = palette.topicsFeedBackground
        container.backgroundColor = palette.topicsFeedBackground
        feedControl.apply(theme: theme)
    }
}
