//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation
import CoreData

func saveContext(_ context: NSManagedObjectContext, wait: Bool = true, completion: ((Result<Void>) -> Void)? = nil) {
    let block = {
        guard context.hasChanges else {
            return
        }
        do {
            try context.save()
            completion?(.success())
        } catch {
            completion?(.failure(error))
        }
    }
    wait ? context.performAndWait(block) : context.perform(block)
}
