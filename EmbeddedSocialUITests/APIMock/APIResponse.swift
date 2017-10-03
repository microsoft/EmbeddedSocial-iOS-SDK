//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation
import EnvoyAmbassador
import Embassy

public struct APIResponse: WebApp {
    let dataResponse: WebApp
    
    public init(
        serviceName: String = "generic",
        statusCode: Int = 200,
        statusMessage: String = "OK",
        contentType: String = "application/json",
        jsonWritingOptions: JSONSerialization.WritingOptions = .prettyPrinted,
        headers: [(String, String)] = [],
        handler: @escaping (_ environ: [String: Any], _ sendJSON: @escaping (Any) -> Void) -> Void
        ) {
        let response = DataResponse(
            statusCode: statusCode,
            statusMessage: statusMessage,
            contentType: contentType,
            headers: headers
        ) { environ, sendData in
            handler(environ) { json in
                let data = try! JSONSerialization.data(withJSONObject: json, options: jsonWritingOptions)
                APIState.setLatestResponseAsString(forService: serviceName, data: String(data: data, encoding: .utf8) as String!)
                sendData(data)
            }
        }
        
        if APIConfig.delayedResponses {
            dataResponse = DelayResponse(response)
        } else {
            dataResponse = response
        }
       
    }
    
    public init(
        serviceName: String = "generic",
        statusCode: Int = 200,
        statusMessage: String = "OK",
        contentType: String = "application/json",
        jsonWritingOptions: JSONSerialization.WritingOptions = .prettyPrinted,
        headers: [(String, String)] = [],
        handler: ((_ environ: [String: Any]) -> Any)? = nil
        ) {
        let response = DataResponse(
            statusCode: statusCode,
            statusMessage: statusMessage,
            contentType: contentType,
            headers: headers
        ) { environ, sendData in
            let data: Data
            if let handler = handler {
                let json = handler(environ)
                data = try! JSONSerialization.data(withJSONObject: json, options: jsonWritingOptions)
            } else {
                data = Data()
            }
            APIState.setLatestResponseAsString(forService: serviceName, data: String(data: data, encoding: .utf8) as String!)
            sendData(data)
        }
        
        if APIConfig.delayedResponses {
            dataResponse = DelayResponse(response)
        } else {
            dataResponse = response
        }
    }
    
    public func app(
        _ environ: [String: Any],
        startResponse: @escaping ((String, [(String, String)]) -> Void),
        sendBody: @escaping ((Data) -> Void)
        ) {
        return dataResponse.app(environ, startResponse: startResponse, sendBody: sendBody)
    }
}
