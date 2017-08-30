//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

protocol ReportViewOutput: class {
    func viewIsReady()
    
    func onRowSelected(at indexPath: IndexPath)
    
    func onSubmit()
    
    func onCancel()
}
