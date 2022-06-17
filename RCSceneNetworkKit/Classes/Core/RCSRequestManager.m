//
//  RCSRequestManager.m
//  RCSceneLoginKit
//
//  Created by 彭蕾 on 2022/6/7.
//

#import "RCSRequestManager.h"
#import "RCSNetworkGlobalConfig.h"
#import <AFNetworking/AFNetworking.h>
#import "RCSRequestPool.h"

@interface RCSRequestManager () {
    RCSNetworkGlobalConfig *_config;
    AFHTTPSessionManager *_sessionManager;
    
    dispatch_queue_t _processingQueue;
    NSIndexSet *_allStatusCodes;
}

@property (nonatomic, strong) AFJSONResponseSerializer *jsonResponseSerializer;
@property (nonatomic, strong) RCSRequestPool *requestPool;

@end

@implementation RCSRequestManager

- (instancetype)init {
    self = [super init];
    if (self) {
        _config          = [RCSNetworkGlobalConfig shared];
        _requestPool     = [RCSRequestPool new];
        _allStatusCodes  = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(100, 500)];
        _processingQueue = dispatch_queue_create("com.rcs.network.processing", DISPATCH_QUEUE_CONCURRENT);
        [self setupSessionManager];
    }
    return self;
}

+ (instancetype)shared {
    static RCSRequestManager *_shared;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shared = [[RCSRequestManager alloc] init];
    });
    return _shared;
}

#pragma mark - public method
- (void)cancelRequestForTaskId:(NSUInteger )taskId; {
    RCSRequest *request = [self.requestPool requestForTaskId:taskId];
    [self cancelRequest:request];
}

- (void)addRequest:(RCSRequest *)request {
    NSParameterAssert(request != nil);
    
    NSError *requestSerializationError = nil;
    request.sessionTask = [self sessionTaskForRequest:request error:&requestSerializationError];
    
    [_requestPool addRequest:request];
    [request.sessionTask resume];
}

- (void)cancelRequest:(RCSRequest *)request {
    [request.sessionTask cancel];
    
    [_requestPool removeRequest:request];
    [request clearCompletionBlock];
}

#pragma mark - pravite method
- (NSURLSessionTask *)sessionTaskForRequest:(RCSRequest *)request error:(NSError **)error {
    RCSHTTPRequestMethodType httpMethod = request.httpMethod;
    NSString *requestURL = [self buildRequestURL:request];
    AFHTTPRequestSerializer *requestSerializer = [self requestSerializerForRequest:request];
    NSMutableDictionary *requestParams = [self paramsForRequest:request];
    
    void(^downloadProgressBlock)(NSProgress *downloadProgress) = nil;
    if (request.progressBlock) {
        downloadProgressBlock = ^(NSProgress *downloadProgress) {
            request.progressBlock(request, downloadProgress);
        };
    }
    
    if (httpMethod == RCSHTTPRequestMethodTypeGET && request.downloadPath) {
        return [self downloadTaskWithDownloadPath:request.downloadPath
                                requestSerializer:requestSerializer
                                        URLString:requestURL
                                       parameters:requestParams
                                         progress:downloadProgressBlock
                                            error:error];
    }
    
    NSString *httpMethodStr = [self httpMethodStr:httpMethod];
    if (httpMethodStr) {
        return [self dataTaskWithHTTPMethod:httpMethodStr
                          requestSerializer:requestSerializer
                                  URLString:requestURL
                                 parameters:requestParams
                                      error:error];
    }
    return nil;
}

