//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import UIKit

protocol PostDetailRouterInput {
    func backIfNeeded(from view: UIViewController)
    func backToFeed(from view: UIViewController)
}
