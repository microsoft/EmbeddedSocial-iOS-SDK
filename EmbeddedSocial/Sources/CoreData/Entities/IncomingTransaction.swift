//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import CoreData

final class IncomingTransaction: NSManagedObject, Transaction {
    @NSManaged var typeid: String?
    @NSManaged var createdAt: Date?
    @NSManaged var handle: String?
    @NSManaged var payload: Any?

    override func awakeFromInsert() {
        createdAt = Date()
    }
}

extension IncomingTransaction: CoreDataRecord {
    @nonobjc class func fetchRequest() -> NSFetchRequest<IncomingTransaction> {
        return NSFetchRequest(entityName: entityName)
    }
}
