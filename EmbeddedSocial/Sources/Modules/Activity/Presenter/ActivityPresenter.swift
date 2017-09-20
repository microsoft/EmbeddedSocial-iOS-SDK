//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

protocol ActivityModuleInput: class {
    
}

typealias Section = SectionModel<SectionHeader, ActivityItem>

class ActivityPresenter {
    
    weak var view: ActivityViewInput!
    var interactor: ActivityInteractorInput!
    var router: ActivityRouterInput!
    
    enum State: Int {
        case my
        case others
    }
    
    fileprivate var state: State = .my
    fileprivate var dataSources: [State: [DataSource]] = [:]
    
    fileprivate var viewModelBuilder = ActivityViewModelBuilder()
    fileprivate var cellConfigurator = CellConfigurator()
    fileprivate var sectionsConfigurator = SectionsConfigurator()
    
    // MARK: Private
    fileprivate func registerCells() {
        viewModelBuilder.cellTypes.forEach{ view.registerCell(cell: $0.value, id: $0.key) }
    }
    
    init() {
        setup()
    }
    
    fileprivate func setup() {
        initDataSources()
    }
    
    fileprivate func initDataSources() {
        dataSources[.my] = [buildPendingRequestsDataSource(), buildMyFollowingsActivityDataSource()]
    }
    
    private func buildPendingRequestsDataSource() -> MyPendingRequests {
        let header = SectionHeader(name: "", identifier: "")
        let section = Section(model: header, items: [])
        return MyPendingRequests(interactor: interactor, section: section)
    }
    
    private func buildMyFollowingsActivityDataSource() -> MyFollowingsActivity {
        let header = SectionHeader(name: "", identifier: "")
        let section = Section(model: header, items: [])
        return MyFollowingsActivity(interactor: interactor, section: section)
    }
}

extension ActivityPresenter: ActivityModuleInput {
    
}


extension ActivityPresenter: ActivityInteractorOutput {
    
}



protocol DataSourceProtocol {
    func loadMore()
    var section: Section { get }
}

class DataSource: DataSourceProtocol {
    var interactor: ActivityInteractorInput
    var section: Section
    var errorHandler: ((Error) -> Void)?
    
    func loadMore() { }
    
    init(interactor: ActivityInteractorInput, section: Section, errorHandler: ((Error) -> Void)? = nil) {
        self.interactor = interactor
        self.section = section
        self.errorHandler = errorHandler
    }
}


class MyPendingRequests: DataSource {
    
    override func loadMore() {
        
        // load pendings
        interactor.loadNextPagePendigRequestItems { [weak self] (result) in
            switch result {
            case let .failure(error):
                self?.errorHandler?(error)
            case let .success(models):
                let items = models.map { ActivityItem.pendingRequest($0) }
                self?.section.items.append(contentsOf: items)
            }
        }
    }
    
}

class MyFollowingsActivity: DataSource {
    
    override func loadMore() {
        // load activity
        interactor.loadNextPageFollowingActivities {  [weak self] (result) in
            switch result {
            case let .failure(error):
                self?.errorHandler?(error)
            case let .success(models):
                let items = models.map { ActivityItem.follower($0) }
                self?.section.items.append(contentsOf: items)
            }
        }
    }
}

class MyFollowersActivity: DataSource {
    
    override func loadMore() {
        
    }
}


extension ActivityPresenter: ActivityViewOutput {
    
    func load() {
        interactor.loadAll()
    }
    
    func loadMore() {
        dataSources[state]?.forEach { $0.loadMore() }
    }
    
    func cellIdentifier(for indexPath: IndexPath) -> String {
        let item = dataSources[state]![indexPath.section].section.items[indexPath.row]
        let viewModel = viewModelBuilder.build(from: item)
        return viewModel.cellID
    }
    
    func configure(_ cell: UITableViewCell, for indexPath: IndexPath) {
        
        let itemIndex = indexPath.row
        let sectionIndex = indexPath.section
        let item = dataSources[state]![sectionIndex].section.items[itemIndex]
        let viewModel = viewModelBuilder.build(from: item)
        cellConfigurator.configure(cell: cell, with: viewModel)
        
    }
    
    func numberOfSections() -> Int {
        return dataSources[state]!.count
    }
    
    func numberOfItems(in section: Int) -> Int {
        return dataSources[state]![section].section.items.count
    }
    
    func viewIsReady() {
        registerCells()
    }
    
}
