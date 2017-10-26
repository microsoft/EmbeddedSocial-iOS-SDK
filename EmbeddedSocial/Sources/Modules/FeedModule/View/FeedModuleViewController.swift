//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import UIKit
import BMACollectionBatchUpdates

protocol FeedModuleViewInput: class {
    
    func setupInitialState(showGalleryView: Bool)
    func setLayout(type: FeedModuleLayoutType)
    func resetFocus()
    
    // Turns off "pull to refresh"
    func setRefreshing(state: Bool)
    // Turns on/off loading indicator
    func setRefreshingWithBlocking(state: Bool)
    func showError(error: Error)
    
    func registerHeader<T: UICollectionReusableView>(withType type: T.Type, configurator: @escaping (T) -> Void)
    func refreshLayout()
    func setScrolling(enable: Bool)
    
    func getViewHeight() -> CGFloat
    func needShowNoContent(state: Bool)

    var paddingEnabled: Bool { get set }
    func performBatches(updates: [BMACollectionUpdate]?, withSections: [BMAUpdatableCollectionSection])
}

class FeedModuleViewController: BaseViewController, FeedModuleViewInput {
    
    var output: FeedModuleViewOutput!
    
    var numberOfItems: Int {
        return collectionView?.numberOfItems(inSection: 0) ?? 0
    }
    
    var paddingEnabled: Bool = false {
        didSet {
            refreshLayout()
        }
    }
    
    fileprivate var listLayout = UICollectionViewFlowLayout()
    fileprivate var gridLayout = UICollectionViewFlowLayout()
    fileprivate var headerReuseID: String?
    fileprivate var footerReuseID: String = "footer"
    fileprivate var isPullingBottom = false {
        didSet {
            if isPullingBottom == true && isPullingBottom != oldValue {
                Logger.log("Requesting fetch more")
                self.output.didAskFetchMore()
            }
        }
    }
    
    fileprivate func canChangeLayout() -> Bool {
        return collectionViewAnimations == 0
    }
    
    fileprivate var collectionViewAnimations = 0 {
        didSet {
            assert(collectionViewAnimations >= 0)
            checkNeedsLayoutChange()
        }
    }
    
    fileprivate var pendingLayout: FeedModuleLayoutType?
    fileprivate func checkNeedsLayoutChange() {
        
        guard let layout = pendingLayout, canChangeLayout() == true else {
            return
        }
        
        onUpdateLayout(type: layout)
        pendingLayout = nil
    }
    
    fileprivate func didStartCollectionViewAnimation() {
        collectionViewAnimations += 1
    }
    
    fileprivate func didFinishCollectionViewAnimation() {
        collectionViewAnimations -= 1
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    lazy var bottomRefreshControl: UIActivityIndicatorView = {
        let activity = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        activity.hidesWhenStopped = true
        
        return activity
    }()
    
    lazy var noContentLabel: UILabel = { [unowned self] in
        let view = UILabel()
        view.text = L10n.Common.noContent
        view.sizeToFit()
        view.isHidden = true
        
        return view
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
        let width = self.containerWidth()
        let height = cell.frame.height
        cell.frame = CGRect(x: 0, y: 0, width: width, height: height)
        return cell
    }()
    
    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Table
        self.collectionView.register(PostCell.nib, forCellWithReuseIdentifier: PostCell.reuseID)
        self.collectionView.register(PostCellCompact.nib, forCellWithReuseIdentifier: PostCellCompact.reuseID)
        self.collectionView.delegate = self
        collectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: footerReuseID)
        
        // Subviews
        collectionView.addSubview(noContentLabel)
        
        noContentLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        // Init Done
        onUpdateBounds()
        output.viewIsReady()
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
        
        collectionView.reloadData()
        collectionView.collectionViewLayout.invalidateLayout()
    
