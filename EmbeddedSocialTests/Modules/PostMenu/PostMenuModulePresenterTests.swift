//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest
@testable import EmbeddedSocial

private class PostMenuModuleOutputMock: PostMenuModuleOutput {
    
    var blockedUser: UserHandle?
    var unblockedUser: UserHandle?
    var followedUser: UserHandle?
    var unfollowedUser: UserHandle?
    var hiddenPost: PostHandle?
    var editedPost: PostHandle?
    var removedPost: PostHandle?
    var reportedPost: PostHandle?
    var removedComment: Comment?
    var reportedComment: Comment?
    var removedReply: Reply?
    var reportedReply: Reply?
    var requestFailed: Error?
    
    func didBlock(user: UserHandle) {
        blockedUser = user
    }
    
    func didUnblock(user: UserHandle) {
        unblockedUser = user
    }
    
    func didFollow(user: UserHandle) {
        followedUser = user
    }
    
    func didUnfollow(user: UserHandle) {
        unfollowedUser = user
    }
    
    func didHide(post: PostHandle) {
        hiddenPost = post
    }
    
    func didEdit(post: PostHandle) {
        editedPost = post
    }
    
    func didRemove(post: PostHandle) {
        removedPost = post
    }
    
    func didReport(post: PostHandle) {
        reportedPost = post
    }
    
    func didRemove(reply: Reply) {
        removedReply = reply
    }
    
    func didRemove(comment: Comment) {
        removedComment = comment
    }
    
    func didReport(reply: Reply) {
        reportedReply = reply
    }
    
    func didReport(comment: Comment) {
        reportedComment = comment
    }

    func didRequestFail(error: Error) {
        requestFailed = error
    }
}

private class PostMenuModuleViewMock: PostMenuModuleViewInput {
    
    func setupInitialState() {
        
    }
    
    func showItems(items: [ActionViewModel]) {
        
    }
}

private class PostMenuModuleInteractorMock: PostMenuModuleInteractorInput {
    
    var blockUser: UserHandle?
    var unblockUser: UserHandle?
    var followUser: UserHandle?
    var unfollowUser: UserHandle?
    var hidePost: PostHandle?
    var editPost: PostHandle?
    var removePost: PostHandle?
    var reportPost: PostHandle?
    var removeComment: Comment?
    var reportComment: Comment?
    var removeReply: Reply?
    var reportReply: Reply?
    
    func block(user: UserHandle) {
        blockUser = user
    }
    
    func unblock(user: UserHandle) {
        unblockUser = user
    }
    
    func follow(user: UserHandle) {
        followUser = user
    }
    
    func unfollow(user: UserHandle) {
        unfollowUser = user
    }
    
    func hide(post: PostHandle) {
        hidePost = post
    }
    
    func edit(post: PostHandle) {
        editPost = post
    }
    
    func remove(post: PostHandle) {
        removePost = post
    }
    
    func report(post: PostHandle) {
        reportPost = post
    }
    
    func remove(reply: Reply) {
        removeReply = reply
    }
    
    func remove(comment: Comment) {
        removeComment = comment
    }
}

class PostMenuModulePresenterTests: XCTestCase {
    
    var sut: PostMenuModulePresenter!
    private var moduleOutput: PostMenuModuleOutputMock!
    private var interactor: PostMenuModuleInteractorMock!
    
    override func setUp() {
        super.setUp()
        
        sut = PostMenuModulePresenter()
        
        moduleOutput = PostMenuModuleOutputMock()
        interactor = PostMenuModuleInteractorMock()
        
        sut.output = moduleOutput
        sut.interactor = interactor
    }
    
    func testThatTapHideWorksProperly() {
        
        // given
        let handle = randomHandle
        
        // when
        sut.didTapHide(post: handle)
        
        // then
        XCTAssertTrue(interactor.hidePost == handle)
        XCTAssertTrue(moduleOutput.hiddenPost == handle)
    }
    
    func testThatTapBlockWorksProperly() {
        
        // given
        let handle = randomHandle
        
        // when
        sut.didTapBlock(user: handle)
        
        // then
        XCTAssertTrue(interactor.blockUser == handle)
        XCTAssertTrue(moduleOutput.blockedUser == handle)
    }
    
    func testThatTapUnblockWorksProperly() {
        
        // given
        let handle = randomHandle
        
        // when
        sut.didTapUnblock(user: handle)
        
        // then
        XCTAssertTrue(interactor.unblockUser == handle)
        XCTAssertTrue(moduleOutput.unblockedUser == handle)
    }
    
    func testThatTapFollowWorksProperly() {
        
        // given
        let handle = randomHandle
        
        // when
        sut.didTapFollow(user: handle)
        
        // then
        XCTAssertTrue(interactor.followUser == handle)
        XCTAssertTrue(moduleOutput.followedUser == handle)
    }
    
    func testThatTapUnfollowWorksProperly() {
        
        // given
        let handle = randomHandle
        
        // when
        sut.didTapUnfollow(user: handle)
        
        // then
        XCTAssertTrue(interactor.unfollowUser == handle)
        XCTAssertTrue(moduleOutput.unfollowedUser == handle)
    }
    
    func testThatTapEditWorksProperly() {
        
        // given
        let handle = randomHandle
        
        // when
        
        sut.didTapEditPost(post: handle)
        
        // then
        XCTAssertTrue(interactor.editPost == handle)
        XCTAssertTrue(moduleOutput.editedPost == handle)
    }
    
    func testThatTapRemoveWorksProperly() {
        
        // given
        let handle = randomHandle
        
        // when
        sut.didTapRemovePost(post: handle)
        
        // then
        XCTAssertTrue(interactor.removePost == handle)
        XCTAssertTrue(moduleOutput.removedPost == handle)
    }
    
    func testThatRemoveReplyWorksProperl() {
        
        // given
        let handle = randomHandle
        let reply = Reply()
        reply.replyHandle = handle
        
        // when
        sut.didTapRemove(reply: reply)
        
        // then
        XCTAssertTrue(interactor.removeReply?.replyHandle == handle)
        XCTAssertTrue(moduleOutput.removedReply?.replyHandle == handle)
        
    }
    
    func testThatRemoveCommentWorksProperl() {
        
        // given
        let handle = randomHandle
        let comment = Comment()
        comment.commentHandle = handle
        
        // when
        sut.didTapRemove(comment: comment)
        
        // then
        XCTAssertTrue(interactor.removeComment?.commentHandle == handle)
        XCTAssertTrue(moduleOutput.removedComment?.commentHandle == handle)
        
    }
    
    private var randomHandle: String {
        return UUID().uuidString
    }
}