- (NSURLSessionDownloadTask *)downloadTaskWithDownloadPath:(NSString *)downloadPath
                                         requestSerializer:(AFHTTPRequestSerializer *)requestSerializer
                                                 URLString:(NSString *)URLString
                                                parameters:(id)parameters
                                                  progress:(void (^)(NSProgress *downloadProgress))progressBlock
                                                     error:(NSError * _Nullable __autoreleasing *)error {
    
    NSMutableURLRequest *urlRequest = [requestSerializer requestWithMethod:@"GET"
                                                                 URLString:URLString
                                                                parameters:parameters
                                                                     error:error];
    
    NSString *downloadTargetPath;
    BOOL isDirectory;
    if(![[NSFileManager defaultManager] fileExistsAtPath:downloadPath isDirectory:&isDirectory]) {
        isDirectory = NO;
    }
    
    if (isDirectory) {
        NSString *fileName = [urlRequest.URL lastPathComponent];
        downloadTargetPath = [NSString pathWithComponents:@[downloadPath, fileName]];
    } else {
        downloadTargetPath = downloadPath;
    }
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:downloadTargetPath]) {
        [[NSFileManager defaultManager] removeItemAtPath:downloadTargetPath error:nil];
    }
    
    __block NSURLSessionDownloadTask *downloadTask = nil;
    downloadTask = [_sessionManager downloadTaskWithRequest:urlRequest
                                                   progress:progressBlock
                                                destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        return [NSURL fileURLWithPath:downloadTargetPath isDirectory:NO];
    } completionHandler:^(NSURLResponse *response,
                          NSURL *filePath,
                          NSError *error) {
        [self handleRequestResult:downloadTask
                   responseObject:filePath
                            error:error];
    }];
    return downloadTask;
}

- (AFHTTPRequestSerializer *)requestSerializerForRequest:(RCSRequest *)request {
    AFHTTPRequestSerializer *requestSerializer = nil;
    NSString *contentType = [request.requestHeaders objectForKey:@"Content-Type"];
    if (!contentType && _config.commonHeaders) {
        contentType = [_config.commonHeaders() objectForKey:@"Content-Type"];
    }
    if (request.httpMethod == RCSHTTPRequestMethodTypePOST && [contentType containsString:@"application/json"]) {
        requestSerializer = [AFJSONRequestSerializer serializer];
    } else {
        if (request.requestSerializerType == RCSRequestSerializerTypeJSON) {
            requestSerializer = [AFJSONRequestSerializer serializer];
        } else {
            requestSerializer = [AFHTTPRequestSerializer serializer];
        }
    }
    
    // 设置超时时间
    NSTimeInterval timeoutInterval = 60;
    if (request.timeoutInterval > 0) {
        timeoutInterval = request.timeoutInterval;
    } else if (_config.timeoutInterval > 0) {
        timeoutInterval = _config.timeoutInterval;
    }
    requestSerializer.timeoutInterval = timeoutInterval;
    
    // 设置Headers
    //1. 设置公用请求头中的信息。
    if (_config.commonHeaders) {
        [self setHeaders:_config.commonHeaders() forRequestSerializer:requestSerializer];
    }
    
    //2. 然后使用request中的自定义headers进行覆盖操作。
    [self setHeaders:request.requestHeaders forRequestSerializer:requestSerializer];
    
    return requestSerializer;
}

- (void)setHeaders:(NSDictionary *)headers forRequestSerializer:(AFHTTPRequestSerializer *)requestSerializer {
    if (!headers) {
        return;
    }
    for (NSString *headerName in headers.allKeys) {
        [requestSerializer setValue:headers[headerName] forHTTPHeaderField:headerName];
    }
}

- (NSMutableDictionary *)paramsForRequest:(RCSRequest *)request {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (_config.commonParams) {
        [params addEntriesFromDictionary:_config.commonParams()];
    }
    if ([request.requestParams count] > 0) {
        [params addEntriesFromDictionary:request.requestParams];
    }
    return params;
}


- (NSString *)httpMethodStr:(RCSHTTPRequestMethodType)httpMethod {
    NSString *httpMethodStr = nil;
    switch (httpMethod) {
        case RCSHTTPRequestMethodTypeGET:
            httpMethodStr = @"GET";
            break;
        case RCSHTTPRequestMethodTypePOST:
            httpMethodStr  = @"POST";
            break;
        case RCSHTTPRequestMethodTypePUT:
            httpMethodStr = @"PUT";
            break;
        case RCSHTTPRequestMethodTypeHEAD:
            httpMethodStr = @"HEAD";
            break;
        case RCSHTTPRequestMethodTypePATCH:
            httpMethodStr = @"PATCH";
            break;
        case RCSHTTPRequestMethodTypeDELETE:
            httpMethodStr = @"DELETE";
            break;
    }
    return httpMethodStr;
}


