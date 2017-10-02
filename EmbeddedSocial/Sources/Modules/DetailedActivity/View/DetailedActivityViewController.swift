//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import UIKit

protocol DetailedActivityViewInput: class {
    func setupInitialState()
    func reloadAllContent()
}

protocol DetailedActivityViewOutput {
    func viewIsReady()
    func numberOfItems() -> Int
    func contentState() -> DetailedActivityState
    func contentReply() -> Reply
    func contentComment() -> Comment
}

enum DetailedActivityItem: Int {
    case contentCell
    case buttonCell
}

class DetailedActivityViewController: UIViewController, DetailedActivityViewInput {
    @IBOutlet weak var collectionView: UICollectionView!

    var output: DetailedActivityViewOutput!
    fileprivate var prototypeCommentCell: CommentCell?
    fileprivate var prototypeReplyCell: ReplyCell?

    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        output.viewIsReady()
        configureCollectionView()
    }

    // MARK: DetailedActivityViewInput
    func setupInitialState() {
        
    }
    
    func configureCollectionView() {
        prototypeCommentCell = CommentCell.nib.instantiate(withOwner: nil, options: nil).first as? CommentCell
        prototypeReplyCell = ReplyCell.nib.instantiate(withOwner: nil, options: nil).first as? ReplyCell
        collectionView.register(ActivityButtonCell.nib, forCellWithReuseIdentifier: ActivityButtonCell.reuseID)
        collectionView.register(CommentCell.nib, forCellWithReuseIdentifier: CommentCell.reuseID)
        collectionView.register(ReplyCell.nib, forCellWithReuseIdentifier: ReplyCell.reuseID)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    func reloadAllContent() {
        collectionView.reloadData()
    }
}

extension DetailedActivityViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return  output.numberOfItems()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.row {
        case DetailedActivityItem.contentCell.rawValue:
            return UICollectionViewCell()
        case DetailedActivityItem.buttonCell.rawValue:
            return UICollectionViewCell()
        default:
            fatalError("Incorrect case for DetailedActivityItem")
        }
    }
}

extension DetailedActivityViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch indexPath.row {
        case DetailedActivityItem.contentCell.rawValue:
            switch output.contentState() {
            case .comment:
                prototypeCommentCell?.configure(comment: output.contentComment())
                return prototypeCommentCell!.cellSize()
            case .reply:
                prototypeReplyCell?.configure(reply: output.contentReply())
                return prototypeReplyCell!.cellSize()
            }
        case DetailedActivityItem.buttonCell.rawValue:
            return ActivityButtonCell.cellSize()
            
        default:
            fatalError("Incorrect case for DetailedActivityItem")
        }
    }
}
