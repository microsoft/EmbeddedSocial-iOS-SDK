//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

class CommentCommand: OutgoingCommand {
    private(set) var comment: Comment
    
    required init?(json: [String: Any]) {
        guard let commentJSON = json["comment"] as? [String: Any],
            let comment = Comment(json: commentJSON) else {
                return nil
        }
        
        self.comment = comment
        
        super.init(json: json)
    }
    
    init(comment: Comment) {
        self.comment = comment
        super.init(json: [:])!
    }
    
    func setImageHandle(_ imageHandle: String?) {
        comment.mediaHandle = imageHandle
    }
    
    func apply(to comment: inout Comment) {
        
    }
    
    func apply(to feed: inout CommentFetchResult) {
        var comments = feed.comments
    
        for (index, var comment) in comments.enumerated() {
            if comment.commentHandle == self.comment.commentHandle {
                apply(to: &comment)
                comments[index] = comment
            }
        }
        
        feed.comments = comments
    }
    
    override func encodeToJSON() -> Any {
        return [
            "comment": comment.encodeToJSON(),
            "type": typeIdentifier
        ]
    }
    
    override func getRelatedHandle() -> String? {
        return comment.commentHandle
    }
    
    override func setRelatedHandle(_ relatedHandle: String?) {
        comment.commentHandle = relatedHandle
    }
    
    override func getHandle() -> String? {
        return comment.commentHandle
    }
    
    override func setHandle(_ handle: String?) {
        if let handle = handle {
            comment.commentHandle = handle
        }
    }
    
    static var allCommentCommandTypes: [OutgoingCommand.Type] {
        return [
            LikeCommentCommand.self,
            UnlikeCommentCommand.self,
            CreateCommentCommand.self,
            RemoveCommentCommand.self,
            ReportCommentCommand.self
        ]
    }
    
    static var commentActionCommandTypes: [OutgoingCommand.Type] {
        return [
            LikeCommentCommand.self,
            UnlikeCommentCommand.self,
            ReportCommentCommand.self
        ]
    }
    
    var isActionCommand: Bool {
        return CommentCommand.commentActionCommandTypes.contains(where: { $0 == type(of: self) })
    }
}
