//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

protocol ActivityModuleInput: class {
    
}

class ActivityPresenter {
    
    typealias Section = SectionModel<SectionHeader, ActivityItem>
    
    weak var view: ActivityViewInput!
    var interactor: ActivityInteractorInput!
    var router: ActivityRouterInput!

    enum State: Int {
        case my
        case others
    }
    
    fileprivate var state: State = .my
    fileprivate var sections: [State: [Section]] = [:]
    
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
        makeSections()
    }
    
    fileprivate func makeSections() {
        sections[.my] = sectionsConfigurator.build(section: .my)
        sections[.others] = sectionsConfigurator.build(section: .others)
    }
}

extension ActivityPresenter: ActivityModuleInput {
    
}


extension ActivityPresenter: ActivityInteractorOutput {
    
}

extension ActivityPresenter: ActivityViewOutput {
    
    func cellIdentifier(for indexPath: IndexPath) -> String {
        let item = sections[state]![indexPath.section].items[indexPath.row]
        let viewModel = viewModelBuilder.build(from: item)
        return viewModel.cellID
    }
    
    func configure(_ cell: UITableViewCell, for indexPath: IndexPath) {
        
        let itemIndex = indexPath.row
        let sectionIndex = indexPath.section
        let item = sections[state]![sectionIndex].items[itemIndex]
        let viewModel = viewModelBuilder.build(from: item)
        cellConfigurator.configure(cell: cell, with: viewModel)
        
    }
    
    func numberOfSections() -> Int {
        return sections.count
    }
    
    func numberOfItems(in section: Int) -> Int {
        return sections[state]![section].items.count
    }
    
    func viewIsReady() {
        registerCells()
    }
    
}
