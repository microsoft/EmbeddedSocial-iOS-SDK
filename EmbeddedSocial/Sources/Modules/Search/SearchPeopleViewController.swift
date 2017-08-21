//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import UIKit
import SnapKit

final class SearchPeopleViewController: UIViewController {
    
    weak var output: SearchPeopleViewOutput!
    
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
    }
}
