//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import CoreData

final class OutgoingTransaction: NSManagedObject, Transaction {
    @NSManaged var typeid: String?
    @NSManaged var createdAt: Date?
    @NSManaged var handle: String?
    @NSManaged var payload: Any?
    @NSManaged var relatedHandle: String?
    
    override func awakeFromInsert() {
        createdAt = Date()
    }
}

extension OutgoingTransaction: CoreDataRecord {
    @nonobjc class func fetchRequest() -> NSFetchRequest<OutgoingTransaction> {
        return NSFetchRequest(entityName: entityName)
    }
}
