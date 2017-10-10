//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import UIKit
import SVProgressHUD

protocol DetailedActivityViewInput: class {
    func setupInitialState()
    func reloadAllContent()
    func setErrorText(text: String)
}

protocol DetailedActivityViewOutput {
    func viewIsReady()
    func numberOfItems() -> Int
    func contentState() -> DetailedActivityState
    func contentReply() -> Reply
    func contentComment() -> Comment
    func loadContent()
    func openNextContent()
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

    @IBOutlet weak var errorLabel: UILabel!
    
    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        output.viewIsReady()
        configureCollectionView()
        showHUD()
        output.loadContent()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.reloadData()
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
        hideHUD()
    }
    
    func setErrorText(text: String) {
        errorLabel.isHidden = false
        errorLabel.text = text
        hideHUD()
    }
}

extension DetailedActivityViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return  output.numberOfItems()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.row {
        case DetailedActivityItem.contentCell.rawValue:
            switch output.contentState() {
            case .comment:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CommentCell.reuseID, for: indexPath) as! CommentCell
                let configurator = CommentCellModuleConfigurator()
                configurator.configure(cell: cell,
                                       comment: output.contentComment(),
                                       navigationController: self.navigationController,
                                       moduleOutput: self.output as! CommentCellModuleOutout)
                return cell
            case .reply:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReplyCell.reuseID, for: indexPath) as! ReplyCell
                let configurator = ReplyCellModuleConfigurator()
                configurator.configure(cell: cell,
                                       reply: output.contentReply(),
                                       navigationController: self.navigationController,
                                       moduleOutput: self.output as? ReplyCellModuleOutput)
                return cell
            }
        case DetailedActivityItem.buttonCell.rawValue:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ActivityButtonCell.reuseID, for: indexPath) as! ActivityButtonCell
            cell.openButton.setTitle(output.contentState() == .comment ? L10n.DetailedActivity.Button.openTopic : L10n.DetailedActivity.Button.openComment , for: .normal)
            cell.delegate = self
            return cell
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

extension DetailedActivityViewController: ActivityButtonCellDelegate {
    func openPressed() {
        output.openNextContent()
    }
}
