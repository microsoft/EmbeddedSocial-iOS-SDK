//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import UIKit

enum FeedModuleLayoutType: Int {
    case list
    case grid
    
    var cellType:String {
        
        switch self {
        case .list:
            return PostCell.reuseID
        case .grid:
            return PostCellCompact.reuseID
        }
    }
}

// TODO: remove images from cell height calculation
//
//

class FeedModuleViewController: UIViewController, FeedModuleViewInput {
    
    var output: FeedModuleViewOutput!
    var listLayout = UICollectionViewFlowLayout()
    var gridLayout = UICollectionViewFlowLayout()
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    lazy var refreshControl: UIRefreshControl = {
        let control = UIRefreshControl()
        control.addTarget(
            self,
            action: #selector(onPullRefresh),
            for: .valueChanged)
        return control
    }()
    
    lazy var layoutChangeButton: UIBarButtonItem = { [unowned self] in
        let button = UIBarButtonItem(
            image: nil,
            style: .plain,
            target: self,
            action: #selector(self.didTapChangeLayout))
        return button
        }()
    
    lazy var sizingCell: PostCell = { [unowned self] in
        let cell = PostCell.nib.instantiate(withOwner: nil, options: nil).last as! PostCell
        let width = self.collectionView.bounds.width
        let height = cell.frame.height
        cell.frame = CGRect(x: 0, y: 0, width: width, height: height)
        return cell
        }()
    
    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        output.viewIsReady()
        
        self.collectionView.register(PostCell.nib, forCellWithReuseIdentifier: PostCell.reuseID)
        self.collectionView.register(PostCellCompact.nib, forCellWithReuseIdentifier: PostCellCompact.reuseID)
        
        // TODO: remove parent, waiting for menu proxy controller refactor
        parent?.navigationItem.rightBarButtonItem = layoutChangeButton
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        onUpdateBounds()
    }
    
    // MARK: UX
    
    func onPullRefresh() {
        output.didPullRefresh()
    }
    
    func onUpdateLayout(type: FeedModuleLayoutType, animated: Bool = false) {
        
        // switch layout
        switch type {
        case .grid:
            layoutChangeButton.image = UIImage(asset: .iconGallery)
            if collectionView!.collectionViewLayout != gridLayout {
                collectionView!.setCollectionViewLayout(gridLayout, animated: animated)
            }
        case .list:
            layoutChangeButton.image = UIImage(asset: .iconList)
            if collectionView!.collectionViewLayout != listLayout {
                collectionView?.setCollectionViewLayout(listLayout, animated: animated)
            }
        }
    }
    
    func onUpdateBounds() {
        if let collectionView = self.collectionView {
            updateLayoutFlowForList(layout: listLayout, containerWidth: collectionView.frame.size.width)
            updateLayoutFlowForGrid(layout: gridLayout, containerWidth: collectionView.frame.size.width)
        }
    }
    
    func updateLayoutFlowForGrid(layout: UICollectionViewFlowLayout, containerWidth: CGFloat) {

        layout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 5
        let itemsPerRow = CGFloat(2)
        var paddings = layout.minimumInteritemSpacing * CGFloat((itemsPerRow - 1))
        paddings += layout.sectionInset.left + layout.sectionInset.right
        let itemWidth = (containerWidth - paddings) / itemsPerRow
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth)
    }
    
    func updateLayoutFlowForList(layout: UICollectionViewFlowLayout, containerWidth: CGFloat) {
        layout.minimumLineSpacing = 20
    }
    
    func didTapChangeLayout() {
        output.didTapChangeLayout()
    }
    
    // MARK: FeedModuleViewInput
    func setupInitialState() {
    
    }
    
    func setLayout(type: FeedModuleLayoutType) {
        self.collectionView.reloadData()
        onUpdateLayout(type: type)
    }
    
    func setRefreshing(state: Bool) {
        if state {
            if refreshControl.superview != collectionView {
                collectionView!.addSubview(refreshControl)
            }
            refreshControl.beginRefreshing()
        } else {
            refreshControl.endRefreshing()
        }
    }
    
    func reload() {
        collectionView?.reloadData()
    }
    
    func reload(with index: Int) {
        collectionView?.reloadItems(at: [IndexPath(item: index, section: 0)])
    }
}

extension FeedModuleViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return output.numberOfItems()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let item = output.item(for: indexPath)
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: item.cellType, for: indexPath) as? PostCellProtocol else {
            fatalError("Wrong cell")
        }
        
        cell.configure(with: item, collectionView: collectionView)
        
        return cell as! UICollectionViewCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionViewLayout === listLayout {
            
            let item = output.item(for: indexPath)
            
            sizingCell.configure(with: item, collectionView: collectionView)
            
            // TODO: remake via manual calculation
            sizingCell.needsUpdateConstraints()
            sizingCell.updateConstraints()
            sizingCell.setNeedsLayout()
            sizingCell.layoutIfNeeded()
            
            return sizingCell.container.bounds.size
            
        } else if collectionViewLayout === gridLayout {
            return gridLayout.itemSize
        } else {
            fatalError("Unexpected")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        output.didTapItem(path: indexPath)
    }
}
