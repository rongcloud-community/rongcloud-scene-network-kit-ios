//
//  RCSNetworkHeader.h
//  RCSceneLoginKit
//
//  Created by 彭蕾 on 2022/6/8.
//

#ifndef RCSNetworkHeader_h
#define RCSNetworkHeader_h

#import "RCSResponseModel.h"

/// HTTP Request method
typedef NS_ENUM(NSUInteger, RCSHTTPRequestMethod) {
    RCSHTTPRequestMethodGET = 0,
    RCSHTTPRequestMethodPOST,
    RCSHTTPRequestMethodHEAD,
    RCSHTTPRequestMethodPUT,
    RCSHTTPRequestMethodDELETE,
    RCSHTTPRequestMethodPATCH,
};

typedef void(^RCSNetworkCompletion)(RCSResponseModel * _Nonnull model);

#endif /* RCSNetworkHeader_h */
