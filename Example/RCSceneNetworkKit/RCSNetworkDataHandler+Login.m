//
//  RCSNetworkDataHandler+Login.m
//  RCSceneLoginKit
//
//  Created by 彭蕾 on 2022/6/8.
//

#import "RCSNetworkDataHandler+Login.h"
#import "RCSNetworkConfig.h"
#import "RCSNetworkConfig+Login.h"

@implementation RCSNetworkDataHandler (Login)

- (void)sendCodeWithParams:(NSDictionary * _Nullable)params
           completionBlock:(RCSNetworkCompletion _Nullable)completionBlock {
    RCSNetworkConfig *config = [RCSNetworkConfig sendCodeUrlConfigWith:params];
    [self requestWithUrlConfig:config completion:completionBlock];
}

@end
