//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import UIKit

// TODO: remove images from cell height calculation
//
//

class FeedModuleViewController: UIViewController, FeedModuleViewInput {
    
    fileprivate struct Style {
        struct Collection  {
            static var rowsMargin = CGFloat(10.0)
            static var itemsPerRow = CGFloat(2)
            static var gridCellsPadding = CGFloat(5)
            static var footerHeight = CGFloat(60)
        }
    }
    
    var output: FeedModuleViewOutput!
    
    var numberOfItems: Int {
        return collectionView?.numberOfItems(inSection: 0) ?? 0
    }
    
    fileprivate var listLayout = UICollectionViewFlowLayout()
    fileprivate var gridLayout = UICollectionViewFlowLayout()
    fileprivate var headerReuseID: String?

    @IBOutlet weak var collectionView: UICollectionView!
    
    lazy var bottomRefreshControl: UIActivityIndicatorView = {
        let activity = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        activity.hidesWhenStopped = true
        
        return activity
    }()
    
    lazy var refreshControl: UIRefreshControl = {
        let control = UIRefreshControl()
        control.addTarget(
            self,
            action: #selector(onPullRefresh),
            for: .valueChanged)
        return control
    }()
    
    private lazy var layoutChangeButton: UIBarButtonItem = { [unowned self] in
        let button = UIBarButtonItem(
            image: nil,
            style: .plain,
            target: self,
            action: #selector(self.didTapChangeLayout))
        return button
        }()
    
    fileprivate lazy var sizingCell: PostCell = { [unowned self] in
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
        self.collectionView.backgroundColor = Palette.extraLightGrey
        self.collectionView.delegate = self
          collectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "footer")
        
        // TODO: remove parent, waiting for menu proxy controller refactor
        parent?.navigationItem.rightBarButtonItem = layoutChangeButton
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        onUpdateBounds()
    }
    
    // MARK: UX
    @objc private func onPullRefresh() {
        output.didAskFetchAll()
    }
    
    @objc private func onPullRefreshBottom() {
        output.didAskFetchMore()
    }
    
    private func onUpdateLayout(type: FeedModuleLayoutType, animated: Bool = false) {
        
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
    
    private func onUpdateBounds() {
        if let collectionView = self.collectionView {
            updateLayoutFlowForList(layout: listLayout, containerWidth: collectionView.frame.size.width)
            updateLayoutFlowForGrid(layout: gridLayout, containerWidth: collectionView.frame.size.width)
        }
    }
    
    private func updateLayoutFlowForGrid(layout: UICollectionViewFlowLayout, containerWidth: CGFloat) {
        
        let padding = Style.Collection.gridCellsPadding
        layout.sectionInset = UIEdgeInsets(top: padding , left: padding , bottom: padding , right: padding )
        layout.minimumLineSpacing = padding
        layout.minimumInteritemSpacing = padding
        let itemsPerRow = Style.Collection.itemsPerRow
        var paddings = layout.minimumInteritemSpacing * CGFloat((itemsPerRow - 1))
        paddings += layout.sectionInset.left + layout.sectionInset.right
        let itemWidth = (containerWidth - paddings) / itemsPerRow
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth)
    }
    
    private func updateLayoutFlowForList(layout: UICollectionViewFlowLayout, containerWidth: CGFloat) {
        layout.minimumLineSpacing = Style.Collection.rowsMargin
    }
    
    @objc private func didTapChangeLayout() {
        output.didTapChangeLayout()
    }
    
    fileprivate func didReachBottom() {
        Logger.log()
        self.output.didAskFetchMore()
    }
    
    // MARK: FeedModuleViewInput
    func setupInitialState() {
        
    }
    
    func getViewHeight() -> CGFloat {
        return collectionView.collectionViewLayout.collectionViewContentSize.height
    }
    
    func setLayout(type: FeedModuleLayoutType) {
        self.collectionView.reloadData()
        onUpdateLayout(type: type)
    }
    
    func setRefreshing(state: Bool) {
        Logger.log(state)
        if state {
            if refreshControl.superview != collectionView {
                collectionView!.addSubview(refreshControl)
            }
            refreshControl.beginRefreshing()
            bottomRefreshControl.startAnimating()

        } else {
            refreshControl.endRefreshing()
            bottomRefreshControl.stopAnimating()
        }
    }
    
    func reload() {
        collectionView?.reloadData()
    }
    
    func reload(with index: Int) {
        collectionView?.reloadItems(at: [IndexPath(item: index, section: 0)])
    }
    
    func registerHeader<T: UICollectionReusableView>(withType type: T.Type, configurator: @escaping (T) -> Void) {
        collectionView.register(type,
                                forSupplementaryViewOfKind: UICollectionElementKindSectionHeader,
                                withReuseIdentifier: type.reuseID)
        headerReuseID = type.reuseID
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
 
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return output.headerSize
    }
}

extension FeedModuleViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        output.didScrollFeed(scrollView)
        
        if (scrollView.contentOffset.y >= (scrollView.contentSize.height - scrollView.frame.size.height)) {
            output.didAskFetchMore()
        }
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: Style.Collection.footerHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if kind == UICollectionElementKindSectionFooter {
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                       withReuseIdentifier: "footer",
                                                                       for: indexPath)
            
            view.addSubview(bottomRefreshControl)
            bottomRefreshControl.startAnimating()
            
            bottomRefreshControl.snp.makeConstraints({ (make) in
                make.center.equalToSuperview()
            })
            
            return view
        } else if kind == UICollectionElementKindSectionHeader {
            
            guard let headerReuseID = headerReuseID else {
                fatalError("Header wasn't registered")
            }
            let headerView = collectionView
                .dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerReuseID, for: indexPath)
            output.configureHeader(headerView)
            return headerView
            
        }
        
        return UICollectionReusableView()
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        let index = indexPath.row
        
        if index == output.numberOfItems() - 1 {
            didReachBottom()
        }
        
    }


}
