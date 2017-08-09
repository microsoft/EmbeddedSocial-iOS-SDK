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
        embed()
    }
    
    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        output.viewIsReady()
    }
    
    
    // MARK: PostMenuModuleViewInput
    func setupInitialState() {
        
    }
    
    func addAction(title: String, action: @escaping () -> ()) {
        
        let newAction = UIAlertAction(title: title, style: .default) { (alertAction) in
            action()
        }
        
        actionController.addAction(newAction)
    }
    
    // MARK: Private
    
    private lazy var actionController: UIAlertController = {
        return UIAlertController(title: "A", message: "B", preferredStyle: .actionSheet)
    }()
    
    private func embed() {
        self.present(actionController, animated: false, completion: nil)
    }
    
}
