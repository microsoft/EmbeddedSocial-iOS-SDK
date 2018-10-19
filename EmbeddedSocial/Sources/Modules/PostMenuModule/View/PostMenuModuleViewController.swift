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

class PostMenuModuleViewController: BaseViewController, PostMenuModuleViewInput {
    
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
    
    private var actions: [UIAlertAction] = [UIAlertAction]()
    
    func showItems(items: [ActionViewModel]) {
        
        actions = []
        
        for item in items {
            let action = makeAction(title: item.title, action: item.action)
            actions.append(action)
        }
        
        // Default item
        actions.append(makeAction(title: L10n.Common.cancel, style: .cancel, action: nil))
    }
    
    // MARK: Private
    private func makeAction(title: String, style: UIAlertAction.Style = .default, action: (() -> Void)?) -> UIAlertAction {
        
        let alertAction = UIAlertAction(title: title, style: style) { [weak self] (alertAction) in
            
            action?()
            self?.onActionControllerDismiss()
        }
        
        return alertAction
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
        
        actions.forEach {
            actionController.addAction($0)
        }
        
        self.present(actionController, animated: true)
    }
    
}
