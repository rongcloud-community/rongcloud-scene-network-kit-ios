//
//  RCSResponseModel.m
//  RCSceneLoginKit
//
//  Created by 彭蕾 on 2022/6/6.
//

#import "RCSResponseModel.h"
#import <YYModel/YYModel.h>

@implementation RCSResponseModel

- (instancetype)initWithErrorCode:(NSInteger)errorCode
                         errorMsg:(NSString *)errorMsg {
    if (self = [super init]) {
        self.code = errorCode;
        self.msg = errorMsg;
    }
    return self;
}

- (NSString *)description {
    return [self yy_modelDescription];
}

@end
