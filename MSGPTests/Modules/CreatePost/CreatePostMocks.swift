//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

@testable import MSGP

class MockCreatePostInteractor: CreatePostInteractor, Cuckoo.Mock {
    typealias MocksType = CreatePostInteractor
    typealias Stubbing = __StubbingProxy_CreatePostInteractor
    typealias Verification = __VerificationProxy_CreatePostInteractor
    let cuckoo_manager = Cuckoo.MockManager()
    
    private var observed: CreatePostInteractor?
    
    func spy(on victim: CreatePostInteractor) -> Self {
        observed = victim
        return self
    }
    
    
    // ["name": "output", "accesibility": "", "@type": "InstanceVariable", "type": "CreatePostInteractorOutput!", "isReadOnly": false]
    override var output: CreatePostInteractorOutput! {
        get {
            return cuckoo_manager.getter("output", original: observed.map { o in return { () -> CreatePostInteractorOutput! in o.output }})
        }
        
        set {
            cuckoo_manager.setter("output", value: newValue, original: observed != nil ? { self.observed?.output = $0 } : nil)
        }
        
    }
    
    
    
    
    var image: UIImage?
    var title: String?
    var body: String?
    
    override func postTopic(image: UIImage?, title: String?, body: String!)  {
        self.image = image
        self.title = title
        self.body = body
        return cuckoo_manager.call("postTopic(image: UIImage?, title: String?, body: String!)",
                                   parameters: (image, title, body),
                                   original: observed.map { o in
                                    return { (image: UIImage?, title: String?, body: String!) in
                                        o.postTopic(image: image, title: title, body: body)
                                    }
        })
        
    }
    
    override func sendRequest(request: PostTopicRequest)  {
        
        return cuckoo_manager.call("sendRequest(request: PostTopicRequest)",
                                   parameters: (request),
                                   original: observed.map { o in
                                    return { (request: PostTopicRequest) in
                                        o.sendRequest(request: request)
                                    }
        })
        
    }
    
    
    struct __StubbingProxy_CreatePostInteractor: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        
        init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        var output: Cuckoo.ToBeStubbedProperty<CreatePostInteractorOutput?> {
            return .init(manager: cuckoo_manager, name: "output")
        }
        
        
        func postTopic<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable, M3: Cuckoo.Matchable>(image: M1, title: M2, body: M3) -> Cuckoo.StubNoReturnFunction<(UIImage?, String?, String?)> where M1.MatchedType == UIImage?, M2.MatchedType == String?, M3.MatchedType == String? {
            let matchers: [Cuckoo.ParameterMatcher<(UIImage?, String?, String?)>] = [wrap(matchable: image) { $0.0 }, wrap(matchable: title) { $0.1 }, wrap(matchable: body) { $0.2 }]
            return .init(stub: cuckoo_manager.createStub("postTopic(image: UIImage?, title: String?, body: String!)", parameterMatchers: matchers))
        }
        
