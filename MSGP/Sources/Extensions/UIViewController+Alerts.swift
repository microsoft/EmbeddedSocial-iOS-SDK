//
//  UIViewController+Alerts.swift
//  MSGP
//
//  Created by Vadim Bulavin on 7/13/17.
//  Copyright © 2017 Akvelon. All rights reserved.
//

import Foundation

extension UIViewController {
    typealias AlertActionHandler = ((UIAlertAction) -> Void)
    
    func showAlert(message: String, closeTitle: String = "Close") {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let closeButton = UIAlertAction(title: closeTitle, style: .default, handler: nil)
        alert.addAction(closeButton)
        
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func showYesNoAlert(message: String?,
                        yesTitle: String = "OK",
                        noTitle: String = "Cancel",
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
    
    func showErrorAlert(_ error: Error) {
        showAlert(message: error.localizedDescription)
    }
}
