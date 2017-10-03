//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest
import Nimble
@testable import EmbeddedSocial

class MyFollowingResponseProcessorTests: UsersListResponseProcessorTests {
    
    private var sut: MyFollowingResponseProcessor!
    
    override func setUp() {
        super.setUp()
        sut = MyFollowingResponseProcessor(cache: cache)
    }
    
    override func tearDown() {
        super.tearDown()
        sut = nil
    }
    
    func testThatItAddsFollowedUsers() {
        // given
        let commands: [FollowCommand] = [
            FollowCommand(user: User()),
            FollowCommand(user: User()),
            FollowCommand(user: User())
        ]
        
        let users = [User(), User()]
        let usersToAdd = commands.map { $0.user }
        
        let response = UsersListResponse(users: users, cursor: nil, isFromCache: true)

        cache.fetchOutgoing_with_ReturnValue = commands

        // when
        let processedResponse = sut.apply(commands: commands, to: response)
        
        // then
        let userIDs = processedResponse.users.map { $0.uid }
        let userIDsToAdd = usersToAdd.map { $0.uid }
        expect(userIDs).to(contain(userIDsToAdd))
        expect(processedResponse.users).to(haveCount(users.count + commands.count))
    }
    
    func testThatItDeletesUnfollowedUsers() {
        // given
        let users = [User(), User(), User()]
        let commands = users.map(UnfollowCommand.init)
        let usersToDelete = Array(users.prefix(2))
        
        let response = UsersListResponse(users: users, cursor: nil, isFromCache: true)
        
        cache.fetchOutgoing_with_ReturnValue = commands
        
        // when
        let processedResponse = sut.apply(commands: commands, to: response)
        
        // then
        let userIDs = processedResponse.users.map { $0.uid }
        let userIDsToDelete = usersToDelete.map { $0.uid }
        expect(userIDs).notTo(contain(userIDsToDelete))
        expect(processedResponse.users).to(haveCount(users.count - commands.count))
    }
}
