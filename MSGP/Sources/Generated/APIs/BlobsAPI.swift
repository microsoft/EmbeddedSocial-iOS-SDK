//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Alamofire


open class BlobsAPI: APIBase {
    /**
     Get blob
     
     - parameter blobHandle: (path) Blob handle 
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func blobsGetBlob(blobHandle: String, completion: @escaping ((_ data: URL?,_ error: Error?) -> Void)) {
        blobsGetBlobWithRequestBuilder(blobHandle: blobHandle).execute { (response, error) -> Void in
            completion(response?.body, error);
        }
    }


    /**
     Get blob
     - GET /v0.6/blobs/{blobHandle}
     - examples: [{output=none}]
     
     - parameter blobHandle: (path) Blob handle 

     - returns: RequestBuilder<URL> 
     */
    open class func blobsGetBlobWithRequestBuilder(blobHandle: String) -> RequestBuilder<URL> {
        var path = "/v0.6/blobs/{blobHandle}"
        path = path.replacingOccurrences(of: "{blobHandle}", with: "\(blobHandle)", options: .literal, range: nil)
        let URLString = EmbeddedSocialClientAPI.basePath + path

        let nillableParameters: [String:Any?] = [:]
 
        let parameters = APIHelper.rejectNil(nillableParameters)
 
        let convertedParameters = APIHelper.convertBoolToString(parameters)
 
        let requestBuilder: RequestBuilder<URL>.Type = EmbeddedSocialClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: URLString, parameters: convertedParameters, isBody: true)
    }

    /**
     Upload a blob
     
     - parameter blob: (body) MIME encoded contents of the blob 
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func blobsPostBlob(blob: Data, completion: @escaping ((_ data: PostBlobResponse?,_ error: Error?) -> Void)) {
        blobsPostBlobWithRequestBuilder(blob: blob).execute { (response, error) -> Void in
            completion(response?.body, error);
        }
    }


    /**
     Upload a blob
     - POST /v0.6/blobs
     - If your blob is an image, use image APIs. For all other blob types, use this API.
     - examples: [{contentType=application/json, example={
  "blobHandle" : "aeiou"
}}, {contentType=application/xml, example=<null>
  <blobHandle>string</blobHandle>
</null>}]
     - examples: [{contentType=application/json, example={
  "blobHandle" : "aeiou"
}}, {contentType=application/xml, example=<null>
  <blobHandle>string</blobHandle>
</null>}]
     
     - parameter blob: (body) MIME encoded contents of the blob 

     - returns: RequestBuilder<PostBlobResponse> 
     */
    open class func blobsPostBlobWithRequestBuilder(blob: Data) -> RequestBuilder<PostBlobResponse> {
        let path = "/v0.6/blobs"
        let URLString = EmbeddedSocialClientAPI.basePath + path
        let parameters = blob.encodeToJSON() as? [String:AnyObject]
 
        let convertedParameters = APIHelper.convertBoolToString(parameters)
 
        let requestBuilder: RequestBuilder<PostBlobResponse>.Type = EmbeddedSocialClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "POST", URLString: URLString, parameters: convertedParameters, isBody: true)
    }

}
