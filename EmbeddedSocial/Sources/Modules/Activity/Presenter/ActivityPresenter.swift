//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

protocol ActivityModuleInput: class {
    
}

typealias Section = SectionModel<SectionHeader, ActivityItem>

class ActivityPresenter {
    
    weak var view: ActivityViewInput!
    var interactor: ActivityInteractorInput
    var router: ActivityRouterInput!
    
    enum State: Int {
        case my
        case others
    }
    
    var state: State = .my
    
    fileprivate var cellConfigurator = CellConfigurator()
    
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
    
    fileprivate var dataSources: [State: [DataSource]] = [:]
    
    fileprivate func makeDataSources() -> [State: [DataSource]] {
        
        var sources: [State: [DataSource]] = [:]
        
        let pendingDataSource = DataSourceBuilder.buildPendingRequestsDataSource(
            interactor: interactor,
            index: 0,
            delegate: self)
        let myActivityDataSource = DataSourceBuilder.buildMyFollowingsActivityDataSource(
            interactor: interactor,
            index: 1,
            delegate: self)
        
        sources[.my]?.append(pendingDataSource)
        sources[.my]?.append(myActivityDataSource)
        
        return sources
    }
}

extension ActivityPresenter: DataSourceDelegate {
    
    func didFail(error: Error) {
        Logger.log(error, event: .veryImportant)
    }
    
    func didLoad(indexPaths: [IndexPath]) {
        view.addNewItems(indexes: indexPaths)
    }
    
}

extension ActivityPresenter: ActivityModuleInput {
    
}

extension ActivityPresenter: ActivityInteractorOutput {
    
}

extension ActivityPresenter: ActivityViewOutput {
    
    func loadAll() {
        // release data sources
        dataSources = makeDataSources()
        view.reloadItems()
        // load
        loadMore()
    }

    func loadMore() {
        dataSources[state]?.forEach { $0.loadMore() }
    }
    
    func cellIdentifier(for indexPath: IndexPath) -> String {
        let item = dataSources[state]![indexPath.section].section.items[indexPath.row]
        let viewModel = ActivityItemViewModelBuilder.build(from: item)
        return viewModel.cellID
    }
    
    func configure(_ cell: UITableViewCell, for indexPath: IndexPath) {
        let itemIndex = indexPath.row
        let sectionIndex = indexPath.section
        let item = dataSources[state]![sectionIndex].section.items[itemIndex]
        let viewModel = ActivityItemViewModelBuilder.build(from: item)
        cellConfigurator.configure(cell: cell, with: viewModel)
    }
    
    func headerForSection(_ section: Int) -> String {
        return dataSources[state]![section].section.model.name
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
        loadMore()
    }
}
