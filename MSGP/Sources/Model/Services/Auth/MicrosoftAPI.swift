//
//  MicrosoftAPI.swift
//  MSGP
//
//  Created by Vadim Bulavin on 7/12/17.
//  Copyright © 2017 Akvelon. All rights reserved.
//

import Foundation
import MSAL

private let clientID = "5e4ecf55-0958-4324-b32a-332e42064697"

enum GraphScope: String {
    case userRead = "User.Read"
}

private enum APIError: LocalizedError {
    case unkown
    case responseError(String)
    
    public var unkown: String? {
        switch self {
        case .unkown: return "Unknown error occurred."
        case let .responseError(path): return "Response \(path) returned with error."
        }
    }
}

class GraphClient {
    private let token: String
    
    class func graphURL(with path: String) -> URL {
        return URL(string: "https://graph.microsoft.com/beta/\(path)")!
    }
    
    init(token: String) {
        self.token = token
    }
    
    func getJSON(path: String, completion: @escaping (_ json: [String: Any]?, Error?) -> Void) {
        getData(path: path) { (data, error) in
            guard error == nil else {
                completion(nil, error!)
                return
            }
            
            do {
                let resultJson = try JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any]
                completion(resultJson, nil)
                return
            } catch {
                completion(nil, error)
                return
            }
        }
    }
    
    func getData(path: String, completion: @escaping (_ data: Data?, Error?) -> Void) {
        var request = URLRequest(url: GraphClient.graphURL(with: path))
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = ["Authorization": "Bearer \(token)"]
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else {
                completion(nil, error!)
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completion(nil, APIError.responseError(path))
                return
            }
            
            completion(data, nil)
        }
        task.resume()
    }
}

final class MicrosoftAPI: AuthAPI {
    private let scopes = [GraphScope.userRead.rawValue]
    
    private let application: MSALPublicClientApplication = {
        guard let app = try? MSALPublicClientApplication(clientId: clientID) else {
            let url = "https://github.com/AzureAD/microsoft-authentication-library-for-objc"
            fatalError("Microsoft ClientId is not set. Please follow the instructions from \(url)")
        }
        return app
    }()
    
    private let imageCache: ImageCache
    
    init(imageCache: ImageCache) {
        self.imageCache = imageCache
    }
    
    func login(from viewController: UIViewController?, handler: @escaping (Result<User>) -> Void) {
        application.acquireToken(forScopes: scopes) { result, error in
            guard error == nil else {
                handler(.failure(error!))
                return
            }
            
            guard let result = result else {
                handler(.failure(APIError.unkown))
                return
            }
            
            self.getUserInfo(token: result.accessToken, handler: handler)
        }
    }
    
    private func getUserInfo(token: String, handler: @escaping (Result<User>) -> Void) {
        let graphClient = GraphClient(token: token)
        
        var userJSON: [String: Any]?
        var imageData: Data?
        
        let group = DispatchGroup()
        group.enter()
        graphClient.getJSON(path: "me") { response, _ in
            userJSON = response
            group.leave()
        }
        
        group.enter()
        graphClient.getData(path: "me/photo/$value") { data, _ in
            imageData = data
            group.leave()
        }
        
        group.notify(queue: DispatchQueue.main) { [unowned self] in
            let user = self.makeUser(from: userJSON, imageData: imageData, token: token)
            handler(.success(user))
        }
    }
    
    private func makeUser(from userJSON: [String: Any]?, imageData: Data?, token: String) -> User {
        return User(firstName: userJSON?["givenName"] as? String,
                    lastName: userJSON?["surname"] as? String,
                    email: userJSON?["mail"] as? String,
                    token: token,
                    photo: cachedPhoto(imageData: imageData),
                    provider: .microsoft)
    }
    
    private func cachedPhoto(imageData: Data?) -> Photo {
        let photo = Photo()
        
        if let data = imageData, let image = UIImage(data: data) {
            imageCache.store(image: image, for: photo)
        }
        
        return photo
    }
}
