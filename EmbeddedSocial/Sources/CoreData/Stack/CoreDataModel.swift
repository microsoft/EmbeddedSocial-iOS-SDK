//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import CoreData

final class CoreDataModel {
    let name: String
    let bundle: Bundle
    let storeType: StoreType
    
    var storeURL: URL? {
        return storeType.storeDirectory()?.appendingPathComponent(databaseFileName)
    }
    
    var modelURL: URL {
        guard let url = bundle.url(forResource: name, withExtension: ModelFileExtension.bundle.rawValue) else {
            fatalError("*** Error loading model URL for model named \(name) in bundle: \(bundle)")
        }
        return url
    }
    
    var databaseFileName: String {
        switch storeType {
        case .sqlite: return name + "." + ModelFileExtension.sqlite.rawValue
        default: return name
        }
    }
    
    var managedObjectModel: NSManagedObjectModel {
        guard let model = NSManagedObjectModel(contentsOf: modelURL) else {
            fatalError("*** Error loading managed object model at url: \(modelURL)")
        }
        return model
    }
    
    init(name: String,
         bundle: Bundle = Bundle(for: CoreDataModel.self),
         storeType: StoreType = .sqlite(CoreDataModel.defaultDirectoryURL)) {
        
        self.name = name
        self.bundle = bundle
        self.storeType = storeType
    }
    
    func removeExistingStore() throws {
        let fm = FileManager.default
        if let storePath = storeURL?.path,
            fm.fileExists(atPath: storePath) {
            try fm.removeItem(atPath: storePath)
            
            let writeAheadLog = storePath + "-wal"
            _ = try? fm.removeItem(atPath: writeAheadLog)
            
            let sharedMemoryfile = storePath + "-shm"
            _ = try? fm.removeItem(atPath: sharedMemoryfile)
        }
    }
    
    static var defaultDirectoryURL: URL {
        do {
            let searchPathDirectory = FileManager.SearchPathDirectory.documentDirectory
            
            return try FileManager.default.url(for: searchPathDirectory,
                                               in: .userDomainMask,
                                               appropriateFor: nil,
                                               create: true)
        } catch {
            fatalError("*** Error finding default directory: \(error)")
        }
    }
}
