//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import UIKit
import SnapKit

final class SearchPeopleViewController: UIViewController {
    
    weak var output: SearchPeopleViewOutput!
    
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

extension SearchPeopleViewController: SearchPeopleViewInput {
    
    func setupInitialState(listView: UIView) {
        view.addSubview(listView)
        listView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        view.bringSubview(toFront: noContentLabel)
    }
    
    func setIsEmpty(_ isEmpty: Bool) {
        guard noContentLabel != nil else { return }
        noContentLabel.isHidden = !isEmpty
    }
}
