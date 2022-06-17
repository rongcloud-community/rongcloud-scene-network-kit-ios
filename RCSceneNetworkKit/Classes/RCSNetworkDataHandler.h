//
//  RCSNetworkDataHandler.h
//  RCSceneLoginKit
//
//  Created by 彭蕾 on 2022/6/8.
//

#import <Foundation/Foundation.h>
#import "RCSNetworkConfig.h"
#import "RCSNetworkHeader.h"
NS_ASSUME_NONNULL_BEGIN

@interface RCSNetworkDataHandler : NSObject

/// 发起普通请求
/// @param urlConfig  请求配置参数
/// @param completion  请求完毕回调
/// @return 返回请求唯一标识id
- (NSUInteger)requestWithUrlConfig:(RCSNetworkConfig *)urlConfig
                        completion:(RCSNetworkCompletion _Nullable)completion;

/// 发起下载请求
/// @param urlConfig  请求配置参数
/// @param downloadProgress 请求请求进度的回调
/// @param downloadPath 本地路径
/// @param completion  请求完毕回调，model.data ==> NSURL
/// @return 返回请求唯一标识 id
- (NSUInteger)requestWithUrlConfig:(RCSNetworkConfig *)urlConfig
                      downloadPath:(NSString *)downloadPath
                  downloadProgress:(RCSNetworkProgress _Nullable)downloadProgress
                        completion:(RCSNetworkCompletion _Nullable)completion;


/// 取消网络请求
/// @param identifier  发起请求返回的请求唯一标识id
- (void)cancelRequestWithId:(NSUInteger)identifier;

@end

NS_ASSUME_NONNULL_END
