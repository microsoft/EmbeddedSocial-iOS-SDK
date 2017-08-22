//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

protocol FeedModuleOutput: class {
    func didScrollFeed(_ feedView: UIScrollView)
    
    func didStartRefreshingData()
    func didFinishRefreshingData(_ error: Error?)
}

//MARK: Optional methods
extension FeedModuleOutput {
    func didScrollFeed(_ feedView: UIScrollView) { }
    
    func didStartRefreshingData() { }
    func didFinishRefreshingData(_ error: Error?) { }
}
