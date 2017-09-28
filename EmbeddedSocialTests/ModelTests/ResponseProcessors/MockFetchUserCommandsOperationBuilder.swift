//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

@testable import EmbeddedSocial

class MockFetchUserCommandsOperationBuilder: FetchUserCommandsOperationBuilderType {
    
    //MARK: - makeFetchUserCommandsOperation
    
    var makeFetchUserCommandsOperationCacheCalled = false
    var makeFetchUserCommandsOperationCacheReceivedCache: CacheType?
    var makeFetchUserCommandsOperationCacheReturnValue: FetchUserCommandsOperation!
    
    func makeFetchUserCommandsOperation(cache: CacheType) -> FetchUserCommandsOperation {
        makeFetchUserCommandsOperationCacheCalled = true
        makeFetchUserCommandsOperationCacheReceivedCache = cache
        return makeFetchUserCommandsOperationCacheReturnValue
    }
    
}
