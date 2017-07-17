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
    
    private let socialUser: SocialUser
    private var user: User!

    init(user: SocialUser) {
        firstName = user.firstName
        lastName = user.lastName
        photo = user.photo?.image
        self.socialUser = user
        self.user = makeUserFromCurrentState(with: user.photo)
    }

    func viewIsReady() {        
        view.setupInitialState(with: user)
    }
    
    func onFirstNameChanged(_ text: String?) {
        firstName = text
    }
    
    func onLastNameChanged(_ text: String?) {
        lastName = text
    }
    
    func onBioChanged(_ text: String?) {
        bio = text
    }
    
    func onSelectPhoto() {
        guard let vc = view as? UIViewController else {
            return
        }
        
        router.openImagePicker(from: vc) { [unowned self] result in
            if let image = result.value {
                self.user = self.makeUserFromCurrentState(with: Photo(image: image))
                self.view.setUser(self.user)
            }
        }
    }
    
    private func makeUserFromCurrentState(with photo: Photo?) -> User {
        return User(uid: socialUser.uid,
                    socialUserUID: socialUser.uid,
                    socialUserToken: socialUser.token,
                    firstName: firstName,
                    lastName: lastName,
                    email: socialUser.email,
                    bio: bio,
                    photo: photo,
                    provider: socialUser.provider)
    }
}
