//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

protocol TopicsFeedApplicableCommand {
    func apply(to feed: inout FeedFetchResult)
}

protocol SingleTopicApplicableCommand {
    func apply(to topic: inout Post)
}
