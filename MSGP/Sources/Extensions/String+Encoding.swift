//
//  String+Encoding.swift
//  MSGP
//
//  Created by Vadim Bulavin on 7/18/17.
//  Copyright © 2017 Akvelon. All rights reserved.
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
