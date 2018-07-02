//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import UIKit

protocol CellModel {
    var cellClass: UITableViewCell.Type { get }
    
    var reuseID: String { get }
}
