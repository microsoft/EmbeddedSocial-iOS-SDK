//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import UIKit

extension UIViewController {
    typealias AlertActionHandler = ((UIAlertAction) -> Void)
    
    func showAlert(message: String, closeTitle: String = L10n.Common.close) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let closeButton = UIAlertAction(title: closeTitle, style: .default, handler: nil)
        alert.addAction(closeButton)
        
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func showYesNoAlert(message: String?,
                        yesTitle: String = L10n.Common.ok,
                        noTitle: String = L10n.Common.cancel,
                        noHandler: AlertActionHandler? = nil,
                        yesHandler: AlertActionHandler? = nil) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: yesTitle, style: .default, handler: yesHandler ?? { _ in () })
        alertController.addAction(okAction)
        
        let cancelAction = UIAlertAction(title: noTitle, style: .cancel, handler: noHandler ?? { _ in () })
        alertController.addAction(cancelAction)
        
        DispatchQueue.main.async { [weak self] in
            self?.present(alertController, animated: true, completion: nil)
        }
    }
    
    func showErrorAlert(_ error: Error, ignoreNoConnectionErrors: Bool = true) {
        if ignoreNoConnectionErrors, let error = error as? APIError, case .notConnectedToInternet = error {
            return
        }
        
        showAlert(message: error.localizedDescription)
    }
}
