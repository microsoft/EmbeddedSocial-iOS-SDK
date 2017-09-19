//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

protocol ActivityModuleInput: class {
    
}

class ActivityPresenter: ActivityModuleInput, ActivityViewOutput, ActivityInteractorOutput {
    
    func viewModel(for indexPath: IndexPath) -> ActivityItemViewModel {
        
        return ActivityViewModel(profileImage: Asset.placeholderPostUser1.image,
                                 postText: "asa",
                                 postTime: "sdadsa",
                                 postImage: Asset.placeholderPostImage2.image,
                                 identifier: ActivityCell.reuseID)
        
    }
    
    weak var view: ActivityViewInput!
    var interactor: ActivityInteractorInput!
    var router: ActivityRouterInput!
    
    func viewIsReady() {
        view.setupInitialState()
    }
    
    func shouldPreloadPage<T>(withCurrent item: Int, for section: PaggedSection<T>) -> Bool {
        
        let preloadingIndex = item + section.limit
        let shouldPreload = preloadingIndex < section.items.count
        
        return section.nextPageAvailable && shouldPreload
    }
    
    enum State: Int {
        case myActivity
        case othersActivity
    }
    
    class DataSource {
        var sections: [PaggedSection<ActivityItem>]
        
        init(sections: [PaggedSection<ActivityItem>]) {
            self.sections = sections
        }
    }
    
    var currentState: State = .myActivity
    var currentDataSource: DataSource {
        return dataSources[currentState]!
    }
    
    private lazy var dataSources: [State: DataSource] = { [unowned self] in
        
        return [
            State.myActivity: DataSource(sections: [
                PaggedSection<ActivityItem>(itemType: .myActivity, name: "activity"),
                PaggedSection<ActivityItem>(itemType: .othersActivity, name: "name2")
                ]),
            State.othersActivity: DataSource(sections: [
                PaggedSection<ActivityItem>(itemType: .othersActivity, name: "name3")
                ])
        ]
        
        }()
    
    // MARK: Data Flow
    
    func loadData() {
        
        currentDataSource.sections.forEach {  (pagedSection) in
            //            pagedSection.
        }
    }
    
    // MARK: ActivityViewOutput
    
    func numberOfSections() -> Int {
        return currentDataSource.sections.count
    }
    
    func numberOfItems(in section: Int) -> Int {
        return  currentDataSource.sections[section].items.count
    }
    
}
