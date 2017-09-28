//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest
import Nimble
@testable import EmbeddedSocial

class MyBlockedUsersResponseProcessorTests: UsersListResponseProcessorTests {
    private var sut: MyBlockedUsersResponseProcessor!
    
    override func setUp() {
        super.setUp()
        sut = MyBlockedUsersResponseProcessor(cache: cache)
    }
    
    override func tearDown() {
        super.tearDown()
        sut = nil
    }
    
    func testThatItAddsBlockedUsersToTheList() {
        // given
        let usersToAdd = [User(), User(), User()]
        let commands = usersToAdd.map(BlockCommand.init)
        
        let initialUsers = [User(), User()]
        let response = UsersListResponse(users: initialUsers, cursor: nil, isFromCache: true)
        
        cache.fetchOutgoing_with_ReturnValue = commands
        
        // when
        let processedResponse = sut.apply(commands: commands, to: response)
        
        // then
        let userIDs = processedResponse.users.map { $0.uid }
        let userIDsToAdd = usersToAdd.map { $0.uid }
        expect(userIDs).to(contain(userIDsToAdd))
        expect(processedResponse.users).to(haveCount(usersToAdd.count + initialUsers.count))
    }
    
    func testThatItDoesNotAddDuplicatedUsers() {
        // given
        let commonUser = User()
        let usersToAdd = [commonUser, User(), User()]
        let commands = usersToAdd.map(BlockCommand.init)
        
        let initialUsers = [commonUser, User()]
        let response = UsersListResponse(users: initialUsers, cursor: nil, isFromCache: true)
        
        cache.fetchOutgoing_with_ReturnValue = commands
        
        // when
        let processedResponse = sut.apply(commands: commands, to: response)
        
        // then
        let userIDs = processedResponse.users.map { $0.uid }
        let userIDsToAdd = usersToAdd.map { $0.uid }
        expect(userIDs).to(contain(userIDsToAdd))
        expect(processedResponse.users).to(haveCount(usersToAdd.count + initialUsers.count - 1))
    }
}
