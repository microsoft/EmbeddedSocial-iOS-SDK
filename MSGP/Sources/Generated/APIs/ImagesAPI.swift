//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Alamofire



open class ImagesAPI: APIBase {
    /**
     Get image
     
     - parameter blobHandle: (path) Blob handle 
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func imagesGetImage(blobHandle: String, completion: @escaping ((_ data: URL?,_ error: Error?) -> Void)) {
        imagesGetImageWithRequestBuilder(blobHandle: blobHandle).execute { (response, error) -> Void in
            completion(response?.body, error);
        }
    }


    /**
     Get image
     - GET /v0.6/images/{blobHandle}
     - examples: [{output=none}]
     
     - parameter blobHandle: (path) Blob handle 

     - returns: RequestBuilder<URL> 
     */
    open class func imagesGetImageWithRequestBuilder(blobHandle: String) -> RequestBuilder<URL> {
        var path = "/v0.6/images/{blobHandle}"
        path = path.replacingOccurrences(of: "{blobHandle}", with: "\(blobHandle)", options: .literal, range: nil)
        let URLString = EmbeddedSocialClientAPI.basePath + path

        let nillableParameters: [String:Any?] = [:]
 
        let parameters = APIHelper.rejectNil(nillableParameters)
 
        let convertedParameters = APIHelper.convertBoolToString(parameters)
 
        let requestBuilder: RequestBuilder<URL>.Type = EmbeddedSocialClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: URLString, parameters: convertedParameters, isBody: true)
    }

    /**
     * enum for parameter imageType
     */
    public enum ImageType_imagesPostImage: String { 
        case userPhoto = "UserPhoto"
        case contentBlob = "ContentBlob"
        case appIcon = "AppIcon"
    }

    /**
     Upload a new image
     
     - parameter imageType: (path) Image type 
     - parameter image: (body) MIME encoded contents of the image 
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func imagesPostImage(imageType: ImageType_imagesPostImage, image: Data, completion: @escaping ((_ data: PostImageResponse?,_ error: Error?) -> Void)) {
        imagesPostImageWithRequestBuilder(imageType: imageType, image: image).execute { (response, error) -> Void in
            completion(response?.body, error);
        }
    }


    /**
     Upload a new image
     - POST /v0.6/images/{imageType}
     - Images will be resized. To access a resized image, append the 1 character size identifier to the blobHandle that is returned.                             - d is 25 pixels wide               - h is 50 pixels wide               - l is 100 pixels wide               - p is 250 pixels wide               - t is 500 pixels wide               - x is 1000 pixels wide                             - ImageType.UserPhoto supports d,h,l,p,t,x               - ImageType.ContentBlob supports d,h,l,p,t,x               - ImageType.AppIcon supports l                             All resized images will maintain their aspect ratio. Any orientation specified in the EXIF headers will be honored.
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
     
     - parameter imageType: (path) Image type 
     - parameter image: (body) MIME encoded contents of the image 

     - returns: RequestBuilder<PostImageResponse> 
     */
    open class func imagesPostImageWithRequestBuilder(imageType: ImageType_imagesPostImage, image: Data) -> RequestBuilder<PostImageResponse> {
        var path = "/v0.6/images/{imageType}"
        path = path.replacingOccurrences(of: "{imageType}", with: "\(imageType.rawValue)", options: .literal, range: nil)
        let URLString = EmbeddedSocialClientAPI.basePath + path
        let parameters = image.encodeToJSON() as? [String:AnyObject]
 
        let convertedParameters = APIHelper.convertBoolToString(parameters)
 
        let requestBuilder: RequestBuilder<PostImageResponse>.Type = EmbeddedSocialClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "POST", URLString: URLString, parameters: convertedParameters, isBody: true)
    }

}
