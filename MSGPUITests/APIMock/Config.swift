//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

struct APIConfig {
    public static let delayedResponses = false
    // Dates don't matter as there is no additional filtering by date inside app
    public static let defaultReplacements = ["primaryFirstName": "John",
                                             "primaryLastName": "Doe",
                                             "primaryUserHandle": "JohnDoe",
                                             "visibility": "Public",
                                             "contentStatus": "Active",
                                             "Today": Date().ISOString,
                                             "ThisWeek": Date(timeIntervalSinceNow: -(24*60*60) - 1).ISOString,
                                             "ThisMonth": Date(timeIntervalSinceNow: -(24*60*60*30) - 1).ISOString,
                                             "AllTime": Date(timeIntervalSinceNow: -(24*60*60*365) - 1).ISOString]
}
