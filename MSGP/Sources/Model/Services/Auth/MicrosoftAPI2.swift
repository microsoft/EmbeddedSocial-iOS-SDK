//
//  MicrosoftAPI2.swift
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

final class MicrosoftAPI2: AuthAPI {
    private let scopes = [GraphScope.userRead.rawValue]//["https://graph.microsoft.com/User.Read"]
    
    private let application: MSALPublicClientApplication = {
        guard let app = try? MSALPublicClientApplication(clientId: clientID) else {
            let url = "https://github.com/AzureAD/microsoft-authentication-library-for-objc"
            fatalError("Microsoft ClientId is not set. Please follow instructions from \(url)")
        }
        return app
    }()
    
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
            
            let user = result.user
            let token = result.accessToken
        }
    }
}

extension MicrosoftAPI2 {
    enum APIError: LocalizedError {
        case unkown
        case responseError(String)
        
        public var unkown: String? {
            switch self {
            case .unkown: return "Unknown error occurred."
            case let .responseError(path): return "Response \(path) returned with error."
            }
        }
    }
}

class GraphRequest {
    private let token: String
    
    class func graphURL(with path: String) -> URL? {
        return URL(string: "https://graph.microsoft.com/beta/\(path)")
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
        let urlRequest = NSMutableURLRequest()
        urlRequest.url = GraphRequest.graphURL(with: path)
        urlRequest.httpMethod = "GET"
        urlRequest.allHTTPHeaderFields = ["Authorization": "Bearer \(token)"]
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: urlRequest as URLRequest) { data, response, error in
            guard error == nil else {
                completion(nil, error!)
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completion(nil, MicrosoftAPI2.APIError.responseError(path))
                return
            }
            
            completion(data, nil)
        }
        task.resume()
    }
}
