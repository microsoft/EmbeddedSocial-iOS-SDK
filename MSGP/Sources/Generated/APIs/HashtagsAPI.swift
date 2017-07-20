//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Alamofire



open class HashtagsAPI: APIBase {
    /**
     Get autocompleted hashtags
     
     - parameter query: (query) Search query 
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func hashtagsGetAutocompletedHashtags(query: String, completion: @escaping ((_ data: [String]?,_ error: Error?) -> Void)) {
        hashtagsGetAutocompletedHashtagsWithRequestBuilder(query: query).execute { (response, error) -> Void in
            completion(response?.body, error);
        }
    }


    /**
     Get autocompleted hashtags
     - GET /v0.6/hashtags/autocomplete
     - The query string must be at least 3 characters long, and no more than 25 characters long.
     - examples: [{contentType=application/json, example=[ "aeiou" ]}, {contentType=application/xml, example=string}]
     - examples: [{contentType=application/json, example=[ "aeiou" ]}, {contentType=application/xml, example=string}]
     
     - parameter query: (query) Search query 

     - returns: RequestBuilder<[String]> 
     */
    open class func hashtagsGetAutocompletedHashtagsWithRequestBuilder(query: String) -> RequestBuilder<[String]> {
        let path = "/v0.6/hashtags/autocomplete"
        let URLString = EmbeddedSocialClientAPI.basePath + path

        let nillableParameters: [String:Any?] = [
            "query": query
        ]
 
        let parameters = APIHelper.rejectNil(nillableParameters)
 
        let convertedParameters = APIHelper.convertBoolToString(parameters)
 
        let requestBuilder: RequestBuilder<[String]>.Type = EmbeddedSocialClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: URLString, parameters: convertedParameters, isBody: false)
    }

    /**
     Get trending hashtags
     
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func hashtagsGetTrendingHashtags(completion: @escaping ((_ data: [String]?,_ error: Error?) -> Void)) {
        hashtagsGetTrendingHashtagsWithRequestBuilder().execute { (response, error) -> Void in
            completion(response?.body, error);
        }
    }


    /**
     Get trending hashtags
     - GET /v0.6/hashtags/trending
     - examples: [{contentType=application/json, example=[ "aeiou" ]}, {contentType=application/xml, example=string}]
     - examples: [{contentType=application/json, example=[ "aeiou" ]}, {contentType=application/xml, example=string}]

     - returns: RequestBuilder<[String]> 
     */
    open class func hashtagsGetTrendingHashtagsWithRequestBuilder() -> RequestBuilder<[String]> {
        let path = "/v0.6/hashtags/trending"
        let URLString = EmbeddedSocialClientAPI.basePath + path

        let nillableParameters: [String:Any?] = [:]
 
        let parameters = APIHelper.rejectNil(nillableParameters)
 
        let convertedParameters = APIHelper.convertBoolToString(parameters)
 
        let requestBuilder: RequestBuilder<[String]>.Type = EmbeddedSocialClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: URLString, parameters: convertedParameters, isBody: true)
    }

}
