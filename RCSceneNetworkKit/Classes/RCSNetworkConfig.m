//
//  RCSNetworkConfig.m
//  RCSceneLoginKit
//
//  Created by 彭蕾 on 2022/6/8.
//

#import "RCSNetworkConfig.h"
#import "RCSNetworkGlobalConfig.h"

@implementation RCSNetworkConfig

+ (instancetype)configWithUrl:(NSString *)url
                       method:(RCSHTTPRequestMethod)method
                       params:(NSDictionary *)params {
    return [self configWithUrl:url
                  rspClassName:nil
                        method:method
                        params:params];
}

+ (instancetype)configWithUrl:(NSString *)url
                 rspClassName:(nullable NSString *)rspClassName
                       method:(RCSHTTPRequestMethod)method
                       params:(NSDictionary *)params {
    
    return [self configWithUrl:url
                  rspClassName:rspClassName
                        method:method
                        params:params
                       headers:nil];
}

+ (instancetype)configWithUrl:(NSString *)url
                 rspClassName:(nullable NSString *)rspClassName
                       method:(RCSHTTPRequestMethod)method
                       params:(nullable NSDictionary *)params
                      headers:(nullable NSDictionary *)headers {
    RCSNetworkConfig *newInstance = [RCSNetworkConfig new];
    newInstance.url             = url;
    newInstance.rspClassName    = rspClassName;
    newInstance.method          = method;
    newInstance.params          = params;
    newInstance.headers         = headers;
    return newInstance;
}

#pragma mark - 网络设置
+ (void)configWithBaseUrl:(NSString *)baseUrl
                 bussinessToken:(nullable NSString *)businessToken {
    [self configWithBaseUrl:baseUrl businessToken:businessToken auth:nil];
}

+ (void)configWithBaseUrl:(NSString *)baseUrl
           businessToken:(nullable NSString *)businessToken
                     auth:(nullable NSString *)auth {
    RCSNetworkGlobalConfig *globalConfig = [RCSNetworkGlobalConfig shared];

    globalConfig.baseURL = ^NSString * _Nonnull{
        return baseUrl;
    };
    globalConfig.commonHeaders = ^NSDictionary<NSString *,NSString *> * _Nullable{
        NSMutableDictionary *header = @{@"Content-Type":@"application/json"}.mutableCopy;
        if (businessToken.length != 0) {
            [header addEntriesFromDictionary:@{@"BusinessToken":businessToken}];
        }
        
        if (auth.length != 0) {
            [header addEntriesFromDictionary:@{@"Authorization":auth}];
        }
        return header.copy;
    };
}

@end
