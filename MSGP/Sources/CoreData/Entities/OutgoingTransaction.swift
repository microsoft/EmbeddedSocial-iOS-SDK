//
//  OutgoingTransaction.swift
//  MSGP
//
//  Created by Vadim Bulavin on 7/21/17.
//  Copyright © 2017 Akvelon. All rights reserved.
//

import CoreData

final class OutgoingTransaction: NSManagedObject {
    @NSManaged var typeid: String?
    @NSManaged var createdAt: Date?
    @NSManaged var handle: String?
    @NSManaged var payload: [String: Any]?
    
    override func awakeFromInsert() {
        createdAt = Date()
    }
}

extension OutgoingTransaction: CoreDataRecord {
    static var entityName: String {
        return "OutgoingTransaction"
    }
    
    @nonobjc class func fetchRequest() -> NSFetchRequest<OutgoingTransaction> {
        return NSFetchRequest(entityName: "OutgoingTransaction")
    }
}
