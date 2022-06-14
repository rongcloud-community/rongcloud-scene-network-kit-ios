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

- (void)requestWithUrlConfig:(RCSNetworkConfig *)urlConfig
                  completion:(RCSNetworkCompletion _Nullable)completion;

@end

NS_ASSUME_NONNULL_END
