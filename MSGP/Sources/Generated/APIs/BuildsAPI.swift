//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Alamofire



open class BuildsAPI: APIBase {
    /**
     The build information for this service
     
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func buildsGetBuildsCurrent(completion: @escaping ((_ data: BuildsCurrentResponse?,_ error: Error?) -> Void)) {
        buildsGetBuildsCurrentWithRequestBuilder().execute { (response, error) -> Void in
            completion(response?.body, error);
        }
    }


    /**
     The build information for this service
     - GET /v0.6/builds/current
     - This API is meant to be called by humans for debugging
     - examples: [{contentType=application/json, example={
  "hostname" : "aeiou",
  "dateAndTime" : "aeiou",
  "serviceApiVersion" : "aeiou",
  "dirtyFiles" : [ "aeiou" ],
  "commitHash" : "aeiou"
}}, {contentType=application/xml, example=<null>
  <dateAndTime>string</dateAndTime>
  <commitHash>string</commitHash>
  <hostname>string</hostname>
  <serviceApiVersion>string</serviceApiVersion>
  <dirtyFiles>string</dirtyFiles>
</null>}]
     - examples: [{contentType=application/json, example={
  "hostname" : "aeiou",
  "dateAndTime" : "aeiou",
  "serviceApiVersion" : "aeiou",
  "dirtyFiles" : [ "aeiou" ],
  "commitHash" : "aeiou"
}}, {contentType=application/xml, example=<null>
  <dateAndTime>string</dateAndTime>
  <commitHash>string</commitHash>
  <hostname>string</hostname>
  <serviceApiVersion>string</serviceApiVersion>
  <dirtyFiles>string</dirtyFiles>
</null>}]

     - returns: RequestBuilder<BuildsCurrentResponse> 
     */
    open class func buildsGetBuildsCurrentWithRequestBuilder() -> RequestBuilder<BuildsCurrentResponse> {
        let path = "/v0.6/builds/current"
        let URLString = EmbeddedSocialClientAPI.basePath + path

        let nillableParameters: [String:Any?] = [:]
 
        let parameters = APIHelper.rejectNil(nillableParameters)
 
        let convertedParameters = APIHelper.convertBoolToString(parameters)
 
        let requestBuilder: RequestBuilder<BuildsCurrentResponse>.Type = EmbeddedSocialClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: URLString, parameters: convertedParameters, isBody: true)
    }

}