        // switch layout
        switch type {
        case .grid:
            layoutChangeButton.image = UIImage(asset: .iconList)
            if collectionView.collectionViewLayout != gridLayout {
                collectionView.setCollectionViewLayout(gridLayout, animated: animated)
            }
        case .list:
            layoutChangeButton.image = UIImage(asset: .iconGallery)
            if collectionView.collectionViewLayout != listLayout {
                collectionView.setCollectionViewLayout(listLayout, animated: animated)
            }
        }
    }
    
    private func onUpdateBounds() {
        updateFlowLayoutForList(layout: listLayout, containerWidth: containerWidth())
        updateFlowLayoutForGrid(layout: gridLayout, containerWidth: containerWidth())
        
//        let limits = [
//            numberOfItemsInList(listLayout, in: collectionView.frame),
//            numberOfItemsInGrid(gridLayout, in: collectionView.frame)
//        ]
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
        let padding = paddingEnabled ? Constants.FeedModule.Collection.gridCellsPadding : 0
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
        
        let containerHeight = collectionView.bounds.height
        
        var size = CGSize.zero
        size.height = sizingCell.getHeight(containerHeight:containerHeight, with: containerWidth(), isTrimmed: viewModel.isTrimmed)
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
    func setupInitialState(showGalleryView: Bool) {
        if showGalleryView {
            navigationItem.rightBarButtonItem = layoutChangeButton
        }
        collectionView.alwaysBounceVertical = true
        collectionView.addSubview(refreshControl)
        apply(theme: theme)
    }
    
    func showError(error: Error) {
        self.showErrorAlert(error)
    }
    
    func needShowNoContent(state: Bool) {
        noContentLabel.isHidden = !state
    }
    
    func resetFocus() {
        self.collectionView.setContentOffset(CGPoint.zero, animated: false)
    }
    
    func getViewHeight() -> CGFloat {
        return collectionView.collectionViewLayout.collectionViewContentSize.height
    }

    func setLayout(type: FeedModuleLayoutType) {
        pendingLayout = type
        checkNeedsLayoutChange()
    }
    
    func refreshLayout() {
        collectionView?.collectionViewLayout.invalidateLayout()
    }
    
    func setScrolling(enable: Bool) {
        collectionView.isScrollEnabled = enable
    }
    
    func setRefreshing(state: Bool) {
        if state == false {
            refreshControl.endRefreshing()
        }
    }
    
    func setRefreshingWithBlocking(state: Bool) {
        Logger.log(state)
        if state {
            //            collectionView.isUserInteractionEnabled = false
            showHUD(in: view)
        } else {
            //            collectionView.isUserInteractionEnabled = true
            hideHUD(in: view)
        }
    }
    
    func performBatches(updates: [BMACollectionUpdate]?, withSections: [BMAUpdatableCollectionSection]) {
        self.collectionView.bma_performBatchUpdates(updates, applyChangesToModelBlock: {
            
            guard let section = withSections.first as? BatchCollection, let batchItems = section.items as? [BatchCollectionItem] else {
                fatalError()
            }
            
            self.output.currentItems = batchItems.map { $0.post }
        }, reloadCellBlock: { (cell, path) in
            
            guard let cell = cell as? PostCellProtocol else {
                fatalError("Wrong cell")
            }
            
            let item = self.output.item(for: path)
            cell.configure(with: item, collectionView: self.collectionView)
            
        }) { (completed) in
            
        }
    }
    
    func registerHeader<T: UICollectionReusableView>(withType type: T.Type, configurator: @escaping (T) -> Void) {
        collectionView.register(type,
                                forSupplementaryViewOfKind: UICollectionElementKindSectionHeader,
                                withReuseIdentifier: type.reuseID)
        headerReuseID = type.reuseID
    }
    
    deinit {
        Logger.log()
        self.collectionView?.delegate = nil
        self.collectionView?.dataSource = nil
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
        
        (cell as? Themeable)?.apply(theme: theme)

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
  
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if kind == UICollectionElementKindSectionFooter {
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                       withReuseIdentifier: footerReuseID,
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

extension FeedModuleViewController: Themeable {
    
    func apply(theme: Theme?) {
        guard let palette = theme?.palette else {
            return
        }
        collectionView.backgroundColor = palette.topicsFeedBackground
        view.backgroundColor = palette.topicsFeedBackground
        noContentLabel.textColor = palette.textPrimary
        refreshControl.tintColor = palette.loadingIndicator
    }
}
