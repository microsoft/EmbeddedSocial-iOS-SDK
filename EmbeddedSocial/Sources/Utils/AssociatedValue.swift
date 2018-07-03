//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

final class Lifted<T> {
    let value: T
    init(_ x: T) {
        value = x
    }
}

private func lift<T>(_ x: T) -> Lifted<T>  {
    return Lifted(x)
}

func associated<T>(to base: Any,
                key: UnsafePointer<UInt8>,
                policy: objc_AssociationPolicy = .OBJC_ASSOCIATION_RETAIN,
                initialiser: () -> T) -> T {
    if let v = objc_getAssociatedObject(base, key) as? T {
        return v
    }
    
    if let v = objc_getAssociatedObject(base, key) as? Lifted<T> {
        return v.value
    }
    
    let lifted = Lifted(initialiser())
    objc_setAssociatedObject(base, key, lifted, policy)
    return lifted.value
}

func associate<T>(to base: Any, key: UnsafePointer<UInt8>, value: T, policy: objc_AssociationPolicy = .OBJC_ASSOCIATION_RETAIN) {
    if T.self is AnyClass {
        objc_setAssociatedObject(base, key, value, policy)
    }
    else {
        objc_setAssociatedObject(base, key, lift(value), policy)
    }
}
