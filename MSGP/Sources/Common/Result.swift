//
//  Result.swift
//  GymKeeper
//
//  Created by Vadim Bulavin on 5/24/17.
//  Copyright © 2017 V8tr. All rights reserved.
//

import Foundation

public enum Result<Value> {
    case success(Value)
    case failure(Error)
    
    public var isSuccess: Bool {
        switch self {
        case .success:
            return true
        case .failure:
            return false
        }
    }
    
    public var isFailure: Bool {
        return !isSuccess
    }
    
    public var value: Value? {
        switch self {
        case let .success(value):
            return value
        case .failure:
            return nil
        }
    }
    
    public var error: Error? {
        switch self {
        case .success:
            return nil
        case let .failure(error):
            return error
        }
    }
    
    public init?(value: Value?, error: Error?) {
        if let value = value {
            self = .success(value)
        } else if let error = error {
            self = .failure(error)
        }
        
        return nil
    }
}
