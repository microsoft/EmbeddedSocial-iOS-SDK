//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Alamofire



open class NotificationsAPI: APIBase {
    /**
     Get my notifications
     
     - parameter cursor: (query) Current read cursor (optional)
     - parameter limit: (query) Number of items to return (optional)
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func myNotificationsGetNotifications(cursor: String? = nil, limit: Int32? = nil, completion: @escaping ((_ data: FeedResponseActivityView?,_ error: Error?) -> Void)) {
        myNotificationsGetNotificationsWithRequestBuilder(cursor: cursor, limit: limit).execute { (response, error) -> Void in
            completion(response?.body, error);
        }
    }


    /**
     Get my notifications
     - GET /v0.6/users/me/notifications
     - This gets a feed of activities.              This feed is time ordered, with the most recent activity first.              An activity is added to this feed when any user other than myself does one of the following 6 actions:              (a) creates a comment to my topic; (b) creates a reply to my comment; (c) likes my topic; (d) follows me;              (e) requests to follow me when I'm a private user; (f) accepts my request to follow them when they are a private user.              Each activity has an unread status, which is controlled by doing a PUT on the status API call.              If a user that performed the activity is deleted, then that activity will no longer appear in this feed.              If an activity is performed on content that is then deleted, that activity will no longer appear in this feed.              If a user has un-done an activity (e.g. unlike a previous like), then that activity will no longer appear in this feed.              When activityType is Like, the activityHandle is the likeHandle that uniquely identifies the new like.              When activityType is Comment, the activityHandle is the commentHandle that uniquely identifies the new comment.              When activityType is Reply, the activityHandle is the replyHandle that uniquely identifies the new reply.              ActivityType values of CommentPeer and ReplyPeer are currently not used.              When activityType is Following or FollowRequest or FollowAccept, the activityHandle is the relationshipHandle              that uniquely identifies the relationship between the two users.
     - examples: [{contentType=application/json, example={
  "cursor" : "aeiou",
  "data" : [ {
    "actedOnUser" : "",
    "app" : {
      "deepLink" : "aeiou",
      "name" : "aeiou",
      "platformType" : "aeiou",
      "iconUrl" : "aeiou",
      "iconHandle" : "aeiou",
      "storeLink" : "aeiou"
    },
    "actorUsers" : [ {
      "userHandle" : "aeiou",
      "firstName" : "aeiou",
      "lastName" : "aeiou",
      "photoUrl" : "aeiou",
      "followerStatus" : "aeiou",
      "visibility" : "aeiou",
      "photoHandle" : "aeiou"
    } ],
    "actedOnContent" : {
      "rootHandle" : "aeiou",
      "contentHandle" : "aeiou",
      "blobUrl" : "aeiou",
      "text" : "aeiou",
      "blobType" : "aeiou",
      "contentType" : "aeiou",
      "parentHandle" : "aeiou",
      "blobHandle" : "aeiou"
    },
    "unread" : true,
    "activityHandle" : "aeiou",
    "createdTime" : "2000-01-23T04:56:07.000+00:00",
    "activityType" : "aeiou",
    "totalActions" : 123
  } ]
}}, {contentType=application/xml, example=<null>
  <cursor>string</cursor>
</null>}]
     - examples: [{contentType=application/json, example={
  "cursor" : "aeiou",
  "data" : [ {
    "actedOnUser" : "",
    "app" : {
      "deepLink" : "aeiou",
      "name" : "aeiou",
      "platformType" : "aeiou",
      "iconUrl" : "aeiou",
      "iconHandle" : "aeiou",
      "storeLink" : "aeiou"
    },
    "actorUsers" : [ {
      "userHandle" : "aeiou",
      "firstName" : "aeiou",
      "lastName" : "aeiou",
      "photoUrl" : "aeiou",
      "followerStatus" : "aeiou",
      "visibility" : "aeiou",
      "photoHandle" : "aeiou"
    } ],
    "actedOnContent" : {
      "rootHandle" : "aeiou",
      "contentHandle" : "aeiou",
      "blobUrl" : "aeiou",
      "text" : "aeiou",
      "blobType" : "aeiou",
      "contentType" : "aeiou",
      "parentHandle" : "aeiou",
      "blobHandle" : "aeiou"
    },
    "unread" : true,
    "activityHandle" : "aeiou",
    "createdTime" : "2000-01-23T04:56:07.000+00:00",
    "activityType" : "aeiou",
    "totalActions" : 123
  } ]
}}, {contentType=application/xml, example=<null>
  <cursor>string</cursor>
</null>}]
     
     - parameter cursor: (query) Current read cursor (optional)
     - parameter limit: (query) Number of items to return (optional)

     - returns: RequestBuilder<FeedResponseActivityView> 
     */
    open class func myNotificationsGetNotificationsWithRequestBuilder(cursor: String? = nil, limit: Int32? = nil) -> RequestBuilder<FeedResponseActivityView> {
        let path = "/v0.6/users/me/notifications"
        let URLString = EmbeddedSocialClientAPI.basePath + path

