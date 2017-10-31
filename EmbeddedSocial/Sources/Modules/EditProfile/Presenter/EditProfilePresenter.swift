//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import UIKit

class EditProfilePresenter: EditProfileViewOutput {
    
    weak var view: EditProfileViewInput!
    var interactor: EditProfileInteractorInput!
    weak var moduleOutput: EditProfileModuleOutput?
    var editModuleInput: EmbeddedEditProfileModuleInput!
    
    fileprivate let user: User
    
    init(user: User) {
        self.user = user
    }
    
    func viewIsReady() {
        editModuleInput.setupInitialState()
        view.setupInitialState(with: editModuleInput.getModuleView())
    }
    
    func onEditProfile() {
        editModuleInput.setIsLoading(true)
        view.setBackButtonEnabled(false)
        
        interactor.editProfile(me: editModuleInput.getFinalUser()) { [weak self] result in
            self?.editModuleInput.setIsLoading(false)
            self?.view.setBackButtonEnabled(true)
            
            if let user = result.value {
                if let photo = user.photo {
                    self?.interactor.cachePhoto(photo)
                }
                self?.moduleOutput?.onProfileEdited(me: user)
            } else if let error = result.error {
                self?.view.showError(error)
            }
        }
    }
}

extension EditProfilePresenter: EmbeddedEditProfileModuleOutput {
    
    var viewController: UIViewController? {
        return view as? UIViewController
    }
    
    func setRightNavigationButtonEnabled(_ isEnabled: Bool) {
        view.setSaveButtonEnabled(isEnabled)
    }
}
