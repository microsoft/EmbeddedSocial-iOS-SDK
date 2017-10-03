//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest
import Nimble
@testable import EmbeddedSocial

class PendingRequestsResponseProcessorTests: UsersListResponseProcessorTests {
    private var sut: PendingRequestsResponseProcessor!
    
    override func setUp() {
        super.setUp()
        sut = PendingRequestsResponseProcessor(cache: cache)
    }
    
    override func tearDown() {
        super.tearDown()
        sut = nil
    }
    
    func testThatItExcludesAcceptedAndCancelledRequestsFromList() {
        // given
        let commands = [
            AcceptPendingCommand(user: User()),
            AcceptPendingCommand(user: User()),
            CancelPendingCommand(user: User()),
            CancelPendingCommand(user: User()),
        ]
        
        let usersToDelete = commands.map { $0.user }
        let usersToRemain = [User(), User(), User()]
        
        cache.fetchOutgoing_with_ReturnValue = commands
        
        let response = UsersListResponse(users: usersToRemain + usersToDelete, cursor: nil, isFromCache: true)
        
        // when
        let processedResponse = sut.apply(commands: commands, to: response)
        
        // then
        let userIDs = processedResponse.users.map { $0.uid }
        let userIDsToDelete = usersToDelete.map { $0.uid }
        let userIDsToRemain = usersToRemain.map { $0.uid }
        
        expect(userIDs).notTo(contain(userIDsToDelete))
        expect(userIDs).to(contain(userIDsToRemain))
        
        expect(processedResponse.users).to(haveCount(usersToRemain.count))
    }
}
