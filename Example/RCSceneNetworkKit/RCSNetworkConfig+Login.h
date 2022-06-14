//
//  RCSNetworkConfig+Login.h
//  RCSceneLoginKit
//
//  Created by 彭蕾 on 2022/6/8.
//

#import <RCSceneNetworkKit/RCSNetworkKit.h>
#import "RCSNetworkConfig.h"

NS_ASSUME_NONNULL_BEGIN

@interface RCSNetworkConfig (Login)

#pragma mark - 用户登录
/// 获取登录验证码
+ (RCSNetworkConfig *)sendCodeUrlConfigWith:(NSDictionary *)params;


@end

NS_ASSUME_NONNULL_END
