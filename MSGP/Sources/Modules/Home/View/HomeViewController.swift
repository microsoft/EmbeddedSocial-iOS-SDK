//
//  HomeHomeViewController.swift
//  MSGP-Framework
//
//  Created by igor.popov on 24/07/2017.
//  Copyright © 2017 akvelon. All rights reserved.
//

import UIKit

enum HomeLayoutType: Int {
    case list
    case grid
}

// TODO: remove images from cell height calculation
//
//

class HomeViewController: UIViewController, HomeViewInput {
    
    var output: HomeViewOutput!
    var listLayout = UICollectionViewFlowLayout()
    var gridLayout = UICollectionViewFlowLayout()
    
    @IBOutlet weak var collectionView: UICollectionView?
    
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
    
    lazy var sizingCell: TopicCell = { [unowned self] in
        let cell = TopicCell.nib.instantiate(withOwner: nil, options: nil).last as! TopicCell
        let width = self.collectionView!.bounds.width
        let height = cell.frame.height
        cell.frame = CGRect(x: 0, y: 0, width: width, height: height)
        return cell
        }()
    
    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        output.viewIsReady()
        
        self.collectionView?.register(TopicCell.nib, forCellWithReuseIdentifier: TopicCell.reuseID)
        
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
    
    func onUpdateLayout(type: HomeLayoutType, animated: Bool = false) {
        
        // switch layout
        switch type {
        case .grid:
            layoutChangeButton.image = UIImage(asset: .iconList)
            if collectionView!.collectionViewLayout != gridLayout {
                collectionView!.setCollectionViewLayout(gridLayout, animated: animated)
            }
        case .list:
            layoutChangeButton.image = UIImage(asset: .iconGallery)
            if collectionView!.collectionViewLayout != listLayout {
                collectionView?.setCollectionViewLayout(listLayout, animated: animated)
            }
        }
    }
    
    func onUpdateBounds() {
        updateLayoutFlowForList(layout: listLayout, containerWidth: collectionView!.bounds.width)
        updateLayoutFlowForList(layout: gridLayout, containerWidth: collectionView!.bounds.width)
    }
    
    func updateLayoutFlowForList(layout: UICollectionViewFlowLayout, containerWidth: CGFloat) {
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 5
        layout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        let itemsPerRow = CGFloat(2)
        let contentWidth = containerWidth - (layout.sectionInset.left + layout.sectionInset.right)
        var itemWidth = contentWidth / itemsPerRow
        itemWidth -= layout.minimumInteritemSpacing
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth)
    }
    
    func updateLayoutFlowForGrid(layout: UICollectionViewFlowLayout, containerWidth: CGFloat) {
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 5
        layout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        
        let contentWidth = containerWidth - (layout.sectionInset.left + layout.sectionInset.right)
        var itemWidth = contentWidth
        itemWidth -= layout.minimumInteritemSpacing
        // item size is ignored here since we use autolayout for calculation
        layout.estimatedItemSize = CGSize(width: containerWidth, height: itemWidth)
    }
    
    func didTapChangeLayout() {
        output.didTapChangeLayout()
    }
    
    // MARK: HomeViewInput
    func setupInitialState() {
        
    }
    
    func setLayout(type: HomeLayoutType) {
        onUpdateLayout(type: type)
    }
    
    func setRefreshing(state: Bool) {
        if state {
            if refreshControl.superview != collectionView {
                collectionView!.addSubview(refreshControl)
            }
            refreshControl.beginRefreshing()
        } else {
            collectionView!.removeFromSuperview()
        }
    }
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return output.numberOfItems()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cellData = output.itemModel(for: indexPath)
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TopicCell.reuseID, for: indexPath) as? TopicCell else {
            fatalError("Wrong cell")
        }
        
        cell.configure(with: cellData)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionViewLayout == gridLayout {
            
            let cellData = output.itemModel(for: indexPath)
            sizingCell.configure(with: cellData)
            
            sizingCell.needsUpdateConstraints()
            sizingCell.updateConstraints()
            sizingCell.setNeedsLayout()
            sizingCell.layoutIfNeeded()
            
            return sizingCell.container.bounds.size
            
        } else if collectionViewLayout == listLayout {
            return listLayout.itemSize
        } else {
            fatalError("Unexpected")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.performBatchUpdates({
            
        }, completion: nil)
    }
    
    
}
