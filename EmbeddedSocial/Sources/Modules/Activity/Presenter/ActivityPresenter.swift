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
    
    // MARK: Private

    func numberOfSections() -> Int {
        return 2
    }
    
    func numberOfItems(in section: Int) -> Int {
        return 1 //data[section].count
    }
    
    struct Item {
        var name: String = "some"
    }
    
    struct Feed {
        let name: String
        var items: [Item]
    }
    
    struct DataSources {
        
        var my: Feed = Feed(name: "my", items: [])
        var others: Feed = Feed(name: "my", items: [])
        var pending: Feed = Feed(name: "my", items: [])
    }
    
    let dataSources = DataSources()
    
    enum State {
        case my
        case others
    }
    
    func sections(for state: State) -> [Feed] {
        
        switch state {
        case .my:
            return [dataSources.pending, dataSources.my]
        case .others:
            return [dataSources.others]
        }
    }
    
    func item(for indexPath: IndexPath) -> ActivityItemViewModel {
        return viewModel(for: indexPath)
    }
    
    var cursor: String? = nil
    
    // MARK: Interactor Output
    
}
