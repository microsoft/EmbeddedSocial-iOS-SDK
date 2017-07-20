//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Alamofire



open class PushNotificationsAPI: APIBase {
    /**
     * enum for parameter platform
     */
    public enum Platform_myPushRegistrationsDeletePushRegistration: String { 
        case windows = "Windows"
        case android = "Android"
        case ios = "IOS"
    }

    /**
     Unregister from push notifications
     
     - parameter platform: (path) Platform type 
     - parameter registrationId: (path) Unique registration ID provided by the mobile OS.              You must URL encode the registration ID.              For Android, this is the GCM registration ID.              For Windows, this is the PushNotificationChannel URI.              For iOS, this is the device token. 
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func myPushRegistrationsDeletePushRegistration(platform: Platform_myPushRegistrationsDeletePushRegistration, registrationId: String, completion: @escaping ((_ data: Object?,_ error: Error?) -> Void)) {
        myPushRegistrationsDeletePushRegistrationWithRequestBuilder(platform: platform, registrationId: registrationId).execute { (response, error) -> Void in
            completion(response?.body, error);
        }
    }


    /**
     Unregister from push notifications
     - DELETE /v0.6/users/me/push_registrations/{platform}/{registrationId}
     - examples: [{contentType=application/json, example={ }}, {contentType=application/xml, example=<null>
</null>}]
     - examples: [{contentType=application/json, example={ }}, {contentType=application/xml, example=<null>
</null>}]
     
     - parameter platform: (path) Platform type 
     - parameter registrationId: (path) Unique registration ID provided by the mobile OS.              You must URL encode the registration ID.              For Android, this is the GCM registration ID.              For Windows, this is the PushNotificationChannel URI.              For iOS, this is the device token. 

     - returns: RequestBuilder<Object> 
     */
    open class func myPushRegistrationsDeletePushRegistrationWithRequestBuilder(platform: Platform_myPushRegistrationsDeletePushRegistration, registrationId: String) -> RequestBuilder<Object> {
        var path = "/v0.6/users/me/push_registrations/{platform}/{registrationId}"
        path = path.replacingOccurrences(of: "{platform}", with: "\(platform.rawValue)", options: .literal, range: nil)
        path = path.replacingOccurrences(of: "{registrationId}", with: "\(registrationId)", options: .literal, range: nil)
        let URLString = EmbeddedSocialClientAPI.basePath + path

        let nillableParameters: [String:Any?] = [:]
 
        let parameters = APIHelper.rejectNil(nillableParameters)
 
        let convertedParameters = APIHelper.convertBoolToString(parameters)
 
        let requestBuilder: RequestBuilder<Object>.Type = EmbeddedSocialClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "DELETE", URLString: URLString, parameters: convertedParameters, isBody: true)
    }

    /**
     * enum for parameter platform
     */
    public enum Platform_myPushRegistrationsPutPushRegistration: String { 
        case windows = "Windows"
        case android = "Android"
        case ios = "IOS"
    }

    /**
     Register for push notifications or update an existing registration
     
     - parameter platform: (path) Platform type 
     - parameter registrationId: (path) Unique registration ID provided by the mobile OS.              You must URL encode the registration ID.              For Android, this is the GCM or FCM registration ID.              For Windows, this is the PushNotificationChannel URI.              For iOS, this is the device token. 
     - parameter request: (body) Put push registration request 
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func myPushRegistrationsPutPushRegistration(platform: Platform_myPushRegistrationsPutPushRegistration, registrationId: String, request: PutPushRegistrationRequest, completion: @escaping ((_ data: Object?,_ error: Error?) -> Void)) {
        myPushRegistrationsPutPushRegistrationWithRequestBuilder(platform: platform, registrationId: registrationId, request: request).execute { (response, error) -> Void in
            completion(response?.body, error);
        }
    }


    /**
     Register for push notifications or update an existing registration
     - PUT /v0.6/users/me/push_registrations/{platform}/{registrationId}
     - A push notification will be generated and sent for each activity in my              notifications feed where the unread status is true.              If multiple devices register for push notifications, then all those devices              will get push notifications.
     - examples: [{contentType=application/json, example={ }}, {contentType=application/xml, example=<null>
</null>}]
     - examples: [{contentType=application/json, example={ }}, {contentType=application/xml, example=<null>
</null>}]
     
     - parameter platform: (path) Platform type 
     - parameter registrationId: (path) Unique registration ID provided by the mobile OS.              You must URL encode the registration ID.              For Android, this is the GCM or FCM registration ID.              For Windows, this is the PushNotificationChannel URI.              For iOS, this is the device token. 
     - parameter request: (body) Put push registration request 

     - returns: RequestBuilder<Object> 
     */
    open class func myPushRegistrationsPutPushRegistrationWithRequestBuilder(platform: Platform_myPushRegistrationsPutPushRegistration, registrationId: String, request: PutPushRegistrationRequest) -> RequestBuilder<Object> {
        var path = "/v0.6/users/me/push_registrations/{platform}/{registrationId}"
        path = path.replacingOccurrences(of: "{platform}", with: "\(platform.rawValue)", options: .literal, range: nil)
        path = path.replacingOccurrences(of: "{registrationId}", with: "\(registrationId)", options: .literal, range: nil)
        let URLString = EmbeddedSocialClientAPI.basePath + path
        let parameters = request.encodeToJSON() as? [String:AnyObject]
 
        let convertedParameters = APIHelper.convertBoolToString(parameters)
 
        let requestBuilder: RequestBuilder<Object>.Type = EmbeddedSocialClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "PUT", URLString: URLString, parameters: convertedParameters, isBody: true)
    }

}
