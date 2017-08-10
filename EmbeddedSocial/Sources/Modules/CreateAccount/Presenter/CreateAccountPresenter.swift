//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

class CreateAccountPresenter: CreateAccountViewOutput {
    
    weak var view: CreateAccountViewInput!
    var interactor: CreateAccountInteractorInput!
    var router: CreateAccountRouterInput!
    weak var moduleOutput: CreateAccountModuleOutput?
    
    private var firstName: String?
    private var lastName: String?
    private var bio: String?
    
    private var user: SocialUser
    private let imageCache: ImageCache
    
    init(user: SocialUser, imageCache: ImageCache = ImageCacheAdapter.shared) {
        firstName = user.firstName
        lastName = user.lastName
        bio = user.bio
        self.user = user
        self.imageCache = imageCache
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
        let options = CreateAccountValidator.Options(firstName: firstName,
                                                     lastName: lastName,
                                                     bio: bio,
                                                     photo: user.photo?.image)
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
        view.setIsLoading(true)
        view.setCreateAccountButtonEnabled(false)
        
        let photo = getPhotoFromCacheIfExists(user.photo)
        
        imageCache.store(photo: photo)
        
        interactor.createAccount(for: updatedCurrentUser(with: photo)) { [weak self] result in
            self?.view.setIsLoading(false)
            self?.view.setCreateAccountButtonEnabled(true)
            if let (user, sessionToken) = result.value {
                self?.moduleOutput?.onAccountCreated(user: user, sessionToken: sessionToken)
            } else if let error = result.error {
                self?.view.showError(error)
            }
        }
    }
    
    private func getPhotoFromCacheIfExists(_ photo: Photo?) -> Photo {
        guard photo?.image == nil else {
            return photo!
        }
        
        var photo = photo ?? Photo()
        photo.image = imageCache.image(for: photo)
        return photo
    }
    
    private func updatedCurrentUser(with photo: Photo?) -> SocialUser {
        user = SocialUser(uid: user.uid,
                          credentials: user.credentials,
                          firstName: firstName,
                          lastName: lastName,
                          email: user.email,
                          bio: bio,
                          photo: photo)
        return user
    }
}