        let nillableParameters: [String:Any?] = [
            "cursor": cursor,
            "limit": limit?.encodeToJSON()
        ]
 
        let parameters = APIHelper.rejectNil(nillableParameters)
 
        let convertedParameters = APIHelper.convertBoolToString(parameters)
 
        let requestBuilder: RequestBuilder<FeedResponseActivityView>.Type = EmbeddedSocialClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: URLString, parameters: convertedParameters, isBody: false)
    }

    /**
     Get unread notifications count
     
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func myNotificationsGetNotificationsCount(completion: @escaping ((_ data: CountResponse?,_ error: Error?) -> Void)) {
        myNotificationsGetNotificationsCountWithRequestBuilder().execute { (response, error) -> Void in
            completion(response?.body, error);
        }
    }


    /**
     Get unread notifications count
     - GET /v0.6/users/me/notifications/count
     - This returns a count of activities in my notification feed that have an unread status of true.
     - examples: [{contentType=application/json, example={
  "count" : 123456789
}}, {contentType=application/xml, example=<null>
  <count>123456</count>
</null>}]
     - examples: [{contentType=application/json, example={
  "count" : 123456789
}}, {contentType=application/xml, example=<null>
  <count>123456</count>
</null>}]

     - returns: RequestBuilder<CountResponse> 
     */
    open class func myNotificationsGetNotificationsCountWithRequestBuilder() -> RequestBuilder<CountResponse> {
        let path = "/v0.6/users/me/notifications/count"
        let URLString = EmbeddedSocialClientAPI.basePath + path

        let nillableParameters: [String:Any?] = [:]
 
        let parameters = APIHelper.rejectNil(nillableParameters)
 
        let convertedParameters = APIHelper.convertBoolToString(parameters)
 
        let requestBuilder: RequestBuilder<CountResponse>.Type = EmbeddedSocialClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: URLString, parameters: convertedParameters, isBody: true)
    }

    /**
     Update notifications status
     
     - parameter request: (body) Put notifications status request 
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func myNotificationsPutNotificationsStatus(request: PutNotificationsStatusRequest, completion: @escaping ((_ data: Object?,_ error: Error?) -> Void)) {
        myNotificationsPutNotificationsStatusWithRequestBuilder(request: request).execute { (response, error) -> Void in
            completion(response?.body, error);
        }
    }


    /**
     Update notifications status
     - PUT /v0.6/users/me/notifications/status
     - This API call records the most recent notification that the user has read (or seen).              In the GET notifications API call, each notification will have an unread status.              Any notifications that are newer than this ReadActivityHandle will have an unread status of true.              Any notifications that correspond to this ReadActivityHandle or older will have an unread status of false.              If this API call has never been made, then all notifications will have an unread status of true.
     - examples: [{contentType=application/json, example={ }}, {contentType=application/xml, example=<null>
</null>}]
     - examples: [{contentType=application/json, example={ }}, {contentType=application/xml, example=<null>
</null>}]
     
     - parameter request: (body) Put notifications status request 

     - returns: RequestBuilder<Object> 
     */
    open class func myNotificationsPutNotificationsStatusWithRequestBuilder(request: PutNotificationsStatusRequest) -> RequestBuilder<Object> {
        let path = "/v0.6/users/me/notifications/status"
        let URLString = EmbeddedSocialClientAPI.basePath + path
        let parameters = request.encodeToJSON() as? [String:AnyObject]
 
        let convertedParameters = APIHelper.convertBoolToString(parameters)
 
        let requestBuilder: RequestBuilder<Object>.Type = EmbeddedSocialClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "PUT", URLString: URLString, parameters: convertedParameters, isBody: true)
    }

}
