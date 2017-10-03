//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

final class CreateAccountInteractor: CreateAccountInteractorInput {
    private let userService: UserServiceType
    private let imagesService: ImagesServiceType
    private let authService: AuthServiceType
    weak var loginViewController: UIViewController?

    init(userService: UserServiceType,
         imagesService: ImagesServiceType,
         authService: AuthServiceType) {
        self.userService = userService
        self.imagesService = imagesService
        self.authService = authService
    }
    
    func createAccount(for user: User, completion: @escaping (Result<(user: User, sessionToken: String)>) -> Void) {
        if let creds = user.credentials, creds.provider == .twitter {
            createTwitterAccount(for: user, completion: completion)
        } else {
            userService.createAccount(for: user, completion: completion)
        }
    }
    
    private func createTwitterAccount(for user: User, completion: @escaping (Result<(user: User, sessionToken: String)>) -> Void) {
        guard let credentials = user.credentials else {
            completion(.failure(APIError.missingCredentials))
            return
        }
        
        guard let image = user.photo?.image else {
            userService.createAccount(for: user, photoHandle: nil, completion: completion)
            return
        }
        
        imagesService.uploadUserImage(image, authorization: credentials.authorization) { [weak self] result in
            guard let photoHandle = result.value else {
                completion(.failure(result.error ?? APIError.failedRequest))
                return
            }
            
            self?.logIntoTwitterAndCreateAccount(user: user, photoHandle: photoHandle, completion: completion)
        }
    }
    
    private func logIntoTwitterAndCreateAccount(
        user: User,
        photoHandle: String,
        completion: @escaping (Result<(user: User, sessionToken: String)>) -> Void) {
        
        authService.login(with: .twitter, from: loginViewController) { [weak self] loginResult in
            guard let socialUser = loginResult.value else {
                completion(.failure(loginResult.error ?? APIError.failedRequest))
                return
            }
            
            var user = user
            user.credentials = socialUser.credentials
            
            self?.userService.createAccount(for: user, photoHandle: photoHandle, completion: completion)
        }
    }
}
