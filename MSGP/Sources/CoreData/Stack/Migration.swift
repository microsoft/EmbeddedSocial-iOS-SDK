//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation
import CoreData

enum MigrationError: Error {
    case sourceModelNotFound(model: CoreDataModel)
    case mappingModelNotFound(destinationModel: NSManagedObjectModel)
}

extension CoreDataModel {
    
    var needsMigration: Bool {
        get {
            guard let storeURL = storeURL else {
                return false
            }
            
            do {
                let metadata = try NSPersistentStoreCoordinator.metadataForPersistentStore(ofType: storeType.type,
                                                                                           at: storeURL,
                                                                                           options: nil)
                return !managedObjectModel.isConfiguration(withName: nil, compatibleWithStoreMetadata: metadata)
            } catch {
                debugPrint("*** Error checking persistent store coordinator meta data: \(error)")
                return false
            }
        }
    }
    
    /**
     Progressively migrates the persistent store of the `CoreDataModel` based on mapping models found in the model's bundle.
     If the model returns false from `needsMigration`, then this function does nothing.
     
     - throws: If an error occurs, either an `NSError` or a `MigrationError` is thrown. If an `NSError` is thrown, it could
     specify any of the following: an error checking persistent store metadata, an error from `NSMigrationManager`, or
     an error from `NSFileManager`.
     */
    func migrate() throws {
        guard needsMigration else {
            return
        }
        
        guard let storeURL = self.storeURL, let storeDirectory = storeType.storeDirectory() else {
            preconditionFailure("*** Error: migration is only available for on-disk persistent stores. Invalid model: \(self)")
        }
        
        // could also throw NSError from NSPersistentStoreCoordinator
        guard let sourceModel = try MigrationHelper
            .findCompatibleModel(withBundle: bundle, storeType: storeType.type, storeURL: storeURL) else {
                throw MigrationError.sourceModelNotFound(model: self)
        }
        
        let migrationSteps = try MigrationHelper
            .buildMigrationMappingSteps(bundle: bundle, sourceModel: sourceModel, destinationModel: managedObjectModel)
        
        for step in migrationSteps {
            let tempURL = storeDirectory.appendingPathComponent("migration." + ModelFileExtension.sqlite.rawValue)
            
            // could throw error from `migrateStoreFromURL`
            let manager = NSMigrationManager(sourceModel: step.source, destinationModel: step.destination)
            try manager.migrateStore(from: storeURL,
                                     sourceType: storeType.type,
                                     options: nil,
                                     with: step.mapping,
                                     toDestinationURL: tempURL,
                                     destinationType: storeType.type,
                                     destinationOptions: nil)
            
            // could throw file system errors
            try removeExistingStore()
            try FileManager.default.moveItem(at: tempURL, to: storeURL)
        }
    }
}

struct MigrationMappingStep {
    let source: NSManagedObjectModel
    let mapping: NSMappingModel
    let destination: NSManagedObjectModel
}

struct MigrationHelper {
    
    static func findCompatibleModel(withBundle bundle: Bundle,
                                    storeType: String,
                                    storeURL: URL) throws -> NSManagedObjectModel? {
        let storeMetadata = try NSPersistentStoreCoordinator.metadataForPersistentStore(ofType: storeType,
                                                                                        at: storeURL,
                                                                                        options: nil)
        let modelsInBundle = findModelsInBundle(bundle)
        for model in modelsInBundle where model.isConfiguration(withName: nil, compatibleWithStoreMetadata: storeMetadata) {
            return model
        }
        return nil
    }
    
    static func findModelsInBundle(_ bundle: Bundle) -> [NSManagedObjectModel] {
        guard let modelBundleDirectoryURLs = bundle.urls(forResourcesWithExtension: ModelFileExtension.bundle.rawValue,
                                                         subdirectory: nil) else {
                                                            return []
        }
        
        let modelBundleDirectoryNames = modelBundleDirectoryURLs.flatMap { url -> String? in
            url.lastPathComponent
        }
        
        let modelVersionFileURLs = modelBundleDirectoryNames.flatMap { name -> [URL]? in
            bundle.urls(forResourcesWithExtension: ModelFileExtension.versionedFile.rawValue, subdirectory: name)
        }
        
        let managedObjectModels = Array(modelVersionFileURLs.joined()).flatMap { url -> NSManagedObjectModel? in
            NSManagedObjectModel(contentsOf: url)
        }
        
        return managedObjectModels
    }
    
    static func buildMigrationMappingSteps(bundle: Bundle,
                                           sourceModel: NSManagedObjectModel,
                                           destinationModel: NSManagedObjectModel) throws -> [MigrationMappingStep] {
        var migrationSteps = [MigrationMappingStep]()
        var nextModel = sourceModel
        repeat {
            guard let nextStep = nextMigrationMappingStep(fromSourceModel: nextModel, bundle: bundle) else {
                throw MigrationError.mappingModelNotFound(destinationModel: nextModel)
            }
            migrationSteps.append(nextStep)
            nextModel = nextStep.destination
            
        } while nextModel.entityVersionHashesByName != destinationModel.entityVersionHashesByName
        
        return migrationSteps
    }
    
    static func nextMigrationMappingStep(fromSourceModel sourceModel: NSManagedObjectModel,
                                         bundle: Bundle) -> MigrationMappingStep? {
        let modelsInBundle = findModelsInBundle(bundle)
        
        for nextDestinationModel in modelsInBundle
            where nextDestinationModel.entityVersionHashesByName != sourceModel.entityVersionHashesByName {
                if let mappingModel = NSMappingModel(from: [bundle],
                                                     forSourceModel: sourceModel,
                                                     destinationModel: nextDestinationModel) {
                    return MigrationMappingStep(source: sourceModel, mapping: mappingModel, destination: nextDestinationModel)
                }
        }
        return nil
    }
}
