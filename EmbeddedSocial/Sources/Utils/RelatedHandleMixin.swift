//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

protocol RelatedHandleMixin: class {
    var relatedHandle: String { get set }
}

struct RelatedHandleMixinAssociationKeys {
    static fileprivate var relatedHandle: UInt8 = 0
}

extension RelatedHandleMixin {
    
    var relatedHandle: String {
        get {
            return associated(to: self, key: &RelatedHandleMixinAssociationKeys.relatedHandle) { UUID().uuidString }
        }
        set {
            associate(to: self, key: &RelatedHandleMixinAssociationKeys.relatedHandle, value: newValue)
        }
    }
}

extension RelatedHandleMixin where Self: Cacheable {
    func getRelatedHandle() -> String? {
        return relatedHandle
    }
    
    func setRelatedHandle(_ relatedHandle: String?) {
        if let relatedHandle = relatedHandle {
            self.relatedHandle = relatedHandle
        }
    }
}
