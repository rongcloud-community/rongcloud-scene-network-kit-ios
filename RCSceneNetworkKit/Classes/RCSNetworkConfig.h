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

/// 单个请求配置项
/// @param url 可传绝对路径，或者相对路径。相对路径请求会全局配置的baseUrl。
/// @param method 请求方法
/// @param params 请求参数
+ (instancetype)configWithUrl:(NSString *)url
                       method:(RCSHTTPRequestMethod)method
                       params:(nullable NSDictionary *)params;

/// 单个请求配置项
/// @param url 可传绝对路径，或者相对路径。相对路径请求会全局配置的baseUrl。
/// @param rspClassName 请求模型
/// @code
/// dada 返回数组，可以传数组元素Model名称
/// dada 返回字典，可以传字典Model名称
/// 传空，则 data 按解析数据返回
/// @endCode
/// @param method 请求
/// @param params 请求参数
+ (instancetype)configWithUrl:(NSString *)url
                 rspClassName:(nullable NSString *)rspClassName
                       method:(RCSHTTPRequestMethod)method
                       params:(nullable NSDictionary *)params;


/// 单个请求配置项
/// @param url 可传绝对路径，或者相对路径。相对路径请求会全局配置的baseUrl。
/// @param rspClassName 请求模型
/// @code
/// dada 返回数组，可以传数组元素Model名称
/// dada 返回字典，可以传字典Model名称
/// 传空，则 data 按解析数据返回
/// @endCode
/// @param method 请求
/// @param params 请求参数
/// @param headers 请求头，会覆盖全局配置
+ (instancetype)configWithUrl:(NSString *)url
                 rspClassName:(nullable NSString *)rspClassName
                       method:(RCSHTTPRequestMethod)method
                       params:(nullable NSDictionary *)params
                      headers:(nullable NSDictionary *)headers;

#pragma mark - 全局网络配置

/// 配置项
/// @param baseUrl 服务器地址
/// @param businessToken  从 https://rcrtc-api.rongcloud.net/code 获取
///  @code 请求头默认配置
///  {
///     @"Content-Type":@"application/json",
///     @"BusinessToken":businessToken,
///  }
///  @endCode
+ (void)configWithBaseUrl:(NSString *)baseUrl
                 bussinessToken:(nullable NSString *)businessToken;

/// 配置项
/// @param baseUrl 服务器地址
/// @param businessToken  从 https://rcrtc-api.rongcloud.net/code 获取
/// @param auth 用户登录完成获取到的auth
///  @code 请求头默认配置
///  {
///     @"Content-Type":@"application/json",
///     @"BusinessToken":businessToken,
///     @"Authorization":auth
///  }
///  @endCode
+ (void)configWithBaseUrl:(NSString *)baseUrl
             businesToken:(nullable NSString *)businessToken
                     auth:(nullable NSString *)auth;

@end

NS_ASSUME_NONNULL_END
