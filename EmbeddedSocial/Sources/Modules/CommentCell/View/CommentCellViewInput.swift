//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

protocol CommentCellViewInput: class {
    func configure(comment: Comment)
    func setupInitialState()
    func setup(dataSource: CommentCellViewOutput)
}
