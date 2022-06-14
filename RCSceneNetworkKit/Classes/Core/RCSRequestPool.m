//
//  RCSRequestPool.m
//  RCSceneLoginKit
//
//  Created by 彭蕾 on 2022/6/7.
//

#import "RCSRequestPool.h"
#import <pthread/pthread.h>

#define RCSLock() pthread_mutex_lock(&_lock)
#define RCSUnlock() pthread_mutex_unlock(&_lock)

@interface RCSRequestPool () {
    pthread_mutex_t _lock;
    NSMutableDictionary<NSNumber *, RCSRequest *> *_requests;
}

@end

@implementation RCSRequestPool

- (instancetype)init {
    self = [super init];
    if (self) {
        pthread_mutex_init(&_lock, NULL);
        _requests = [[NSMutableDictionary alloc] init];
    }
    return self;
}

#pragma mark - Public Methods

- (RCSRequest *)requestForTaskId:(NSUInteger )taskId {
    if (taskId) {
        RCSLock();
        RCSRequest *request = _requests[@(taskId)];
        RCSUnlock();
        return request;
    }
    return nil;
}

- (void)addRequest:(RCSRequest *)request {
    if (!request) {
        return;
    }
    RCSLock();
    _requests[@(request.sessionTask.taskIdentifier)] = request;
    RCSUnlock();
}

- (void)removeRequest:(RCSRequest *)request {
    if (!request) {
        return;
    }
    RCSLock();
    [_requests removeObjectForKey:@(request.sessionTask.taskIdentifier)];
    RCSUnlock();
}

@end
