//
//  RCSNetworkGlobalConfig.m
//  RCSceneLoginKit
//
//  Created by 彭蕾 on 2022/6/8.
//

#import "RCSNetworkGlobalConfig.h"

@implementation RCSNetworkGlobalConfig

+ (instancetype)shared {
    static RCSNetworkGlobalConfig *_shared;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shared = [[RCSNetworkGlobalConfig alloc] init];
    });
    return _shared;
}

- (instancetype)init {
    self = [super init];
    if (self) {
#ifdef DEBUG
        _debugEnabled = YES;
#endif
        _timeoutInterval = 60;
    }
    return self;
}

@end
