//
//  Config.swift
//  MSGP
//
//  Created by Akvelon on 7/18/17.
//  Copyright © 2017 Akvelon. All rights reserved.
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
