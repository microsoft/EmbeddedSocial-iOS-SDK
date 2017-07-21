//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import CoreData

protocol CoreDataRecord: NSFetchRequestResult {
    static var entityName: String { get }
    static func fetchRequest() -> NSFetchRequest<Self>
}
