//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

class AbstractPaginatedListProcessor<ListItem> {
    var isLoadingList = false
    
    var listHasMoreItems: Bool {
        return false
    }
    
    weak var delegate: PaginatedListProcessorDelegate?
    
    func getNextListPage(completion: @escaping (Result<[ListItem]>) -> Void) {
        
    }
    
    func setAPI(_ api: ListAPI<ListItem>) {
        
    }
    
    func reloadList(completion: @escaping (Result<[ListItem]>) -> Void) {
        
    }
    
    func resetLoadingState() {
        
    }
}
