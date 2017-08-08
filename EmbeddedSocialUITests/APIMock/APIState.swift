//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation


class APIState {
    static var requestHistory: [String] = []
    
    class func getLatestResponse(forService: String) -> Dictionary<String, Any>? {
        let data = UserDefaults.standard.string(forKey: "response" + forService)?.data(using: .utf8)
        return try! JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any]
    }
    
    class func getLatestData(forService: String) -> Dictionary<String, Any>? {
        let data = UserDefaults.standard.string(forKey: "data" + forService)?.data(using: .utf8)
        return try! JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any]
    }
    
    class func setLatestResponseAsString(forService: String, data: String) {
        UserDefaults.standard.set(data, forKey: "response" + forService)
    }
    
    class func setLatestResponse(forService: String, data: Any) {
        let jsonData = try! JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
        self.setLatestResponseAsString(forService: forService, data: String(data: jsonData, encoding: .utf8) as String!)
    }
    
    class func setLatestDataAsString(forService: String, data: String) {
        UserDefaults.standard.set(data, forKey: "data" + forService)
    }
    
    class func setLatestData(forService: String, data: Any) {
        let jsonData = try! JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
        self.setLatestDataAsString(forService: forService, data: String(data: jsonData, encoding: .utf8) as String!)
    }
    
    class func addRequest(_ path: String) {
        requestHistory.append(path)
    }
    
    class func getLatestRequest() -> String{
        return requestHistory[requestHistory.count - 1]
    }
}
