//
//  RCSRequestManager.h
//  RCSceneLoginKit
//
//  Created by 彭蕾 on 2022/6/7.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class RCSRequest;
@interface RCSRequestManager : NSObject
+ (instancetype)shared;

- (void)addRequest:(RCSRequest *)request;
- (void)cancelRequest:(RCSRequest *)request;

@end

NS_ASSUME_NONNULL_END
