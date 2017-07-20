//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Alamofire



open class ReportingAPI: APIBase {
    /**
     Report a comment as spam, offensive, etc.
     
     - parameter commentHandle: (path) Comment handle for the comment being reported on 
     - parameter postReportRequest: (body) Post report request 
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func commentReportsPostReport(commentHandle: String, postReportRequest: PostReportRequest, completion: @escaping ((_ data: Object?,_ error: Error?) -> Void)) {
        commentReportsPostReportWithRequestBuilder(commentHandle: commentHandle, postReportRequest: postReportRequest).execute { (response, error) -> Void in
            completion(response?.body, error);
        }
    }


    /**
     Report a comment as spam, offensive, etc.
     - POST /v0.6/comments/{commentHandle}/reports
     - examples: [{contentType=application/json, example={ }}, {contentType=application/xml, example=<null>
</null>}]
     - examples: [{contentType=application/json, example={ }}, {contentType=application/xml, example=<null>
</null>}]
     
     - parameter commentHandle: (path) Comment handle for the comment being reported on 
     - parameter postReportRequest: (body) Post report request 

     - returns: RequestBuilder<Object> 
     */
    open class func commentReportsPostReportWithRequestBuilder(commentHandle: String, postReportRequest: PostReportRequest) -> RequestBuilder<Object> {
        var path = "/v0.6/comments/{commentHandle}/reports"
        path = path.replacingOccurrences(of: "{commentHandle}", with: "\(commentHandle)", options: .literal, range: nil)
        let URLString = EmbeddedSocialClientAPI.basePath + path
        let parameters = postReportRequest.encodeToJSON() as? [String:AnyObject]
 
        let convertedParameters = APIHelper.convertBoolToString(parameters)
 
        let requestBuilder: RequestBuilder<Object>.Type = EmbeddedSocialClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "POST", URLString: URLString, parameters: convertedParameters, isBody: true)
    }

    /**
     Report a reply as spam, offensive, etc.
     
     - parameter replyHandle: (path) Reply handle for the reply being reported on 
     - parameter postReportRequest: (body) Post report request 
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func replyReportsPostReport(replyHandle: String, postReportRequest: PostReportRequest, completion: @escaping ((_ data: Object?,_ error: Error?) -> Void)) {
        replyReportsPostReportWithRequestBuilder(replyHandle: replyHandle, postReportRequest: postReportRequest).execute { (response, error) -> Void in
            completion(response?.body, error);
        }
    }


    /**
     Report a reply as spam, offensive, etc.
     - POST /v0.6/replies/{replyHandle}/reports
     - examples: [{contentType=application/json, example={ }}, {contentType=application/xml, example=<null>
</null>}]
     - examples: [{contentType=application/json, example={ }}, {contentType=application/xml, example=<null>
</null>}]
     
     - parameter replyHandle: (path) Reply handle for the reply being reported on 
     - parameter postReportRequest: (body) Post report request 

     - returns: RequestBuilder<Object> 
     */
    open class func replyReportsPostReportWithRequestBuilder(replyHandle: String, postReportRequest: PostReportRequest) -> RequestBuilder<Object> {
        var path = "/v0.6/replies/{replyHandle}/reports"
        path = path.replacingOccurrences(of: "{replyHandle}", with: "\(replyHandle)", options: .literal, range: nil)
        let URLString = EmbeddedSocialClientAPI.basePath + path
        let parameters = postReportRequest.encodeToJSON() as? [String:AnyObject]
 
        let convertedParameters = APIHelper.convertBoolToString(parameters)
 
        let requestBuilder: RequestBuilder<Object>.Type = EmbeddedSocialClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "POST", URLString: URLString, parameters: convertedParameters, isBody: true)
    }

    /**
     Report a topic as spam, offensive, etc.
     
     - parameter topicHandle: (path) Topic handle being reported on 
     - parameter postReportRequest: (body) Post report request 
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func topicReportsPostReport(topicHandle: String, postReportRequest: PostReportRequest, completion: @escaping ((_ data: Object?,_ error: Error?) -> Void)) {
        topicReportsPostReportWithRequestBuilder(topicHandle: topicHandle, postReportRequest: postReportRequest).execute { (response, error) -> Void in
            completion(response?.body, error);
        }
    }


    /**
     Report a topic as spam, offensive, etc.
     - POST /v0.6/topics/{topicHandle}/reports
     - examples: [{contentType=application/json, example={ }}, {contentType=application/xml, example=<null>
</null>}]
     - examples: [{contentType=application/json, example={ }}, {contentType=application/xml, example=<null>
</null>}]
     
     - parameter topicHandle: (path) Topic handle being reported on 
     - parameter postReportRequest: (body) Post report request 

     - returns: RequestBuilder<Object> 
     */
    open class func topicReportsPostReportWithRequestBuilder(topicHandle: String, postReportRequest: PostReportRequest) -> RequestBuilder<Object> {
        var path = "/v0.6/topics/{topicHandle}/reports"
        path = path.replacingOccurrences(of: "{topicHandle}", with: "\(topicHandle)", options: .literal, range: nil)
        let URLString = EmbeddedSocialClientAPI.basePath + path
        let parameters = postReportRequest.encodeToJSON() as? [String:AnyObject]
 
        let convertedParameters = APIHelper.convertBoolToString(parameters)
 
        let requestBuilder: RequestBuilder<Object>.Type = EmbeddedSocialClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "POST", URLString: URLString, parameters: convertedParameters, isBody: true)
    }

    /**
     Report a user as spam, offensive, etc.
     
     - parameter userHandle: (path) User handle being reported on 
     - parameter postReportRequest: (body) Post report request 
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func userReportsPostReport(userHandle: String, postReportRequest: PostReportRequest, completion: @escaping ((_ data: Object?,_ error: Error?) -> Void)) {
        userReportsPostReportWithRequestBuilder(userHandle: userHandle, postReportRequest: postReportRequest).execute { (response, error) -> Void in
            completion(response?.body, error);
        }
    }


    /**
     Report a user as spam, offensive, etc.
     - POST /v0.6/users/{userHandle}/reports
     - This call allows a user to complain about another user's profile content              (photo, bio, name) as containing spam, offensive material, etc.
     - examples: [{contentType=application/json, example={ }}, {contentType=application/xml, example=<null>
</null>}]
     - examples: [{contentType=application/json, example={ }}, {contentType=application/xml, example=<null>
</null>}]
     
     - parameter userHandle: (path) User handle being reported on 
     - parameter postReportRequest: (body) Post report request 

     - returns: RequestBuilder<Object> 
     */
    open class func userReportsPostReportWithRequestBuilder(userHandle: String, postReportRequest: PostReportRequest) -> RequestBuilder<Object> {
        var path = "/v0.6/users/{userHandle}/reports"
        path = path.replacingOccurrences(of: "{userHandle}", with: "\(userHandle)", options: .literal, range: nil)
        let URLString = EmbeddedSocialClientAPI.basePath + path
        let parameters = postReportRequest.encodeToJSON() as? [String:AnyObject]
 
        let convertedParameters = APIHelper.convertBoolToString(parameters)
 
        let requestBuilder: RequestBuilder<Object>.Type = EmbeddedSocialClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "POST", URLString: URLString, parameters: convertedParameters, isBody: true)
    }

}
