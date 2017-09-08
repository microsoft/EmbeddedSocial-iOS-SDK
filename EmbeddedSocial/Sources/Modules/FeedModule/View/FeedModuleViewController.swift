//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import UIKit
import SVProgressHUD

protocol FeedModuleViewInput: class {
    
    func setupInitialState()
    func setLayout(type: FeedModuleLayoutType)
    func resetFocus()
    func reload()
    func reload(with index: Int)
    func reloadVisible()
    func removeItem(index: Int)
    func setRefreshing(state: Bool)
    func setRefreshingWithBlocking(state: Bool)
    func showError(error: Error)
    
    func registerHeader<T: UICollectionReusableView>(withType type: T.Type, configurator: @escaping (T) -> Void)
    func refreshLayout()
    
    func getViewHeight() -> CGFloat
    //func getItemSize() -> CGSize
    
    var itemsLimit: Int { get }
    var paddingEnabled: Bool { get set }
}

class FeedModuleViewController: UIViewController, FeedModuleViewInput {
    
    var output: FeedModuleViewOutput!
    
    var numberOfItems: Int {
        return collectionView?.numberOfItems(inSection: 0) ?? 0
    }
    
    var paddingEnabled: Bool = false {
        didSet {
            refreshLayout()
        }
    }
    
    fileprivate var cachedLimit: Int?
    var itemsLimit: Int {
        return cachedLimit ?? 0
    }
    