- (NSURLSessionDataTask *)dataTaskWithHTTPMethod:(NSString *)method
                               requestSerializer:(AFHTTPRequestSerializer *)requestSerializer
                                       URLString:(NSString *)URLString
                                      parameters:(id)parameters
                                           error:(NSError * _Nullable __autoreleasing *)error {
    NSMutableURLRequest *request = [requestSerializer requestWithMethod:method URLString:URLString parameters:parameters error:error];
    
    __block NSURLSessionDataTask *dataTask = nil;
    dataTask = [_sessionManager dataTaskWithRequest:request uploadProgress:NULL downloadProgress:NULL completionHandler:^(NSURLResponse * __unused response, id responseObject, NSError *_error) {
        __weak __typeof__(self) weakSelf = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            __strong __typeof__(weakSelf) strongSelf = weakSelf;
            [strongSelf handleRequestResult:dataTask responseObject:responseObject error:_error];
        });
        
    }];
    
    return dataTask;
}

- (void)handleRequestResult:(NSURLSessionTask *)task responseObject:(id)responseObject error:(NSError *)error {
    
    RCSRequest *request = [_requestPool requestForTaskId:task.taskIdentifier];
    if (!request) {
        return;
    }
    
    request.responseObject = responseObject;
    if ([responseObject isKindOfClass:[NSData class]]) {
        request.responseData = responseObject;
    }
    
    if (error) {
        !request.failBlock ?: request.failBlock(request, error);
    } else {
        [self serializeResponseForRequest:request];
    }
    
    __weak __typeof__(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        __strong __typeof__(weakSelf) strongSelf = weakSelf;
        [strongSelf.requestPool removeRequest:request];
        [request clearCompletionBlock];
    });
}

- (void)serializeResponseForRequest:(RCSRequest *)request {
    
    if (request.responseSerializerType != RCSResponseSerializerTypeJSON) {
        !request.successBlock ?: request.successBlock(request, request.responseData);
        return ;
    }
    
    if (request.downloadPath != nil) {
        !request.successBlock ?: request.successBlock(request, request.responseObject);
        return ;
    }
    
    NSError *serializationError = nil;
    id responseJSONObject = [self.jsonResponseSerializer responseObjectForResponse:request.sessionTask.response
                                                                              data:request.responseData
                                                                             error:&serializationError];
    request.responseJSONObject = responseJSONObject;
    request.responseObject     = responseJSONObject;
    
    if (serializationError) {
        !request.failBlock ?: request.failBlock(request, serializationError);
        return ;
    }
    
    !request.successBlock ?: request.successBlock(request, responseJSONObject);
}

#pragma mark - pravite method
- (void)setupSessionManager {
    _sessionManager = [[AFHTTPSessionManager alloc] init];
    _sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    _sessionManager.responseSerializer.acceptableStatusCodes = _allStatusCodes;
    _sessionManager.completionQueue = _processingQueue;
}

- (NSString *)buildRequestURL:(RCSRequest *)request {
    NSString *requestURL = [request requestURL];
    NSURL *tempURL = [NSURL URLWithString:requestURL];
    if (tempURL && tempURL.host && tempURL.scheme) {
        return requestURL;
    }
    
    NSString *baseURL = nil;
    if (request.baseURL.length > 0) {
        baseURL = request.baseURL;
    } else if (_config.baseURL){
        baseURL = _config.baseURL();
    }
    
    NSAssert(baseURL.length > 0, @"在没有requestURL不是完整的url的时候，baseURL是必须的");
    NSString *requestURI = request.requestURL;
    
    NSString *url = [baseURL stringByAppendingPathComponent:requestURI];
    if ([url hasPrefix:@"http://"] || [url hasPrefix:@"https://"]) {
        return url;
    }
    return url;
}

- (AFJSONResponseSerializer *)jsonResponseSerializer {
    if (!_jsonResponseSerializer) {
        _jsonResponseSerializer = [AFJSONResponseSerializer serializer];
        _jsonResponseSerializer.acceptableStatusCodes = _allStatusCodes;
    }
    return _jsonResponseSerializer;
}

@end
