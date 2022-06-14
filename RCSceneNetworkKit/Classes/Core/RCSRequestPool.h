//
//  RCSRequestPool.h
//  RCSceneLoginKit
//
//  Created by 彭蕾 on 2022/6/7.
//

#import <Foundation/Foundation.h>
#import "RCSRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface RCSRequestPool : NSObject

- (RCSRequest *)requestForTaskId:(NSUInteger )taskId;

- (void)addRequest:(RCSRequest *)request;
- (void)removeRequest:(RCSRequest *)request;

@end

NS_ASSUME_NONNULL_END
