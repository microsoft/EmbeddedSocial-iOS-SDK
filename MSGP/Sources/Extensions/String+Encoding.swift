//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

extension String {

    func addingPercentEncodingForRFC3986() -> String? {
        let unreserved = "-._~/?"
        var allowedChars = CharacterSet.alphanumerics
        allowedChars.insert(charactersIn: unreserved)
        return addingPercentEncoding(withAllowedCharacters: allowedChars)
    }
    
    /**
     Returns a new string made from the receiver by replacing characters which are
     reserved in HTML forms (media type application/x-www-form-urlencoded) with
     percent encoded characters.
     */
    func addingPercentEncodingForFormData(plusForSpace: Bool = false) -> String? {
        let unreserved = "*-._"
        
        var allowedChars = CharacterSet.alphanumerics
        allowedChars.insert(charactersIn: unreserved)
        
        if plusForSpace {
            allowedChars.insert(" ")
        }
        
        var encoded = addingPercentEncoding(withAllowedCharacters: allowedChars)
        
        if plusForSpace {
            encoded = encoded?.replacingOccurrences(of: " ", with: "+")
        }
        
        return encoded
    }
}
