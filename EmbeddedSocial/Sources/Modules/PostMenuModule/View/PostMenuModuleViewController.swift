//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//


import UIKit

protocol PostMenuModuleViewInput: class {
    
    typealias ActionHandler = () -> ()
    
    func setupInitialState()
    func addAction(title: String, action: @escaping ActionHandler)
    
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
    
    func addAction(title: String, action: @escaping () -> ()) {
        
        let newAction = UIAlertAction(title: title, style: .default) { [weak self] (alertAction) in
            
            action()
            self?.onActionControllerDismiss()
        }
        
        actionController.addAction(newAction)
    }
    
    private func onActionControllerDismiss() {
        self.dismiss(animated: false) { [weak self] in
            self?.parent?.dismiss(animated: false, completion: nil)
        }
    }
    
    // MARK: Private
    private lazy var actionController: UIAlertController = {
        return UIAlertController(title: "A", message: "B", preferredStyle: .actionSheet)
    }()
    
    private func presentActionController() {
        self.present(actionController, animated: true)
    }
    
}
