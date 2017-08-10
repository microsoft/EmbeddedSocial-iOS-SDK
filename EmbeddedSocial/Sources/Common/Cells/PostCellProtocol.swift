//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

protocol PostCellProtocol: class {
    func configure(with data: PostViewModel, collectionView: UICollectionView)
    func indexPath() -> IndexPath
}
