//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation
import EnvoyAmbassador

extension URLParametersReader {

    public static func parseURLParameters(environ: [String: Any]) -> Dictionary<String, String> {
        var result: Dictionary<String, String> = [:]
        
        if let query = environ["QUERY_STRING"] as? String {
            let parameters = query.components(separatedBy: "&")
            for parameter in parameters {
                let parts = parameter.components(separatedBy: "=")
                result[parts[0]] = Array(parts[1..<parts.count]).joined(separator: "=")
            }
        }
        
        return result
    }
    
}
