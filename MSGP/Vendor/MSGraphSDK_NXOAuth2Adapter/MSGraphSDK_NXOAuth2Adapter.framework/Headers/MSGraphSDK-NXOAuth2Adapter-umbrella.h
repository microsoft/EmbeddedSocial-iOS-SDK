#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "MSGraphSDKNXOAuth2.h"
#import "MSAuthenticationViewController.h"
#import "NXOAuth2AuthenticationProvider.h"
#import "MSAuthConstants.h"
#import "NSError+MSGraphOAuth2.h"

FOUNDATION_EXPORT double MSGraphSDK_NXOAuth2AdapterVersionNumber;
FOUNDATION_EXPORT const unsigned char MSGraphSDK_NXOAuth2AdapterVersionString[];

