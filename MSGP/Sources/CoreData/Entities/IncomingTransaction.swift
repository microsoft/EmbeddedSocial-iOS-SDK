//
//  IncomingTransaction.swift
//  MSGP
//
//  Created by Vadim Bulavin on 7/21/17.
//  Copyright © 2017 Akvelon. All rights reserved.
//

import CoreData

final class IncomingTransaction: NSManagedObject {
    @NSManaged var typeid: String?
    @NSManaged var createdAt: Date?
    @NSManaged var handle: String?
    @NSManaged var payload: [String: Any]?
    
    override func awakeFromInsert() {
        createdAt = Date()
    }
}

extension IncomingTransaction: CoreDataRecord {
    static var entityName: String {
        return "IncomingTransaction"
    }
    
    @nonobjc class func fetchRequest() -> NSFetchRequest<IncomingTransaction> {
        return NSFetchRequest(entityName: "IncomingTransaction")
    }
}
