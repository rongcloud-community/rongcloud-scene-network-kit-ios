//
//  RCSNetworkConfig.h
//  RCSceneLoginKit
//
//  Created by 彭蕾 on 2022/6/8.
//

#import <Foundation/Foundation.h>
#import "RCSNetworkHeader.h"

NS_ASSUME_NONNULL_BEGIN

@interface RCSNetworkConfig : NSObject

@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *rspClassName;
@property (nonatomic, assign) RCSHTTPRequestMethod method;
@property (nonatomic, strong, nullable) NSDictionary *params;
@property (nonatomic, strong, nullable) NSDictionary *headers;
@property (nonatomic, assign) BOOL auth;

+ (instancetype)configWithUrl:(NSString *)url
                       method:(RCSHTTPRequestMethod)method
                       params:(NSDictionary *)params;

+ (instancetype)configWithUrl:(NSString *)url
                 rspClassName:(nullable NSString *)rspClassName
                       method:(RCSHTTPRequestMethod)method
                       params:(NSDictionary *)params;

+ (instancetype)configWithUrl:(NSString *)url
                 rspClassName:(nullable NSString *)rspClassName
                       method:(RCSHTTPRequestMethod)method
                       params:(nullable NSDictionary *)params
                      headers:(nullable NSDictionary *)headers;

+ (void)configWithBaseUrl:(NSString *)baseUrl
           bussinessToken:(NSString *)bussinessToken;

@end

NS_ASSUME_NONNULL_END
