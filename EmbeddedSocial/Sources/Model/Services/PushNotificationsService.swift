//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import UIKit

class PushNotificationsService: BaseService {
    func updateDeviceToken(deviceToken: String) {
        let request = PutPushRegistrationRequest()
        request.language = "eu"
        request.lastUpdatedTime = Date().ISOString
        PushNotificationsAPI.myPushRegistrationsPutPushRegistration(platform: .ios, registrationId: deviceToken, request: request, authorization: authorization) { (object, error) in
            print(error.debugDescription)
        }
    }
}
