//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import UIKit
@testable import MSGP

class MockTransactionsDatabaseFacade: TransactionsDatabaseFacade {
    private(set) var saveIncomingCalled = 0
    private(set) var saveOutgoingCalled = 0
    
    override func save(transaction: IncomingTransaction) {
        super.save(transaction: transaction)
        saveIncomingCalled += 1
    }
    
    override func save(transaction: OutgoingTransaction) {
        super.save(transaction: transaction)
        saveOutgoingCalled += 1
    }
    
}
