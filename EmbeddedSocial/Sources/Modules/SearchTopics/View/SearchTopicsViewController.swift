//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import UIKit
import SnapKit

class SearchTopicsViewController: UIViewController {
    
    var output: SearchTopicsViewOutput!
    
    fileprivate var feedView: UIView?
    
    @IBOutlet weak var noContentLabel: UILabel! {
        didSet {
            noContentLabel.isHidden = true
            noContentLabel.textColor = Palette.darkGrey
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension SearchTopicsViewController: SearchTopicsViewInput {
    
    func setupInitialState(with feedViewController: UIViewController) {
        addChildController(feedViewController)
        feedViewController.view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        feedView = feedViewController.view
        view.bringSubview(toFront: noContentLabel)
    }
    
    func setIsEmpty(_ isEmpty: Bool) {
        guard noContentLabel != nil else { return }
        noContentLabel.isHidden = !isEmpty
        feedView?.isHidden = isEmpty
    }
}
