//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Alamofire



open class SessionsAPI: APIBase {
    /**
     * enum for parameter identityProvider
     */
    public enum IdentityProvider_requestTokensGetRequestToken: String { 
        case facebook = "Facebook"
        case microsoft = "Microsoft"
        case google = "Google"
        case twitter = "Twitter"
        case aads2s = "AADS2S"
        case socialPlus = "SocialPlus"
    }

    /**
     Get request token
     
     - parameter identityProvider: (path) Identity provider type 
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func requestTokensGetRequestToken(identityProvider: IdentityProvider_requestTokensGetRequestToken, completion: @escaping ((_ data: GetRequestTokenResponse?,_ error: Error?) -> Void)) {
        requestTokensGetRequestTokenWithRequestBuilder(identityProvider: identityProvider).execute { (response, error) -> Void in
            completion(response?.body, error);
        }
    }


    /**
     Get request token
     - GET /v0.6/request_tokens/{identityProvider}
     - examples: [{contentType=application/json, example={
  "requestToken" : "aeiou"
}}, {contentType=application/xml, example=<null>
  <requestToken>string</requestToken>
</null>}]
     - examples: [{contentType=application/json, example={
  "requestToken" : "aeiou"
}}, {contentType=application/xml, example=<null>
  <requestToken>string</requestToken>
</null>}]
     
     - parameter identityProvider: (path) Identity provider type 

     - returns: RequestBuilder<GetRequestTokenResponse> 
     */
    open class func requestTokensGetRequestTokenWithRequestBuilder(identityProvider: IdentityProvider_requestTokensGetRequestToken) -> RequestBuilder<GetRequestTokenResponse> {
        var path = "/v0.6/request_tokens/{identityProvider}"
        path = path.replacingOccurrences(of: "{identityProvider}", with: "\(identityProvider.rawValue)", options: .literal, range: nil)
        let URLString = EmbeddedSocialClientAPI.basePath + path

        let nillableParameters: [String:Any?] = [:]
 
        let parameters = APIHelper.rejectNil(nillableParameters)
 
        let convertedParameters = APIHelper.convertBoolToString(parameters)
 
        let requestBuilder: RequestBuilder<GetRequestTokenResponse>.Type = EmbeddedSocialClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: URLString, parameters: convertedParameters, isBody: true)
    }

    /**
     Delete the current session (sign out)
     
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func sessionsDeleteSession(completion: @escaping ((_ data: Object?,_ error: Error?) -> Void)) {
        sessionsDeleteSessionWithRequestBuilder().execute { (response, error) -> Void in
            completion(response?.body, error);
        }
    }


    /**
     Delete the current session (sign out)
     - DELETE /v0.6/sessions/current
     - examples: [{contentType=application/json, example={ }}, {contentType=application/xml, example=<null>
</null>}]
     - examples: [{contentType=application/json, example={ }}, {contentType=application/xml, example=<null>
</null>}]

     - returns: RequestBuilder<Object> 
     */
    open class func sessionsDeleteSessionWithRequestBuilder() -> RequestBuilder<Object> {
        let path = "/v0.6/sessions/current"
        let URLString = EmbeddedSocialClientAPI.basePath + path

        let nillableParameters: [String:Any?] = [:]
 
        let parameters = APIHelper.rejectNil(nillableParameters)
 
        let convertedParameters = APIHelper.convertBoolToString(parameters)
 
        let requestBuilder: RequestBuilder<Object>.Type = EmbeddedSocialClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "DELETE", URLString: URLString, parameters: convertedParameters, isBody: true)
    }

    /**
     Create a new session (sign in)
     
     - parameter request: (body) Post session request 
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func sessionsPostSession(request: PostSessionRequest, completion: @escaping ((_ data: PostSessionResponse?,_ error: Error?) -> Void)) {
        sessionsPostSessionWithRequestBuilder(request: request).execute { (response, error) -> Void in
            completion(response?.body, error);
        }
    }


    /**
     Create a new session (sign in)
     - POST /v0.6/sessions
     - examples: [{contentType=application/json, example={
  "userHandle" : "aeiou",
  "sessionToken" : "aeiou"
}}, {contentType=application/xml, example=<null>
  <userHandle>string</userHandle>
  <sessionToken>string</sessionToken>
</null>}]
     - examples: [{contentType=application/json, example={
  "userHandle" : "aeiou",
  "sessionToken" : "aeiou"
}}, {contentType=application/xml, example=<null>
  <userHandle>string</userHandle>
  <sessionToken>string</sessionToken>
</null>}]
     
     - parameter request: (body) Post session request 

     - returns: RequestBuilder<PostSessionResponse> 
     */
    open class func sessionsPostSessionWithRequestBuilder(request: PostSessionRequest) -> RequestBuilder<PostSessionResponse> {
        let path = "/v0.6/sessions"
        let URLString = EmbeddedSocialClientAPI.basePath + path
        let parameters = request.encodeToJSON() as? [String:AnyObject]
 
        let convertedParameters = APIHelper.convertBoolToString(parameters)
 
        let requestBuilder: RequestBuilder<PostSessionResponse>.Type = EmbeddedSocialClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "POST", URLString: URLString, parameters: convertedParameters, isBody: true)
    }

}
