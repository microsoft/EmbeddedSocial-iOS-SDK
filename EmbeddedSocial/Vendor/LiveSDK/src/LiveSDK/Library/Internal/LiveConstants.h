//
//  LiveConstants.h
//  Live SDK for iOS
//
//  Copyright 2015 Microsoft Corporation
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//  
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//  
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//


#import <Foundation/Foundation.h>

extern NSString * LIVE_ENDPOINT_API_HOST;
extern NSString * LIVE_ENDPOINT_LOGIN_HOST;

static const NSTimeInterval HTTP_REQUEST_TIMEOUT_INTERVAL = 30;

static const NSTimeInterval LIVE_AUTH_EXPIRE_VALUE_ADJUSTMENT = 3;
static const NSTimeInterval LIVE_AUTH_REFRESH_TIME_BEFORE_EXPIRE = 30;

static NSString * const LIVE_API_HEADER_AUTHORIZATION = @"Authorization";
static NSString * const LIVE_API_HEADER_CONTENTTYPE = @"Content-Type";
static NSString * const LIVE_API_HEADER_METHOD = @"method";
static NSString * const LIVE_API_HEADER_CONTENTTYPE_JSON = @"application/json;charset=UTF-8";
static NSString * const LIVE_API_HEADER_X_HTTP_LIVE_LIBRARY = @"X-HTTP-Live-Library";
static NSString * const LIVE_API_PARAM_OVERWRITE = @"overwrite";
static NSString * const LIVE_API_PARAM_SUPPRESS_REDIRECTS = @"suppress_redirects";
static NSString * const LIVE_API_PARAM_SUPPRESS_RESPONSE_CODES = @"suppress_response_codes";

static NSString * const LIVE_AUTH_ACCESS_TOKEN = @"access_token";
static NSString * const LIVE_AUTH_AUTHENTICATION_TOKEN = @"authentication_token";
static NSString * const LIVE_AUTH_CODE = @"code";
static NSString * const LIVE_AUTH_CLIENTID = @"client_id";
static NSString * const LIVE_AUTH_DISPLAY = @"display";
static NSString * const LIVE_AUTH_DISPLAY_IOS_PHONE = @"ios_phone";
static NSString * const LIVE_AUTH_DISPLAY_IOS_TABLET = @"ios_tablet";
static NSString * const LIVE_AUTH_GRANT_TYPE = @"grant_type";
static NSString * const LIVE_AUTH_GRANT_TYPE_AUTHCODE = @"authorization_code";
static NSString * const LIVE_AUTH_LOCALE = @"locale";
static NSString * const LIVE_AUTH_REDIRECT_URI = @"redirect_uri";
static NSString * const LIVE_AUTH_REFRESH_TOKEN = @"refresh_token";
static NSString * const LIVE_AUTH_RESPONSE_TYPE = @"response_type";
static NSString * const LIVE_AUTH_SCOPE = @"scope";
static NSString * const LIVE_AUTH_THEME = @"theme";
static NSString * const LIVE_AUTH_THEME_IOS = @"ios";
static NSString * const LIVE_AUTH_TOKEN = @"token";

static NSString * const LIVE_AUTH_POST_CONTENT_TYPE = @"application/x-www-form-urlencoded;charset=UTF-8";
static NSString * const LIVE_AUTH_EXPIRES_IN = @"expires_in";

static const NSInteger LIVE_ERROR_CODE_LOGIN_FAILED = 1;
static const NSInteger LIVE_ERROR_CODE_LOGIN_CANCELED = 2;
static const NSInteger LIVE_ERROR_CODE_RETRIEVE_TOKEN_FAILED = 3;
static const NSInteger LIVE_ERROR_CODE_API_CANCELED = 4;
static const NSInteger LIVE_ERROR_CODE_API_FAILED = 5;

static NSString * const LIVE_ERROR_CODE_S_ACCESS_DENIED = @"access_denied";
static NSString * const LIVE_ERROR_CODE_S_INVALID_GRANT = @"invalid_grant";
static NSString * const LIVE_ERROR_CODE_S_REQUEST_CANCELED = @"request_canceled";
static NSString * const LIVE_ERROR_CODE_S_REQUEST_FAILED = @"request_failed";
static NSString * const LIVE_ERROR_CODE_S_RESPONSE_PARSING_FAILED = @"response_parse_failure";

static NSString * const LIVE_ERROR_DESC_API_CANCELED = @"The request was canceled.";
static NSString * const LIVE_ERROR_DESC_AUTH_CANCELED = @"The user has canceled the authorization request.";
static NSString * const LIVE_ERROR_DESC_AUTH_FAILED = @"The authorization request failed to complete.";
static NSString * const LIVE_ERROR_DESC_MISSING_PARAMETER = @"The parameter '%@' must be specified when calling '%@'.";
static NSString * const LIVE_ERROR_DESC_MUST_INIT = @"The LiveConnectClient instance must be initialized before being used.";
static NSString * const LIVE_ERROR_DESC_PENDING_LOGIN_EXIST = @"There is already a pending login request.";
static NSString * const LIVE_ERROR_DESC_REQUIRE_RELATIVE_PATH = @"The 'path' parameter must be a relative path when calling '%@'.";
static NSString * const LIVE_ERROR_DESC_UPLOAD_FAIL_QUERY = @"Failed to query upload location.";

static NSString * const LIVE_ERROR_DOMAIN = @"LiveServicesErrorDomain";
static NSString * const LIVE_ERROR_KEY_ERROR = @"error";
static NSString * const LIVE_ERROR_KEY_DESCRIPTION = @"error_description";
static NSString * const LIVE_ERROR_KEY_CODE = @"code";
static NSString * const LIVE_ERROR_KEY_MESSAGE = @"message";
static NSString * const LIVE_ERROR_KEY_INNER_ERROR = @"internal_error";

static NSString * const LIVE_EXCEPTION = @"LiveException";

static NSString * const LIVE_SDK_VERSION = @"5.0";
