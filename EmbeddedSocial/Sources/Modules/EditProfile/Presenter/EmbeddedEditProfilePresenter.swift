//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

final class EmbeddedEditProfilePresenter {
    var view: EmbeddedEditProfileViewInput!
    
    var interactor: EmbeddedEditProfileInteractorInput!
    var router: EmbeddedEditProfileRouterInput!
    weak var moduleOutput: EmbeddedEditProfileModuleOutput?
    
    fileprivate var user: User
    
    init(user: User) {
        self.user = user
    }
}

extension EmbeddedEditProfilePresenter: EmbeddedEditProfileViewOutput {
    
    func setupInitialState() {
        view.setupInitialState(with: user)
        updateRightNavigationButtonEnabledState()
    }
    
    func onFirstNameChanged(_ text: String?) {
        user.firstName = text
        updateRightNavigationButtonEnabledState()
    }
    
    func onLastNameChanged(_ text: String?) {
        user.lastName = text
        updateRightNavigationButtonEnabledState()
    }
    
    func onBioChanged(_ text: String?) {
        user.bio = text
        updateRightNavigationButtonEnabledState()
    }
    
    private func updateRightNavigationButtonEnabledState() {
        let options = CreateAccountValidator.Options(firstName: user.firstName,
                                                     lastName: user.lastName,
                                                     bio: user.bio,
                                                     photo: user.photo?.image)
        moduleOutput?.setRightNavigationButtonEnabled(CreateAccountValidator.validate(options))
    }
    
    func onSelectPhoto() {
        guard let vc = moduleOutput?.viewController else {
            return
        }
        
        router.openImagePicker(from: vc) { [unowned self] result in
            if let image = result.value {
                self.user.photo = Photo(image: image)
                self.view.setUser(self.user)
            }
        }
    }
    
    func getFinalUser() -> User {
        let photo = interactor.updatedPhotoWithImageFromCache(user.photo)
        interactor.cachePhoto(photo)
        user.photo = photo
        return user
    }
}

extension EmbeddedEditProfilePresenter: EmbeddedEditProfileModuleInput {
    
    func setIsLoading(_ isLoading: Bool) {
        view.setIsLoading(isLoading)
        moduleOutput?.setRightNavigationButtonEnabled(!isLoading)
    }
    
    func getModuleView() -> UIView {
        return view as? UIView ?? UIView()
    }
}
