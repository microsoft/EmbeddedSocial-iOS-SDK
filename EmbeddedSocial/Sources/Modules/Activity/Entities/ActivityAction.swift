//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

enum ActivityActionType: Int {
    case approveRequest
    case rejectRequest
    case openPost
    case openComment
}

class Action {
    weak var presenter: ActivityPresenter?
    var activityItem: ActivityItem!
    weak var dataSource: DataSource?
    
    init(item: ActivityItem, presenter: ActivityPresenter, dataSource: DataSource) {
        self.activityItem = item
        self.presenter = presenter
        self.dataSource = dataSource
    }
    
    func execute() { Logger.log() }
    
    func onExecuted(_ result: Result<Void>) {
        switch result {
        case let .failure(error):
            onError(error)
        case .success(_ ):
            onSuccess()
        }
    }
    
    func onError(_ error: Error) { Logger.log(error) }
    func onSuccess() { Logger.log() }
    
    func removeItem() {
    
        guard let dataSource = dataSource, let index = dataSource.section.items.index(where: { (item) -> Bool in
            return item == activityItem
        }) else {
            return
        }
        
        // remove item
        dataSource.section.items.remove(at: index)
        
        // notify view
        let indexPath = IndexPath(row: index, section: dataSource.context.index)
        presenter?.view.removeItem(indexes: [indexPath])
    }
}

class AcceptFollowingRequestAction: Action {
    
    override func execute() {
        // performing the action
//        presenter.interactor
        onExecuted(.success())
    }
    
    override func onSuccess() {
        removeItem()
    }
}

class RejectFollowingRequestAction: Action {
    
    override func execute() {
                onExecuted(.success())
        // performing the action
        //        presenter.interactor
    }
    
    override func onSuccess() {
        removeItem()
    }
}

class TransitionAction: Action {
    
    override func execute() {
        presenter?.router.open(with: activityItem)
    }
    
}


class ActivityActionBuilder {
    
    weak var presenter: ActivityPresenter!
    
    func build(from item: ActivityItem, with action: ActivityCellEvent, dataSource: DataSource) -> Action {
        
        switch item {
        case .pendingRequest(_ ):
            switch action {
            case .accept:
                return AcceptFollowingRequestAction(item: item, presenter: presenter, dataSource: dataSource)
            case .reject:
                return RejectFollowingRequestAction(item: item, presenter: presenter, dataSource: dataSource)
            default:
                fatalError("Mismatch of action and item")
            }
        
        case .myActivity(_ ):
            assert(action == .touch)
            return TransitionAction(item: item, presenter: presenter, dataSource: dataSource)
            
        case .othersActivity(_):
            assert(action == .touch)
            return TransitionAction(item: item, presenter: presenter, dataSource: dataSource)

        }

    }
}
