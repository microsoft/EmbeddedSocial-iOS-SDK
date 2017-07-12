//
//  Storyboard.swift
//  MSGP
//
//  Created by Vadim Bulavin on 7/10/17.
//  Copyright © 2017 Igor Popov. All rights reserved.
//

import UIKit

protocol StoryboardViewControllerResourceType: Identifiable {
    associatedtype ViewControllerType
}

extension UIStoryboard {
    func instantiateViewController<Resource: StoryboardViewControllerResourceType>(withResource resource: Resource)
        -> Resource.ViewControllerType? {
        return self.instantiateViewController(withIdentifier: resource.identifier) as? Resource.ViewControllerType
    }
    
    convenience init(resource: StoryboardResourceType) {
        self.init(name: resource.name, bundle: resource.bundle)
    }
}

protocol StoryboardResourceType {
    var bundle: Bundle { get }
    var name: String { get }
}

struct StoryboardViewControllerResource<ViewController>: StoryboardViewControllerResourceType {
    typealias ViewControllerType = ViewController
    
    let identifier: String
    
    init(identifier: String) {
        self.identifier = identifier
    }
}

protocol StoryboardResourceWithInitialControllerType: StoryboardResourceType {
    associatedtype InitialController
}

final class Storyboard { }
