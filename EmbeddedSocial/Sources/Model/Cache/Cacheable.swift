//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

protocol Cacheable {
    func encodeToJSON() -> Any
    
    func getHandle() -> String?
    
    func setHandle(_ handle: String?)
    
    func getRelatedHandle() -> String?
    
    func setRelatedHandle(_ relatedHandle: String?)
}

extension Cacheable {

    func getHandle() -> String? {
        return nil
    }
    
    func setHandle(_ handle: String?) {
        
    }
    
    func getRelatedHandle() -> String? {
        return nil
    }
    
    func setRelatedHandle(_ relatedHandle: String?) {
        
    }
    
    var typeIdentifier: String {
        return type(of: self).typeIdentifier
    }
    
    static var typeIdentifier: String {
        return String(describing: self)
    }
}
