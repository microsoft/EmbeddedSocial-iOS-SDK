//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import CoreData
@testable import MSGP

final class Item: NSManagedObject {
    @NSManaged var name: String?
    
    class func makeItem(inContext context: NSManagedObjectContext) -> Item {
        let description = NSEntityDescription.entity(forEntityName: entityName, in: context)!
        let item = Item(entity: description, insertInto: context)
        item.name = "Item " + UUID().uuidString
        return item
    }
}

extension Item: CoreDataRecord {
    @nonobjc class func fetchRequest() -> NSFetchRequest<Item> {
        return NSFetchRequest(entityName: entityName)
    }
}
