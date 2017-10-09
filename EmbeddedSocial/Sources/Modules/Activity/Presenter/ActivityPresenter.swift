//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

protocol ActivityModuleInput: class {
    
}

typealias Section = PagesListModel<SectionHeader, ActivityItem>

class ActivityPresenter {
    
    weak var view: ActivityViewInput!
    var interactor: ActivityInteractorInput
    var router: ActivityRouterInput!
    
    var theme: Theme?
    
    enum State: Int  {
        case my = 0
        case others = 1
        
        mutating func toggle() {
            self = State(rawValue: rawValue ^ 1)!
        }
    }
    
    var state: State = .my {
        didSet {
            onStateDidChange()
        }
    }
    
    fileprivate lazy var actionBuilder: ActivityActionBuilder = { [unowned self] in
        let builder = ActivityActionBuilder()
        builder.presenter = self
        return builder
    }()
    
    fileprivate lazy var cellConfigurator: CellConfigurator = { [unowned self] in
        let configurator = CellConfigurator()
        configurator.presenter = self
        configurator.theme = self.theme
        return configurator
    }()
    
    // MARK: Private
    fileprivate func registerCells() {
        let cellTypes = [
            FollowRequestCell.reuseID : FollowRequestCell.self,
            ActivityCell.reuseID: ActivityCell.self
        ]
            
        cellTypes.forEach{ view.registerCell(cell: $0.value, id: $0.key) }
    }
    
    init(interactor: ActivityInteractorInput) {
        self.interactor = interactor
        setup()
    }
    
    fileprivate func setup() {
        dataSources = makeDataSources()
    }
    
    var dataSources: [State: [DataSource]] = [:]
    
    fileprivate func makeDataSources() -> [State: [DataSource]] {
        
        var sources: [State: [DataSource]] = [:]
        
        let pendingDataSource = DataSourceBuilder.buildPendingRequestsDataSource(
            interactor: interactor,
            delegate: self,
            context: DataSourceContext(state: self.state, index:0))
        
        let myActivityDataSource = DataSourceBuilder.buildMyActivitiesDataSource(
            interactor: interactor,
            delegate: self,
            context: DataSourceContext(state: self.state, index: 1))
        
        let othersActivityDataSource = DataSourceBuilder.buildOthersActivitiesDataSource(
            interactor: interactor,
            delegate: self,
            context: DataSourceContext(state: self.state, index: 0))
        
        sources[.my] = [pendingDataSource, myActivityDataSource]
        sources[.others] = [othersActivityDataSource]
        return sources
    }
    
    private func onStateDidChange() {
        // load/update feed
        view.reloadItems()
        loadAll()
    }
}

extension ActivityPresenter: DataSourceDelegate {
    func didChangeItems(change: Change<IndexPath>, context: DataSourceContext) {
        guard state == context.state else {
            return
        }
        
        switch change {
        case let .update(items):
            view.reloadItems(indexes: items)
        case let .insertion(items):
            view.addNewItems(indexes: items)
        case let .deletion(items):
            view.removeItems(indexes: items)
        case .updateVisible:
            view.updateVisible()
        }
    }
    
    func didFail(error: Error) {
        view.showError(error)
    }
    
    func didLoad(indexPaths: [IndexPath], context: DataSourceContext) {
        guard state == context.state else {
            return
        }
    }
}

extension ActivityPresenter: ActivityModuleInput {
    func handleCellEvent(indexPath: IndexPath, event: ActivityCellEvent) {
        let dataSource = dataSources[state]![indexPath.section]
        let item = dataSource.section.items[indexPath.item]
        let action = actionBuilder.build(from: item, with: event, dataSource: dataSource)
        action.execute()
    }
}

extension ActivityPresenter: ActivityInteractorOutput {
    
}

extension ActivityPresenter: ActivityViewOutput {
 
    func didSwitchToTab(to index: Int) {
        guard let state = State(rawValue: index) else { fatalError("Wrong index") }
        self.state = state
    }
    
    func loadMore() {
        dataSources[state]?.forEach { $0.loadMore() }
    }
    
    func loadAll() {
        // wipe data sources
        dataSources = makeDataSources()
        
        // re-load view
        view.reloadItems()
        // re-load data stores
        dataSources[state]?.forEach { $0.load() }
    }
    
    func cellIdentifier(for indexPath: IndexPath) -> String {
        let item = dataSources[state]![indexPath.section].section.items[indexPath.row]
        let viewModel = ActivityItemViewModelBuilder.build(from: item)
        return viewModel.cellID
    }
    
    func configure(_ cell: UITableViewCell, for tableView: UITableView, with indexPath: IndexPath) {
        let itemIndex = indexPath.row
        let sectionIndex = indexPath.section
        let item = dataSources[state]![sectionIndex].section.items[itemIndex]
        // TODO: move out cell ids from VM
        let viewModel = ActivityItemViewModelBuilder.build(from: item)
        
        cellConfigurator.configure(cell: cell, viewModel: viewModel, tableView: tableView) { [weak self] path, event in
            self?.handleCellEvent(indexPath: path, event: event)
        }
    }
    
    func headerForSection(_ section: Int) -> String {
        return dataSources[state]![section].section.header.name
    }
    
    func numberOfSections() -> Int {
        return dataSources[state]!.count
    }
    
    func numberOfItems(in section: Int) -> Int {
        let dataSource = dataSources[state]![section]
        return dataSource.section.items.count
    }
    
    func viewIsReady() {
        registerCells()
        loadAll()
    }
}
