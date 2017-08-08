//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

protocol FeedModuleInput: class {
    
    // For feed change
    func setFeed(_ feed: FeedType)
    // Forcing module to update
    func refreshData()
    // Get Current Module Height
    func moduleHeight() -> CGFloat

    
    func registerHeader<T: UICollectionReusableView>(withType type: T.Type,
                        size: CGSize,
                        configurator: @escaping (T) -> Void)
    // Get Current Module Height
    func moduleHeight() -> CGFloat
    // Change layout
    var layout: FeedModuleLayoutType { get set }
}
