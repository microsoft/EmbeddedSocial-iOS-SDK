//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

protocol SearchViewInput: class {
    
    func setupInitialState(_ tab: SearchTabInfo)
    
    func switchTabs(to tab: SearchTabInfo, from previousTab: SearchTabInfo)
    
    func showError(_ error: Error)
    
    func setLayoutAsset(_ asset: Asset)
    
    func search(hashtag: Hashtag)
    
    func setTopicsLayoutFlipEnabled(_ isEnabled: Bool)
}
