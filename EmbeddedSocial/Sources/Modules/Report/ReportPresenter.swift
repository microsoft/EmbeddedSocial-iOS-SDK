//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

final class ReportPresenter {
    
    weak var view: ReportViewInput!
    var interactor: ReportInteractorInput!
    
    fileprivate var selectedIndexPath: IndexPath? {
        didSet {
            if let oldValue = oldValue {
                view.deselectCheckmark(at: oldValue)
            }
            
            if let newValue = selectedIndexPath {
                view.selectCheckmark(at: newValue)
            }
        }
    }
    
    fileprivate var isSubmitButtonEnabled: Bool {
        return selectedIndexPath != nil
    }
    
    fileprivate let userID: String
    
    init(userID: String) {
        self.userID = userID
    }
}

extension ReportPresenter: ReportViewOutput {
    
    func viewIsReady() {
        view.setSubmitButtonEnabled(isSubmitButtonEnabled)
    }
    
    func onRowSelected(at indexPath: IndexPath) {
        selectedIndexPath = indexPath
        view.setSubmitButtonEnabled(isSubmitButtonEnabled)
    }
    
    func onSubmit() {
        guard let selectedIndexPath = selectedIndexPath,
            let reason = interactor.reportReason(forIndexPath: selectedIndexPath) else {
            return
        }
        
        view.setIsLoading(true)
        
        interactor.report(userID: userID, reason: reason) { [weak self] result in
            self?.view.setIsLoading(false)
            
            if result.isSuccess {
                
            } else {
                self?.view.showError(result.error ?? APIError.unknown)
            }
        }
    }
}
