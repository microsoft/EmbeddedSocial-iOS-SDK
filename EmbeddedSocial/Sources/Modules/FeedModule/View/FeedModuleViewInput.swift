//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

protocol FeedModuleViewInput: class {

    func setupInitialState()
    func setLayout(type: FeedModuleLayoutType)
    func reload()
    func reload(with index: Int)
    func reloadVisible()
    func removeItem(index: Int)
    func setRefreshing(state: Bool)
    func showError(error: Error)
    
    func registerHeader<T: UICollectionReusableView>(withType type: T.Type, configurator: @escaping (T) -> Void)

    func getViewHeight() -> CGFloat

}
