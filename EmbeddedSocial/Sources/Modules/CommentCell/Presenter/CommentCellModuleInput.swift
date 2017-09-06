//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

protocol CommentCellModuleInput: class {
    var comment: Comment! {get set}
    func setNewView(view: CommentCell, for comment: Comment)
    var view: CommentCellViewInput? {get set}
}
