//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import UIKit

public protocol EquatableWithinEpsilon: Strideable {
    static var epsilon: Self.Stride { get }
}

extension Float: EquatableWithinEpsilon {
    public static let epsilon: Float.Stride = 1e-8
}

extension Double: EquatableWithinEpsilon {
    public static let epsilon: Double.Stride = 1e-16
}

extension CGFloat: EquatableWithinEpsilon {
    public static let epsilon: CGFloat.Stride = 1e-16
}

func equalWithinEpsilon<T: EquatableWithinEpsilon>(_ lhs: T, _ rhs: T, epsilon: T.Stride) -> Bool {
    return abs(lhs - rhs) <= epsilon
}

infix operator ==~ : ComparisonPrecedence
public func ==~<T: EquatableWithinEpsilon>(lhs: T, rhs: T) -> Bool {
    return equalWithinEpsilon(lhs, rhs, epsilon: T.epsilon)
}

infix operator !==~ : ComparisonPrecedence
public func !==~<T: EquatableWithinEpsilon>(lhs: T, rhs: T) -> Bool {
    return !(lhs ==~ rhs)
}
