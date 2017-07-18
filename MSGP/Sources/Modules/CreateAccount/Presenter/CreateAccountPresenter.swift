//
//  CreateAccountCreateAccountPresenter.swift
//  MSGP
//
//  Created by ls on 06/07/2017.
//  Copyright © 2017 Akvelon. All rights reserved.
//

class CreateAccountPresenter: CreateAccountViewOutput {

    weak var view: CreateAccountViewInput!
    var interactor: CreateAccountInteractorInput!
    var router: CreateAccountRouterInput!
    weak var moduleOutput: CreateAccountModuleOutput?
    
    private var firstName: String?
    private var lastName: String?
    private var bio: String?
    private var photo: UIImage?
    
    private var user: SocialUser

    init(user: SocialUser) {
        firstName = user.firstName
        lastName = user.lastName
        photo = user.photo?.image
        bio = user.bio
        self.user = user
    }

    func viewIsReady() {        
        view.setupInitialState(with: user)
        updateCreateAccountButtonEnabledState()
    }
    
    func onFirstNameChanged(_ text: String?) {
        firstName = text
        updateCreateAccountButtonEnabledState()
    }
    
    func onLastNameChanged(_ text: String?) {
        lastName = text
        updateCreateAccountButtonEnabledState()
    }
    
    func onBioChanged(_ text: String?) {
        bio = text
        updateCreateAccountButtonEnabledState()
    }
    
    private func updateCreateAccountButtonEnabledState() {
        let options = CreateAccountValidator.Options(firstName: firstName, lastName: lastName, bio: bio, photo: photo)
        view.setCreateAccountButtonEnabled(CreateAccountValidator.validate(options))
    }
    
    func onSelectPhoto() {
        guard let vc = view as? UIViewController else {
            return
        }
        
        router.openImagePicker(from: vc) { [unowned self] result in
            if let image = result.value {
                let user = self.updatedCurrentUser(with: Photo(image: image))
                self.view.setUser(user)
            }
        }
    }
    
    func onCreateAccount() {
        interactor.createAccount(for: updatedCurrentUser()) { [weak self] result in
            if let user = result.value {
                self?.moduleOutput?.onAccountCreated(user: user)
            } else if let error = result.error {
                self?.view.showError(error)
            }
        }
    }
    
    private func updatedCurrentUser() -> SocialUser {
        return updatedCurrentUser(with: user.photo)
    }
    
    private func updatedCurrentUser(with photo: Photo?) -> SocialUser {
        user = SocialUser(uid: user.uid,
                          token: user.credentials.accessToken,
                          firstName: user.firstName,
                          lastName: lastName,
                          email: user.email,
                          bio: bio,
                          photo: photo,
                          provider: user.credentials.provider)
        return user
    }
}
