//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

open class EmbeddedSocialClientAPI {
    private static var _basePath = "https://api.embeddedsocial.microsoft.com"
    open static var basePath: String {
        set {
            _basePath = newValue
        }
        get {
            if let path = getEnvironmentVariable("MSGP_MOCK_SERVER") {
                return path
            } else {
                return _basePath
            }
        }
    }
    open static var credential: URLCredential?
    open static var customHeaders: [String:String] = [:]
    static var requestBuilderFactory: RequestBuilderFactory = AlamofireRequestBuilderFactory()
}

open class APIBase {
    func toParameters(_ encodable: JSONEncodable?) -> [String: Any]? {
        let encoded: Any? = encodable?.encodeToJSON()

        if encoded! is [Any] {
            var dictionary = [String:Any]()
            for (index, item) in (encoded as! [Any]).enumerated() {
                dictionary["\(index)"] = item
            }
            return dictionary
        } else {
            return encoded as? [String:Any]
        }
    }
}

open class RequestBuilder<T> {
    var credential: URLCredential?
    var headers: [String:String] = [:]
    let parameters: [String:Any]?
    let isBody: Bool
    let method: String
    let URLString: String
    
    /// Optional block to obtain a reference to the request's progress instance when available.
    public var onProgressReady: ((Progress) -> ())?

    required public init(method: String, URLString: String, parameters: [String:Any]?, isBody: Bool) {
        self.method = method
        self.URLString = URLString
        self.parameters = parameters
        self.isBody = isBody
        
        addHeaders(EmbeddedSocialClientAPI.customHeaders)
    }
    
    open func addHeaders(_ aHeaders:[String:String]) {
        for (header, value) in aHeaders {
            headers[header] = value
        }
    }
    
    open func execute(_ completion: @escaping (_ response: Response<T>?, _ error: Error?) -> Void) { }

    public func addHeader(name: String, value: String) -> Self {
        if !value.isEmpty {
            headers[name] = value
        }
        return self
    }
    
    open func addCredential() -> Self {
        self.credential = EmbeddedSocialClientAPI.credential
        return self
    }
}

public protocol RequestBuilderFactory {
    func getBuilder<T>() -> RequestBuilder<T>.Type
}

