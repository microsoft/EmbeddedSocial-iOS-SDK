//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

class BundleHelper {
    
    func getCurrentBundle() -> Bundle {
        return Bundle(for: type(of: self))
    }
    
}

class Templates {
    
    open static var bundle = BundleHelper().getCurrentBundle()
    
    class func load(name: String, replacements: [String: Any] = [:], preReplacements: [String: Any] = [:]) -> [String: Any] {
        let path = Templates.bundle.path(forResource: name, ofType: "json")!

        var content = try! NSString(contentsOfFile: path, encoding: String.Encoding.utf8.rawValue) as String
        
        for (key, replacement) in preReplacements {
            content.replace(target: String(format: "{%%%@%%}", key), withString: String(format: "{%%%@%%}", replacement as! String))
        }
        
        var mergedReplacements = APIConfig.defaultReplacements
        mergedReplacements.update(other: replacements as! Dictionary)
        
        
        for (key, replacement) in mergedReplacements {
            content.replace(target: String(format: "{%%%@%%}", key), withString: replacement)
        }
        
        let json = try! JSONSerialization.jsonObject(with: content.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))!, options: [])
        
        return json as! [String: Any]
    }
    
}
