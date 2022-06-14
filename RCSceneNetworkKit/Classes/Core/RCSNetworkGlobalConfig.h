//
//  RCSNetworkGlobalConfig.h
//  RCSceneLoginKit
//
//  Created by 彭蕾 on 2022/6/8.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
typedef NSDictionary<NSString *, NSString *>* _Nullable (^RCSNetworkGlobalConfigCommonBlock)(void);
typedef NSString* _Nonnull (^RCSNetworkGlobalConfigStringBlock)(void);

@interface RCSNetworkGlobalConfig : NSObject
/**
 动态获取BaseURL配置。
 */
@property (nonatomic, copy, nullable) RCSNetworkGlobalConfigStringBlock baseURL;

/**
 公共请求头。
 */
@property (nonatomic, copy, nullable) RCSNetworkGlobalConfigCommonBlock commonHeaders;

/**
 公共参数集。
 */
@property (nonatomic, copy, nullable) RCSNetworkGlobalConfigCommonBlock commonParams;

/**
 DEBUG模式下默认为YES，其他情况默认为NO。
 */
@property (nonatomic, assign) BOOL debugEnabled;

/**
 默认为60秒。
 */
@property (nonatomic, assign) NSTimeInterval timeoutInterval;


+ (instancetype)shared;

@end

NS_ASSUME_NONNULL_END
