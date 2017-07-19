//
//  Validator.swift
//  MSGP
//
//  Created by Vadim Bulavin on 7/17/17.
//  Copyright © 2017 Akvelon. All rights reserved.
//

import Foundation

protocol Validator {
    associatedtype WrappedType
    static func validate(_ value: WrappedType) -> Bool
}

struct ValidatorError: Error, CustomStringConvertible {
    let wrapperValue: Any
    let validator: Any.Type
    
    var description: String {
        return "Value: '\(wrapperValue)' <\(type(of: (wrapperValue)))>, failed validation of Validator: \(validator.self)"
    }
}

struct Validated<WrapperType, V: Validator> where V.WrappedType == WrapperType {
    let value: WrapperType
    
    init(_ value: WrapperType) throws {
        guard V.validate(value) else {
            throw ValidatorError(wrapperValue: value, validator: V.self)
        }
        
        self.value = value
    }
    
    init?(value: WrapperType) {
        try? self.init(value)
    }
}

struct And<V1: Validator, V2: Validator>: Validator where V1.WrappedType == V2.WrappedType {
    static func validate(_ value: V1.WrappedType) -> Bool {
        return V1.validate(value) && V2.validate(value)
    }
}
// swiftlint:disable type_name
struct Or<V1: Validator, V2: Validator>: Validator where V1.WrappedType == V2.WrappedType {
    static func validate(_ value: V1.WrappedType) -> Bool {
        return V1.validate(value) || V2.validate(value)
    }
}

struct Not<V1: Validator>: Validator {
    static func validate(_ value: V1.WrappedType) -> Bool {
        return !V1.validate(value)
    }
}
