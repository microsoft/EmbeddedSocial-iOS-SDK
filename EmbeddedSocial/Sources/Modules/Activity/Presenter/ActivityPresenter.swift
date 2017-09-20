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
    
    enum DataSourcesIndexes: Int {
        case pendingItems = 0
        case myActivityItems = 1
        case othersActivityItems = 2
    }
    
    var state: State = .my
    
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

    }
    
    fileprivate lazy var dataSources: [State: [DataSource]] = { [unowned self] in
        
        var sources: [State: [DataSource]] = [:]
        
        sources[.my] = [
            self.buildPendingRequestsDataSource(index: 0),
            self.buildMyFollowingsActivityDataSource(index: 1)]
        
        return sources
    }()
    
    private func buildPendingRequestsDataSource(index: Int) -> MyPendingRequests {
        let header = SectionHeader(name: "", identifier: "")
        let section = Section(model: header, items: [])
        
        return MyPendingRequests(interactor: interactor,
                                 section:section,
                                 delegate: self,
                                 index: index)
    }
    
    private func buildMyFollowingsActivityDataSource(index: Int) -> MyFollowingsActivity {
        let header = SectionHeader(name: "", identifier: "")
        let section = Section(model: header, items: [])
        
        return MyFollowingsActivity(interactor: interactor,
                                    section: section,
                                    delegate: self,
                                    index: index)
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



protocol DataSourceProtocol {
    func loadMore()
    var section: Section { get }
    var delegate: DataSourceDelegate? { get }
    var index: Int { get }
}

protocol DataSourceDelegate {
    func didFail(error: Error)
    func didLoad(indexPaths: [IndexPath])
}

class DataSource: DataSourceProtocol {
    var interactor: ActivityInteractorInput
    var section: Section
    var delegate: DataSourceDelegate?
    var index: Int
    
    func loadMore() { }
    
    init(interactor: ActivityInteractorInput,
         section: Section,
         delegate: DataSourceDelegate? = nil,
         index: Int) {
        
        self.interactor = interactor
        self.section = section
        self.delegate = delegate
        self.index = index
    }
    
    func insertedIndexes(newItemsCount: Int) -> [IndexPath] {
        // make paths for inserted items
        let range = (section.items.count - newItemsCount)..<section.items.count
        let indexPaths = range.map { IndexPath(row: $0, section: index) }
        return indexPaths
    }

}


class MyPendingRequests: DataSource {
    
    override func loadMore() {
        
        // load pendings
        interactor.loadNextPagePendigRequestItems { [weak self] (result) in
            
            guard let strongSelf = self else { return }
            
            switch result {
            case let .failure(error):
                strongSelf.delegate?.didFail(error: error)
            case let .success(models):
                let items = models.map { ActivityItem.pendingRequest($0) }
                strongSelf.section.items.append(contentsOf: items)
                
                // make paths for inserted items
                let indexPaths = strongSelf.insertedIndexes(newItemsCount: items.count)
                strongSelf.delegate?.didLoad(indexPaths: indexPaths)
            }
        }
    }
    
}

class MyFollowingsActivity: DataSource {
    
    override func loadMore() {
        // load activity
        interactor.loadNextPageFollowingActivities {  [weak self] (result) in
            
            guard let strongSelf = self else { return }
            
            switch result {
            case let .failure(error):
                strongSelf.delegate?.didFail(error: error)
            case let .success(models):
                let items = models.map { ActivityItem.follower($0) }
                strongSelf.section.items.append(contentsOf: items)
                
                // make paths for inserted items
                let indexPaths = strongSelf.insertedIndexes(newItemsCount: items.count)
                strongSelf.delegate?.didLoad(indexPaths: indexPaths)
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
        let dataSource = dataSources[state]![section]
        return dataSource.section.items.count
    }
    
    func viewIsReady() {
        registerCells()
    }
    
}
