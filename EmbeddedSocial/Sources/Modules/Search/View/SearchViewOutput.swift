//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

protocol SearchViewOutput: class {
    
    func viewIsReady()
    
    func onTopics()
    
    func onPeople()
    
    func onFlipTopicsLayout()
}
