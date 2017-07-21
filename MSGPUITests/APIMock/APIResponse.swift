//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation
import EnvoyAmbassador

func APIResponse(
    statusCode: Int = 200,
    statusMessage: String = "OK",
    contentType: String = "application/json",
    jsonWritingOptions: JSONSerialization.WritingOptions = .prettyPrinted,
    headers: [(String, String)] = [],
    handler: @escaping (_ environ: [String: Any], _ sendJSON: @escaping (Any) -> Void) -> Void) -> Any
{
    let response = JSONResponse(
        statusCode: statusCode,
        statusMessage: statusMessage,
        contentType: contentType,
        jsonWritingOptions: jsonWritingOptions,
        headers: headers,
        handler: handler)
    
    if APIConfig.delayedResponses {
        return DelayResponse(response)
    } else {
        return response
    }
}

func APIResponse(
    statusCode: Int = 200,
    statusMessage: String = "OK",
    contentType: String = "application/json",
    jsonWritingOptions: JSONSerialization.WritingOptions = .prettyPrinted,
    headers: [(String, String)] = [],
    handler: ((_ environ: [String: Any]) -> Any)? = nil) -> WebApp
{
    let response = JSONResponse(
        statusCode: statusCode,
        statusMessage: statusMessage,
        contentType: contentType,
        jsonWritingOptions: jsonWritingOptions,
        headers: headers,
        handler: handler)
    
    if APIConfig.delayedResponses {
        return DelayResponse(response)
    } else {
        return response
    }
}
