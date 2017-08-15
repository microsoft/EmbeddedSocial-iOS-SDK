//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//


import UIKit

protocol PostMenuModuleViewInput: class {
    
    func setupInitialState()
    func showItems(items: [ActionViewModel])
    
}

protocol PostMenuModuleViewOutput {
    
    func viewIsReady()
    
}

class PostMenuModuleViewController: UIViewController, PostMenuModuleViewInput {
    
    var output: PostMenuModuleViewOutput!

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presentActionController()
    }
    
    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.clear
        output.viewIsReady()
    }
    
    // MARK: PostMenuModuleViewInput
    func setupInitialState() {
        
    }
    
    func showItems(items: [ActionViewModel]) {
        
        for item in items {
            addAction(title: item.title, action: item.action)
        }
        
        // Default item
        addAction(title: "Cancel", style: .cancel, action: nil)
    }
    
    // MARK: Private
    private func addAction(title: String, style: UIAlertActionStyle = .default, action: (() -> ())?) {
        
        let alertAction = UIAlertAction(title: title, style: style) { [weak self] (alertAction) in
            
            action?()
            self?.onActionControllerDismiss()
        }
        
        actionController.addAction(alertAction)
    }
    
    private func onActionControllerDismiss() {
        self.dismiss(animated: false) { [weak self] in
            self?.parent?.dismiss(animated: false, completion: nil)
        }
    }

    private lazy var actionController: UIAlertController = {
        return UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
    }()
    
    private func presentActionController() {
        self.present(actionController, animated: true)
    }
    
}
