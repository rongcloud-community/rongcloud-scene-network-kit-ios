//
//  RCSRequest.m
//  RCSceneLoginKit
//
//  Created by 彭蕾 on 2022/6/7.
//

#import "RCSRequest.h"
#import "RCSRequestManager.h"
#import <YYModel/YYModel.h>

@interface RCSRequest ()

@property (nonatomic, assign, readwrite) RCSRequestSerializerType requestSerializerType;
@property (nonatomic, assign, readwrite) RCSResponseSerializerType responseSerializerType;

@end

@implementation RCSRequest

- (instancetype)init {
    self = [super init];
    if (self) {
        _httpMethod             = RCSHTTPRequestMethodTypeGET;
        _timeoutInterval        = 60.0;
        _requestSerializerType  = RCSRequestSerializerTypeHTTP;
        _responseSerializerType = RCSResponseSerializerTypeJSON;
    }
    return self;
}

- (void)clearCompletionBlock {
    self.successBlock = nil;
    self.failBlock = nil;
    self.progressBlock = nil;
}

- (NSUInteger)start {
    [[RCSRequestManager shared] addRequest:self];
    return self.sessionTask.taskIdentifier;
}

- (void)stop {
    [[RCSRequestManager shared] cancelRequest:self];
}

- (NSUInteger)startWithProgressBlock:(RCSRequestProgressBlock _Nullable)progress
                       successBlock:(RCSRequestSuccessBlock _Nullable)success
                          failBlock:(RCSRequestFailBlock _Nullable)fail {
    self.progressBlock = progress;
    self.successBlock = success;
    self.failBlock = fail;
    return [self start];
}

- (NSUInteger)startWithSuccessBlock:(RCSRequestSuccessBlock _Nullable)success
                          failBlock:(RCSRequestFailBlock _Nullable)fail {
    self.successBlock = success;
    self.failBlock = fail;
    return [self start];
}

- (NSHTTPURLResponse *)response {
    return (NSHTTPURLResponse *)self.sessionTask.response;
}

- (NSDictionary *)responseHeaders {
    return self.response.allHeaderFields;
}

- (BOOL)isCancelled {
    if (!self.sessionTask) {
        return NO;
    }
    return self.sessionTask.state == NSURLSessionTaskStateCanceling;
}

- (BOOL)isExecuting {
    if (!self.sessionTask) {
        return NO;
    }
    return self.sessionTask.state == NSURLSessionTaskStateRunning;
}

@end