    fileprivate var listLayout = UICollectionViewFlowLayout()
    fileprivate var gridLayout = UICollectionViewFlowLayout()
    fileprivate var headerReuseID: String?
    fileprivate var isPullingBottom = false {
        didSet {
            if isPullingBottom == true && isPullingBottom != oldValue {
                Logger.log("Requesting fetch more")
                self.output.didAskFetchMore()
            }
        }
    }
    
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
        self.collectionView.delegate = self
          collectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "footer")
        
        navigationItem.rightBarButtonItem = layoutChangeButton
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        output.viewDidAppear()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Turn off UI block on exit
        setRefreshingWithBlocking(state: false)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        onUpdateBounds()
    }
    
    // MARK: UX
    @objc private func onPullRefresh() {
        output.didAskFetchAll()
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
            updateFlowLayoutForList(layout: listLayout, containerWidth: collectionView.frame.size.width)
            updateFlowLayoutForGrid(layout: gridLayout, containerWidth: collectionView.frame.size.width)
            
            let limits = [
                numberOfItemsInList(listLayout, in: collectionView.frame),
                numberOfItemsInGrid(gridLayout, in: collectionView.frame)
            ]
            
            cachedLimit = limits.max()
        }
    }
    
    private func updateFlowLayoutForGrid(layout: UICollectionViewFlowLayout, containerWidth: CGFloat) {
        
        let spacBetweenItems = Constants.FeedModule.Collection.gridCellsPadding
        let topPadding = paddingEnabled ? Constants.FeedModule.Collection.containerPadding : 0
        let horizontalPadding = paddingEnabled ? Constants.FeedModule.Collection.containerPadding : 0
        layout.sectionInset = UIEdgeInsets(top: topPadding,
                                           left: horizontalPadding,
                                           bottom: topPadding,
                                           right: horizontalPadding)
        
        layout.minimumLineSpacing = spacBetweenItems
        layout.minimumInteritemSpacing = spacBetweenItems
        let itemsPerRow = Constants.FeedModule.Collection.itemsPerRow
        var paddings = layout.minimumInteritemSpacing * CGFloat((itemsPerRow - 1))
        paddings += layout.sectionInset.left + layout.sectionInset.right
        let itemWidth = (containerWidth - paddings) / itemsPerRow
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth)
    }
    
    private func updateFlowLayoutForList(layout: UICollectionViewFlowLayout, containerWidth: CGFloat) {
        let padding = Constants.FeedModule.Collection.gridCellsPadding
        layout.minimumLineSpacing = Constants.FeedModule.Collection.rowsMargin
        layout.sectionInset = UIEdgeInsets(top: padding , left: padding , bottom: padding , right: padding )
        layout.itemSize = CGSize(width: containerWidth, height: CGFloat(0))
    }
    
    private func numberOfItemsInList(_ layout: UICollectionViewFlowLayout, in rect: CGRect) -> Int {
        
        let item = PostViewModel(with: Post.mock(seed: 0),
                                 cellType: FeedModuleLayoutType.list.cellType,
                                 actionHandler: nil)
        var size = calculateCellSizeWith(viewModel: item)
        
        size.height += layout.minimumLineSpacing
        
        var result = rect.height / size.height
        result.round(.up)
        
        return Int(result)
    }
    
    private func numberOfItemsInGrid(_ layout: UICollectionViewFlowLayout, in rect: CGRect) -> Int {
        
        let itemHeight = layout.itemSize.height + layout.minimumLineSpacing
        let rows = (rect.size.height / itemHeight).rounded(.up)
        let result = rows * Constants.FeedModule.Collection.itemsPerRow
        
        return Int(result)
    }
    
    fileprivate func calculateCellSizeWith(viewModel: PostViewModel) -> CGSize {
        
        sizingCell.configure(with: viewModel, collectionView: nil)
        
        // TODO: remake via manual calculation
        sizingCell.needsUpdateConstraints()
        sizingCell.updateConstraints()
        sizingCell.setNeedsLayout()
        sizingCell.layoutIfNeeded()
        
        var size = sizingCell.container.bounds.size
        size.width = containerWidth()
        
        return size
    }
    
    @objc private func didTapChangeLayout() {
        output.didTapChangeLayout()
    }
    
    fileprivate func didReachBottom() {
        Logger.log()
        self.output.didAskFetchMore()
    }
    
    // MARK: Private
    
    fileprivate func containerWidth() -> CGFloat {
        
        var result = view.frame.width
        
        if paddingEnabled {
            result -= (Constants.FeedModule.Collection.containerPadding * 2)
        }
        return result
    }
    
    // MARK: Input
    
    func setupInitialState() {
        collectionView.backgroundColor = Palette.extraLightGrey
        collectionView.alwaysBounceVertical = true
        collectionView.addSubview(refreshControl)
    }
    
    func showError(error: Error) {
        self.showErrorAlert(error)
    }
    
    func resetFocus() {
        self.collectionView.setContentOffset(CGPoint.zero, animated: false)
    }
    
    func getViewHeight() -> CGFloat {
        return collectionView.collectionViewLayout.collectionViewContentSize.height
    }
    
    func setLayout(type: FeedModuleLayoutType) {
        // Apply new layout
        onUpdateLayout(type: type)
    }
    
    func refreshLayout() {
        collectionView?.collectionViewLayout.invalidateLayout()
    }
    
    func setRefreshing(state: Bool) {
        if state == false {
            refreshControl.endRefreshing()
        }
    }
    
    func setRefreshingWithBlocking(state: Bool) {
        Logger.log(state)
        if state {
            collectionView.isUserInteractionEnabled = false
            SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.none)
            SVProgressHUD.show()
        } else {
            collectionView.isUserInteractionEnabled = true
            SVProgressHUD.dismiss()
        }
    }
    
    func reloadVisible() {
        Logger.log()
        if let paths = collectionView?.indexPathsForVisibleItems {
            collectionView?.reloadItems(at: paths)
        }
    }
    
    func removeItem(index: Int) {
        Logger.log(index)
        collectionView?.performBatchUpdates({ [weak self] in
            self?.collectionView?.deleteItems(at: [IndexPath(item: index, section: 0)])
        }, completion: nil)
    }
    
    func reload() {
        Logger.log()
        collectionView?.reloadData()
    }
    
    func reload(with index: Int) {
        Logger.log(index)
        collectionView?.reloadItems(at: [IndexPath(item: index, section: 0)])
    }
    
    func registerHeader<T: UICollectionReusableView>(withType type: T.Type, configurator: @escaping (T) -> Void) {
        collectionView.register(type,
                                forSupplementaryViewOfKind: UICollectionElementKindSectionHeader,
                                withReuseIdentifier: type.reuseID)
        headerReuseID = type.reuseID
    }
    
    deinit {
        Logger.log()
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
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionViewLayout === listLayout {
            
            let item = output.item(for: indexPath)

            return calculateCellSizeWith(viewModel: item)
            
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
        
        return CGSize(width: containerWidth(), height: output.headerSize.height)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForFooterInSection section: Int) -> CGSize {
        if collectionView.numberOfItems(inSection: 0) > 1 {
            return CGSize(width: collectionView.frame.size.width, height: Constants.FeedModule.Collection.footerHeight)
        } else {
            return CGSize.zero
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if kind == UICollectionElementKindSectionFooter {
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                       withReuseIdentifier: "footer",
                                                                       for: indexPath)
            
            view.addSubview(bottomRefreshControl)
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
}

extension FeedModuleViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        output.didScrollFeed(scrollView)
        
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let containerHeight = scrollView.frame.size.height
        
        isPullingBottom = offsetY > 0 && (contentHeight - offsetY) < (containerHeight - 10)
    }
}
