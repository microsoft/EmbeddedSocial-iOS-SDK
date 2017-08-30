//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

protocol ReportViewInput: class {
    
    func setSubmitButtonEnabled(_ isEnabled: Bool)
    
    func showError(_ error: Error)
    
    func setIsLoading(_ isLoading: Bool)
    
    func selectCheckmark(at indexPath: IndexPath)
    
    func deselectCheckmark(at indexPath: IndexPath)
}
