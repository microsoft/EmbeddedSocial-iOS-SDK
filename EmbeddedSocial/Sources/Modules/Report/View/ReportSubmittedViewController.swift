//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import UIKit

class ReportSubmittedViewController: BaseViewController {
    
    var onDone: (() -> Void)?
    
    fileprivate lazy var doneButton: UIBarButtonItem = { [unowned self] in
        return UIBarButtonItem(title: L10n.Common.done, style: .plain, target: self, action: #selector(self.onDoneTapped))
    }()
    
    @IBOutlet fileprivate weak var separatorView: UIView! {
        didSet {
            separatorView.backgroundColor = UITableView().separatorColor
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = doneButton
        navigationItem.hidesBackButton = true
    }
    
    @objc private func onDoneTapped() {
        onDone?()
    }
}