        func sendRequest<M1: Cuckoo.Matchable>(request: M1) -> Cuckoo.StubNoReturnFunction<(PostTopicRequest)> where M1.MatchedType == PostTopicRequest {
            let matchers: [Cuckoo.ParameterMatcher<(PostTopicRequest)>] = [wrap(matchable: request) { $0 }]
            return .init(stub: cuckoo_manager.createStub("sendRequest(request: PostTopicRequest)", parameterMatchers: matchers))
        }
        
    }
    
    
    struct __VerificationProxy_CreatePostInteractor: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
        
        init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
        
        
        var output: Cuckoo.VerifyProperty<CreatePostInteractorOutput?> {
            return .init(manager: cuckoo_manager, name: "output", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        
        
        @discardableResult
        func postTopic<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable, M3: Cuckoo.Matchable>(image: M1, title: M2, body: M3) -> Cuckoo.__DoNotUse<Void> where M1.MatchedType == UIImage?, M2.MatchedType == String?, M3.MatchedType == String? {
            let matchers: [Cuckoo.ParameterMatcher<(UIImage?, String?, String?)>] = [wrap(matchable: image) { $0.0 }, wrap(matchable: title) { $0.1 }, wrap(matchable: body) { $0.2 }]
            return cuckoo_manager.verify("postTopic(image: UIImage?, title: String?, body: String!)", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        @discardableResult
        func sendRequest<M1: Cuckoo.Matchable>(request: M1) -> Cuckoo.__DoNotUse<Void> where M1.MatchedType == PostTopicRequest {
            let matchers: [Cuckoo.ParameterMatcher<(PostTopicRequest)>] = [wrap(matchable: request) { $0 }]
            return cuckoo_manager.verify("sendRequest(request: PostTopicRequest)", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
    }
    
    
}

class CreatePostInteractorStub: CreatePostInteractor {
    
    override var output: CreatePostInteractorOutput! {
        get {
            return DefaultValueRegistry.defaultValue(for: (CreatePostInteractorOutput!).self)
        }
        
        set { }
        
    }
    
    
    
    
    
    override func postTopic(image: UIImage?, title: String?, body: String!)  {
        return DefaultValueRegistry.defaultValue(for: Void.self)
    }
    
    override func sendRequest(request: PostTopicRequest)  {
        return DefaultValueRegistry.defaultValue(for: Void.self)
    }
    
}




// MARK: - Mocks generated from file: MSGP/Sources/Modules/CreatePost/View/CreatePostViewInput.swift at 2017-07-17 11:30:54 +0000

//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Cuckoo
@testable import MSGP

class MockCreatePostViewInput: CreatePostViewInput, Cuckoo.Mock {
    typealias MocksType = CreatePostViewInput
    typealias Stubbing = __StubbingProxy_CreatePostViewInput
    typealias Verification = __VerificationProxy_CreatePostViewInput
    let cuckoo_manager = Cuckoo.MockManager()
    
    private var observed: CreatePostViewInput?
    
    func spy(on victim: CreatePostViewInput) -> Self {
        observed = victim
        return self
    }
    
    
    
    
    
    
    func setupInitialState()  {
        
        return cuckoo_manager.call("setupInitialState()",
                                   parameters: (),
                                   original: observed.map { o in
                                    return { () in
                                        o.setupInitialState()
                                    }
        })
        
    }
    
    func showError(error: Error)  {
        
        return cuckoo_manager.call("showError(error: Error)",
                                   parameters: (error),
                                   original: observed.map { o in
                                    return { (error: Error) in
                                        o.showError(error: error)
                                    }
        })
        
    }
    
    
    struct __StubbingProxy_CreatePostViewInput: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        
        init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        
        func setupInitialState() -> Cuckoo.StubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub("setupInitialState()", parameterMatchers: matchers))
        }
        
        func showError<M1: Cuckoo.Matchable>(error: M1) -> Cuckoo.StubNoReturnFunction<(Error)> where M1.MatchedType == Error {
            let matchers: [Cuckoo.ParameterMatcher<(Error)>] = [wrap(matchable: error) { $0 }]
            return .init(stub: cuckoo_manager.createStub("showError(error: Error)", parameterMatchers: matchers))
        }
        
    }
    
    
    struct __VerificationProxy_CreatePostViewInput: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
        
        init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
        
        
        
        
        @discardableResult
        func setupInitialState() -> Cuckoo.__DoNotUse<Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify("setupInitialState()", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        @discardableResult
        func showError<M1: Cuckoo.Matchable>(error: M1) -> Cuckoo.__DoNotUse<Void> where M1.MatchedType == Error {
            let matchers: [Cuckoo.ParameterMatcher<(Error)>] = [wrap(matchable: error) { $0 }]
            return cuckoo_manager.verify("showError(error: Error)", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
    }
    
    
}

class CreatePostViewInputStub: CreatePostViewInput {
    
    
    
    
    
    func setupInitialState()  {
        return DefaultValueRegistry.defaultValue(for: Void.self)
    }
    
    func showError(error: Error)  {
        return DefaultValueRegistry.defaultValue(for: Void.self)
    }
    
}




// MARK: - Mocks generated from file: MSGP/Sources/Modules/CreatePost/Interactor/CreatePostInteractorInput.swift at 2017-07-17 11:30:54 +0000

//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Cuckoo
@testable import MSGP

import Foundation

class MockCreatePostInteractorInput: CreatePostInteractorInput, Cuckoo.Mock {
    typealias MocksType = CreatePostInteractorInput
    typealias Stubbing = __StubbingProxy_CreatePostInteractorInput
    typealias Verification = __VerificationProxy_CreatePostInteractorInput
    let cuckoo_manager = Cuckoo.MockManager()
    
    private var observed: CreatePostInteractorInput?
    
    func spy(on victim: CreatePostInteractorInput) -> Self {
        observed = victim
        return self
    }
    
    
    
    
    
    
    func postTopic(image: UIImage?, title: String?, body: String!)  {
        
        return cuckoo_manager.call("postTopic(image: UIImage?, title: String?, body: String!)",
                                   parameters: (image, title, body),
                                   original: observed.map { o in
                                    return { (image: UIImage?, title: String?, body: String!) in
                                        o.postTopic(image: image, title: title, body: body)
                                    }
        })
        
    }
    
    
    struct __StubbingProxy_CreatePostInteractorInput: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        
        init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        
        func postTopic<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable, M3: Cuckoo.Matchable>(image: M1, title: M2, body: M3) -> Cuckoo.StubNoReturnFunction<(UIImage?, String?, String?)> where M1.MatchedType == UIImage?, M2.MatchedType == String?, M3.MatchedType == String? {
            let matchers: [Cuckoo.ParameterMatcher<(UIImage?, String?, String?)>] = [wrap(matchable: image) { $0.0 }, wrap(matchable: title) { $0.1 }, wrap(matchable: body) { $0.2 }]
            return .init(stub: cuckoo_manager.createStub("postTopic(image: UIImage?, title: String?, body: String!)", parameterMatchers: matchers))
        }
        
    }
    
    
    struct __VerificationProxy_CreatePostInteractorInput: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
        
        init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
        
        
        
        
        @discardableResult
        func postTopic<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable, M3: Cuckoo.Matchable>(image: M1, title: M2, body: M3) -> Cuckoo.__DoNotUse<Void> where M1.MatchedType == UIImage?, M2.MatchedType == String?, M3.MatchedType == String? {
            let matchers: [Cuckoo.ParameterMatcher<(UIImage?, String?, String?)>] = [wrap(matchable: image) { $0.0 }, wrap(matchable: title) { $0.1 }, wrap(matchable: body) { $0.2 }]
            return cuckoo_manager.verify("postTopic(image: UIImage?, title: String?, body: String!)", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
    }
    
    
}

class CreatePostInteractorInputStub: CreatePostInteractorInput {
    
    
    
    
    
    func postTopic(image: UIImage?, title: String?, body: String!)  {
        return DefaultValueRegistry.defaultValue(for: Void.self)
    }
    
}




// MARK: - Mocks generated from file: MSGP/Sources/Modules/CreatePost/Interactor/CreatePostInteractorOutput.swift at 2017-07-17 11:30:54 +0000

//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Cuckoo
@testable import MSGP

import Foundation

class MockCreatePostInteractorOutput: CreatePostInteractorOutput, Cuckoo.Mock {
    typealias MocksType = CreatePostInteractorOutput
    typealias Stubbing = __StubbingProxy_CreatePostInteractorOutput
    typealias Verification = __VerificationProxy_CreatePostInteractorOutput
    let cuckoo_manager = Cuckoo.MockManager()
    
    private var observed: CreatePostInteractorOutput?
    
    func spy(on victim: CreatePostInteractorOutput) -> Self {
        observed = victim
        return self
    }
    
    
    
    
    
    
    func created(post: PostTopicResponse)  {
        
        return cuckoo_manager.call("created(post: PostTopicResponse)",
                                   parameters: (post),
                                   original: observed.map { o in
                                    return { (post: PostTopicResponse) in
                                        o.created(post: post)
                                    }
        })
        
    }
    
    func postCreationFailed(error: Error)  {
        
        return cuckoo_manager.call("postCreationFailed(error: Error)",
                                   parameters: (error),
                                   original: observed.map { o in
                                    return { (error: Error) in
                                        o.postCreationFailed(error: error)
                                    }
        })
        
    }
    
    
    struct __StubbingProxy_CreatePostInteractorOutput: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        
        init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        
        func created<M1: Cuckoo.Matchable>(post: M1) -> Cuckoo.StubNoReturnFunction<(PostTopicResponse)> where M1.MatchedType == PostTopicResponse {
            let matchers: [Cuckoo.ParameterMatcher<(PostTopicResponse)>] = [wrap(matchable: post) { $0 }]
            return .init(stub: cuckoo_manager.createStub("created(post: PostTopicResponse)", parameterMatchers: matchers))
        }
        
        func postCreationFailed<M1: Cuckoo.Matchable>(error: M1) -> Cuckoo.StubNoReturnFunction<(Error)> where M1.MatchedType == Error {
            let matchers: [Cuckoo.ParameterMatcher<(Error)>] = [wrap(matchable: error) { $0 }]
            return .init(stub: cuckoo_manager.createStub("postCreationFailed(error: Error)", parameterMatchers: matchers))
        }
        
    }
    
    
    struct __VerificationProxy_CreatePostInteractorOutput: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
        
        init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
        
        
        
        
        @discardableResult
        func created<M1: Cuckoo.Matchable>(post: M1) -> Cuckoo.__DoNotUse<Void> where M1.MatchedType == PostTopicResponse {
            let matchers: [Cuckoo.ParameterMatcher<(PostTopicResponse)>] = [wrap(matchable: post) { $0 }]
            return cuckoo_manager.verify("created(post: PostTopicResponse)", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        @discardableResult
        func postCreationFailed<M1: Cuckoo.Matchable>(error: M1) -> Cuckoo.__DoNotUse<Void> where M1.MatchedType == Error {
            let matchers: [Cuckoo.ParameterMatcher<(Error)>] = [wrap(matchable: error) { $0 }]
            return cuckoo_manager.verify("postCreationFailed(error: Error)", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
    }
    
    
}

class CreatePostInteractorOutputStub: CreatePostInteractorOutput {
    
    
    
    
    
    func created(post: PostTopicResponse)  {
        return DefaultValueRegistry.defaultValue(for: Void.self)
    }
    
    func postCreationFailed(error: Error)  {
        return DefaultValueRegistry.defaultValue(for: Void.self)
    }
    
}




// MARK: - Mocks generated from file: MSGP/Sources/Modules/CreatePost/Presenter/CreatePostPresenter.swift at 2017-07-17 11:30:54 +0000

//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Cuckoo
@testable import MSGP

class MockCreatePostPresenter: CreatePostPresenter, Cuckoo.Mock {
    typealias MocksType = CreatePostPresenter
    typealias Stubbing = __StubbingProxy_CreatePostPresenter
    typealias Verification = __VerificationProxy_CreatePostPresenter
    let cuckoo_manager = Cuckoo.MockManager()
    
    private var observed: CreatePostPresenter?
    
    func spy(on victim: CreatePostPresenter) -> Self {
        observed = victim
        return self
    }
    
    
    // ["name": "view", "accesibility": "", "@type": "InstanceVariable", "type": "CreatePostViewInput!", "isReadOnly": false]
    override var view: CreatePostViewInput! {
        get {
            return cuckoo_manager.getter("view", original: observed.map { o in return { () -> CreatePostViewInput! in o.view }})
        }
        
        set {
            cuckoo_manager.setter("view", value: newValue, original: observed != nil ? { self.observed?.view = $0 } : nil)
        }
        
    }
    
    // ["name": "interactor", "accesibility": "", "@type": "InstanceVariable", "type": "CreatePostInteractorInput!", "isReadOnly": false]
    override var interactor: CreatePostInteractorInput! {
        get {
            return cuckoo_manager.getter("interactor", original: observed.map { o in return { () -> CreatePostInteractorInput! in o.interactor }})
        }
        
        set {
            cuckoo_manager.setter("interactor", value: newValue, original: observed != nil ? { self.observed?.interactor = $0 } : nil)
        }
        
    }
    
    // ["name": "router", "accesibility": "", "@type": "InstanceVariable", "type": "CreatePostRouterInput!", "isReadOnly": false]
    override var router: CreatePostRouterInput! {
        get {
            return cuckoo_manager.getter("router", original: observed.map { o in return { () -> CreatePostRouterInput! in o.router }})
        }
        
        set {
            cuckoo_manager.setter("router", value: newValue, original: observed != nil ? { self.observed?.router = $0 } : nil)
        }
        
    }
    
    
    
    
    
    override func viewIsReady()  {
        
        return cuckoo_manager.call("viewIsReady()",
                                   parameters: (),
                                   original: observed.map { o in
                                    return { () in
                                        o.viewIsReady()
                                    }
        })
        
    }
    
    override func post(image: UIImage?, title: String?, body: String!)  {
        
        return cuckoo_manager.call("post(image: UIImage?, title: String?, body: String!)",
                                   parameters: (image, title, body),
                                   original: observed.map { o in
                                    return { (image: UIImage?, title: String?, body: String!) in
                                        o.post(image: image, title: title, body: body)
                                    }
        })
        
    }
    
    override func back()  {
        
        return cuckoo_manager.call("back()",
                                   parameters: (),
                                   original: observed.map { o in
                                    return { () in
                                        o.back()
                                    }
        })
        
    }
    
    var postCreated = false
    override func created(post: PostTopicResponse)  {
        postCreated = true
        return cuckoo_manager.call("created(post: PostTopicResponse)",
                                   parameters: (post),
                                   original: observed.map { o in
                                    return { (post: PostTopicResponse) in
                                        o.created(post: post)
                                    }
        })
        
    }
    
    var postCreationFailed = false
    override func postCreationFailed(error: Error)  {
        postCreationFailed = true
        return cuckoo_manager.call("postCreationFailed(error: Error)",
                                   parameters: (error),
                                   original: observed.map { o in
                                    return { (error: Error) in
                                        o.postCreationFailed(error: error)
                                    }
        })
        
    }
    
    
    struct __StubbingProxy_CreatePostPresenter: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        
        init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        var view: Cuckoo.ToBeStubbedProperty<CreatePostViewInput?> {
            return .init(manager: cuckoo_manager, name: "view")
        }
        
        var interactor: Cuckoo.ToBeStubbedProperty<CreatePostInteractorInput?> {
            return .init(manager: cuckoo_manager, name: "interactor")
        }
        
        var router: Cuckoo.ToBeStubbedProperty<CreatePostRouterInput?> {
            return .init(manager: cuckoo_manager, name: "router")
        }
        
        
        func viewIsReady() -> Cuckoo.StubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub("viewIsReady()", parameterMatchers: matchers))
        }
        
        func post<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable, M3: Cuckoo.Matchable>(image: M1, title: M2, body: M3) -> Cuckoo.StubNoReturnFunction<(UIImage?, String?, String?)> where M1.MatchedType == UIImage?, M2.MatchedType == String?, M3.MatchedType == String? {
            let matchers: [Cuckoo.ParameterMatcher<(UIImage?, String?, String?)>] = [wrap(matchable: image) { $0.0 }, wrap(matchable: title) { $0.1 }, wrap(matchable: body) { $0.2 }]
            return .init(stub: cuckoo_manager.createStub("post(image: UIImage?, title: String?, body: String!)", parameterMatchers: matchers))
        }
        
        func back() -> Cuckoo.StubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub("back()", parameterMatchers: matchers))
        }
        
        func created<M1: Cuckoo.Matchable>(post: M1) -> Cuckoo.StubNoReturnFunction<(PostTopicResponse)> where M1.MatchedType == PostTopicResponse {
            let matchers: [Cuckoo.ParameterMatcher<(PostTopicResponse)>] = [wrap(matchable: post) { $0 }]
            return .init(stub: cuckoo_manager.createStub("created(post: PostTopicResponse)", parameterMatchers: matchers))
        }
        
        func postCreationFailed<M1: Cuckoo.Matchable>(error: M1) -> Cuckoo.StubNoReturnFunction<(Error)> where M1.MatchedType == Error {
            let matchers: [Cuckoo.ParameterMatcher<(Error)>] = [wrap(matchable: error) { $0 }]
            return .init(stub: cuckoo_manager.createStub("postCreationFailed(error: Error)", parameterMatchers: matchers))
        }
        
    }
    
    
    struct __VerificationProxy_CreatePostPresenter: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
        
        init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
        
        
        var view: Cuckoo.VerifyProperty<CreatePostViewInput?> {
            return .init(manager: cuckoo_manager, name: "view", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        var interactor: Cuckoo.VerifyProperty<CreatePostInteractorInput?> {
            return .init(manager: cuckoo_manager, name: "interactor", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        var router: Cuckoo.VerifyProperty<CreatePostRouterInput?> {
            return .init(manager: cuckoo_manager, name: "router", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        
        
        @discardableResult
        func viewIsReady() -> Cuckoo.__DoNotUse<Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify("viewIsReady()", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        @discardableResult
        func post<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable, M3: Cuckoo.Matchable>(image: M1, title: M2, body: M3) -> Cuckoo.__DoNotUse<Void> where M1.MatchedType == UIImage?, M2.MatchedType == String?, M3.MatchedType == String? {
            let matchers: [Cuckoo.ParameterMatcher<(UIImage?, String?, String?)>] = [wrap(matchable: image) { $0.0 }, wrap(matchable: title) { $0.1 }, wrap(matchable: body) { $0.2 }]
            return cuckoo_manager.verify("post(image: UIImage?, title: String?, body: String!)", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        @discardableResult
        func back() -> Cuckoo.__DoNotUse<Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify("back()", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        @discardableResult
        func created<M1: Cuckoo.Matchable>(post: M1) -> Cuckoo.__DoNotUse<Void> where M1.MatchedType == PostTopicResponse {
            let matchers: [Cuckoo.ParameterMatcher<(PostTopicResponse)>] = [wrap(matchable: post) { $0 }]
            return cuckoo_manager.verify("created(post: PostTopicResponse)", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        @discardableResult
        func postCreationFailed<M1: Cuckoo.Matchable>(error: M1) -> Cuckoo.__DoNotUse<Void> where M1.MatchedType == Error {
            let matchers: [Cuckoo.ParameterMatcher<(Error)>] = [wrap(matchable: error) { $0 }]
            return cuckoo_manager.verify("postCreationFailed(error: Error)", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
    }
    
    
}

class CreatePostPresenterStub: CreatePostPresenter {
    
    override var view: CreatePostViewInput! {
        get {
            return DefaultValueRegistry.defaultValue(for: (CreatePostViewInput!).self)
        }
        
        set { }
        
    }
    
    override var interactor: CreatePostInteractorInput! {
        get {
            return DefaultValueRegistry.defaultValue(for: (CreatePostInteractorInput!).self)
        }
        
        set { }
        
    }
    
    override var router: CreatePostRouterInput! {
        get {
            return DefaultValueRegistry.defaultValue(for: (CreatePostRouterInput!).self)
        }
        
        set { }
        
    }
    
    
    
    
    
    override func viewIsReady()  {
        return DefaultValueRegistry.defaultValue(for: Void.self)
    }
    
    override func post(image: UIImage?, title: String?, body: String!)  {
        return DefaultValueRegistry.defaultValue(for: Void.self)
    }
    
    override func back()  {
        return DefaultValueRegistry.defaultValue(for: Void.self)
    }
    
    override func created(post: PostTopicResponse)  {
        return DefaultValueRegistry.defaultValue(for: Void.self)
    }
    
    override func postCreationFailed(error: Error)  {
        return DefaultValueRegistry.defaultValue(for: Void.self)
    }
    
}




// MARK: - Mocks generated from file: MSGP/Sources/Modules/CreatePost/Presenter/CreatePostModuleInput.swift at 2017-07-17 11:30:54 +0000

//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Cuckoo
@testable import MSGP

class MockCreatePostModuleInput: CreatePostModuleInput, Cuckoo.Mock {
    typealias MocksType = CreatePostModuleInput
    typealias Stubbing = __StubbingProxy_CreatePostModuleInput
    typealias Verification = __VerificationProxy_CreatePostModuleInput
    let cuckoo_manager = Cuckoo.MockManager()
    
    private var observed: CreatePostModuleInput?
    
    func spy(on victim: CreatePostModuleInput) -> Self {
        observed = victim
        return self
    }
    
    
    
    
    
    
    
    struct __StubbingProxy_CreatePostModuleInput: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        
        init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        
    }
    
    
    struct __VerificationProxy_CreatePostModuleInput: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
        
        init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
        
        
        
        
    }
    
    
}

class CreatePostModuleInputStub: CreatePostModuleInput {
    
    
    
    
    
}




// MARK: - Mocks generated from file: MSGP/Sources/Modules/CreatePost/View/CreatePostViewOutput.swift at 2017-07-17 11:30:54 +0000

//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Cuckoo
@testable import MSGP

import UIKit

class MockCreatePostViewOutput: CreatePostViewOutput, Cuckoo.Mock {
    typealias MocksType = CreatePostViewOutput
    typealias Stubbing = __StubbingProxy_CreatePostViewOutput
    typealias Verification = __VerificationProxy_CreatePostViewOutput
    let cuckoo_manager = Cuckoo.MockManager()
    
    private var observed: CreatePostViewOutput?
    
    func spy(on victim: CreatePostViewOutput) -> Self {
        observed = victim
        return self
    }
    
    
    
    
    
    
    func viewIsReady()  {
        
        return cuckoo_manager.call("viewIsReady()",
                                   parameters: (),
                                   original: observed.map { o in
                                    return { () in
                                        o.viewIsReady()
                                    }
        })
        
    }
    
    func post(image: UIImage?, title: String?, body: String!)  {
        
        return cuckoo_manager.call("post(image: UIImage?, title: String?, body: String!)",
                                   parameters: (image, title, body),
                                   original: observed.map { o in
                                    return { (image: UIImage?, title: String?, body: String!) in
                                        o.post(image: image, title: title, body: body)
                                    }
        })
        
    }
    
    func back()  {
        
        return cuckoo_manager.call("back()",
                                   parameters: (),
                                   original: observed.map { o in
                                    return { () in
                                        o.back()
                                    }
        })
        
    }
    
    
    struct __StubbingProxy_CreatePostViewOutput: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        
        init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        
        func viewIsReady() -> Cuckoo.StubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub("viewIsReady()", parameterMatchers: matchers))
        }
        
        func post<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable, M3: Cuckoo.Matchable>(image: M1, title: M2, body: M3) -> Cuckoo.StubNoReturnFunction<(UIImage?, String?, String?)> where M1.MatchedType == UIImage?, M2.MatchedType == String?, M3.MatchedType == String? {
            let matchers: [Cuckoo.ParameterMatcher<(UIImage?, String?, String?)>] = [wrap(matchable: image) { $0.0 }, wrap(matchable: title) { $0.1 }, wrap(matchable: body) { $0.2 }]
            return .init(stub: cuckoo_manager.createStub("post(image: UIImage?, title: String?, body: String!)", parameterMatchers: matchers))
        }
        
        func back() -> Cuckoo.StubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub("back()", parameterMatchers: matchers))
        }
        
    }
    
    
    struct __VerificationProxy_CreatePostViewOutput: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
        
        init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
        
        
        
        
        @discardableResult
        func viewIsReady() -> Cuckoo.__DoNotUse<Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify("viewIsReady()", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        @discardableResult
        func post<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable, M3: Cuckoo.Matchable>(image: M1, title: M2, body: M3) -> Cuckoo.__DoNotUse<Void> where M1.MatchedType == UIImage?, M2.MatchedType == String?, M3.MatchedType == String? {
            let matchers: [Cuckoo.ParameterMatcher<(UIImage?, String?, String?)>] = [wrap(matchable: image) { $0.0 }, wrap(matchable: title) { $0.1 }, wrap(matchable: body) { $0.2 }]
            return cuckoo_manager.verify("post(image: UIImage?, title: String?, body: String!)", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        @discardableResult
        func back() -> Cuckoo.__DoNotUse<Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify("back()", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
    }
    
    
}

class CreatePostViewOutputStub: CreatePostViewOutput {
    
    
    
    
    
    func viewIsReady()  {
        return DefaultValueRegistry.defaultValue(for: Void.self)
    }
    
    func post(image: UIImage?, title: String?, body: String!)  {
        return DefaultValueRegistry.defaultValue(for: Void.self)
    }
    
    func back()  {
        return DefaultValueRegistry.defaultValue(for: Void.self)
    }
    
}




// MARK: - Mocks generated from file: MSGP/Sources/Modules/CreatePost/View/CreatePostViewController.swift at 2017-07-17 11:30:54 +0000

//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Cuckoo
@testable import MSGP

import UIKit

class MockCreatePostViewController: CreatePostViewController, Cuckoo.Mock {
    typealias MocksType = CreatePostViewController
    typealias Stubbing = __StubbingProxy_CreatePostViewController
    typealias Verification = __VerificationProxy_CreatePostViewController
    let cuckoo_manager = Cuckoo.MockManager()
    
    private var observed: CreatePostViewController?
    
    func spy(on victim: CreatePostViewController) -> Self {
        observed = victim
        return self
    }
    
    
    // ["name": "output", "accesibility": "", "@type": "InstanceVariable", "type": "CreatePostViewOutput!", "isReadOnly": false]
    override var output: CreatePostViewOutput! {
        get {
            return cuckoo_manager.getter("output", original: observed.map { o in return { () -> CreatePostViewOutput! in o.output }})
        }
        
        set {
            cuckoo_manager.setter("output", value: newValue, original: observed != nil ? { self.observed?.output = $0 } : nil)
        }
        
    }
    
    
    
    
    
    override func viewDidLoad()  {
        
        return cuckoo_manager.call("viewDidLoad()",
                                   parameters: (),
                                   original: observed.map { o in
                                    return { () in
                                        o.viewDidLoad()
                                    }
        })
        
    }
    
    override func setupInitialState()  {
        
        return cuckoo_manager.call("setupInitialState()",
                                   parameters: (),
                                   original: observed.map { o in
                                    return { () in
                                        o.setupInitialState()
                                    }
        })
        
    }
    
    
    var errorWasShowed = false
    override func showError(error: Error)  {
        errorWasShowed = true
        return cuckoo_manager.call("showError(error: Error)",
                                   parameters: (error),
                                   original: observed.map { o in
                                    return { (error: Error) in
                                        o.showError(error: error)
                                    }
        })
        
    }
    
    
    struct __StubbingProxy_CreatePostViewController: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        
        init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        var output: Cuckoo.ToBeStubbedProperty<CreatePostViewOutput?> {
            return .init(manager: cuckoo_manager, name: "output")
        }
        
        
        func viewDidLoad() -> Cuckoo.StubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub("viewDidLoad()", parameterMatchers: matchers))
        }
        
        func setupInitialState() -> Cuckoo.StubNoReturnFunction<()> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub("setupInitialState()", parameterMatchers: matchers))
        }
        
        func showError<M1: Cuckoo.Matchable>(error: M1) -> Cuckoo.StubNoReturnFunction<(Error)> where M1.MatchedType == Error {
            let matchers: [Cuckoo.ParameterMatcher<(Error)>] = [wrap(matchable: error) { $0 }]
            return .init(stub: cuckoo_manager.createStub("showError(error: Error)", parameterMatchers: matchers))
        }
        
    }
    
    
    struct __VerificationProxy_CreatePostViewController: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
        
        init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
        
        
        var output: Cuckoo.VerifyProperty<CreatePostViewOutput?> {
            return .init(manager: cuckoo_manager, name: "output", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        
        
        @discardableResult
        func viewDidLoad() -> Cuckoo.__DoNotUse<Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify("viewDidLoad()", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        @discardableResult
        func setupInitialState() -> Cuckoo.__DoNotUse<Void> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify("setupInitialState()", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        @discardableResult
        func showError<M1: Cuckoo.Matchable>(error: M1) -> Cuckoo.__DoNotUse<Void> where M1.MatchedType == Error {
            let matchers: [Cuckoo.ParameterMatcher<(Error)>] = [wrap(matchable: error) { $0 }]
            return cuckoo_manager.verify("showError(error: Error)", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
    }
    
    
}

class CreatePostViewControllerStub: CreatePostViewController {
    
    override var output: CreatePostViewOutput! {
        get {
            return DefaultValueRegistry.defaultValue(for: (CreatePostViewOutput!).self)
        }
        
        set { }
        
    }
    
    
    
    
    
    override func viewDidLoad()  {
        return DefaultValueRegistry.defaultValue(for: Void.self)
    }
    
    override func setupInitialState()  {
        return DefaultValueRegistry.defaultValue(for: Void.self)
    }
    
    override func showError(error: Error)  {
        return DefaultValueRegistry.defaultValue(for: Void.self)
    }
    
}



