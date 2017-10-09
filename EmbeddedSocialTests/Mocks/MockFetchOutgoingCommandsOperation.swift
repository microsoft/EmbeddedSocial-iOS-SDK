//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

@testable import EmbeddedSocial

class MockFetchOutgoingCommandsOperation: FetchOutgoingCommandsOperation {
    
    let inputValues: (cache: CacheType, predicate: NSPredicate)
    
    private(set) var _commands: [OutgoingCommand] = []
    
    func setCommands(_ commands: [OutgoingCommand]) {
        _commands = commands
    }
    
    override var commands: [OutgoingCommand] {
        return _commands
    }
    
    override init(cache: CacheType, predicate: NSPredicate) {
        inputValues = (cache, predicate)
        super.init(cache: cache, predicate: predicate)
    }
    
    private(set) var mainCalled = false
    
    override func main() {
        super.main()
        mainCalled = true
    }
}
