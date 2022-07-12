//
//  RCSNetworkDataHandler.m
//  RCSceneLoginKit
//
//  Created by 彭蕾 on 2022/6/8.
//

#import "RCSNetworkDataHandler.h"
#import "RCSNetworkConfig.h"
#import "RCSRequest.h"
#import "RCSRequestManager.h"
#import <YYModel/YYModel.h>

@implementation RCSNetworkDataHandler

- (NSUInteger)requestWithUrlConfig:(RCSNetworkConfig *)urlConfig
                        completion:(RCSNetworkCompletion _Nullable)completion {
    /// 设置单独 request 请求
    RCSRequest *request = [RCSRequest new];
    request.requestURL = urlConfig.url;
    request.requestParams = urlConfig.params;
    request.responseModelClassName = urlConfig.rspClassName;
    switch (urlConfig.method) {
        case RCSHTTPRequestMethodGET:
            request.httpMethod = RCSHTTPRequestMethodTypeGET;
            break;
        case RCSHTTPRequestMethodPOST:
            request.httpMethod = RCSHTTPRequestMethodTypePOST;
            break;
        case RCSHTTPRequestMethodHEAD:
            request.httpMethod = RCSHTTPRequestMethodTypeHEAD;
            break;
        case RCSHTTPRequestMethodPUT:
            request.httpMethod = RCSHTTPRequestMethodTypePUT;
            break;
        case RCSHTTPRequestMethodDELETE:
            request.httpMethod = RCSHTTPRequestMethodTypeDELETE;
            break;
        case RCSHTTPRequestMethodPATCH:
            request.httpMethod = RCSHTTPRequestMethodTypePATCH;
        default:
            request.httpMethod = RCSHTTPRequestMethodTypeGET;
            break;
    }
    request.requestHeaders = urlConfig.headers;

    return [request startWithSuccessBlock:^(RCSRequest * _Nonnull request, id  _Nullable responseObject) {
        Class targetCls = NSClassFromString(request.responseModelClassName);
        RCSResponseModel *model = [self parseDataFromJson:responseObject targetClass:targetCls];
        !completion ?: completion(model);
    } failBlock:^(RCSRequest * _Nonnull request, NSError * _Nullable error) {
        RCSResponseModel *model = [[RCSResponseModel alloc] initWithErrorCode:error.code
                                                                     errorMsg:error.description];
        !completion ?: completion(model);
    }];
}

/// 发起下载请求
/// @param urlConfig  请求配置参数
/// @param downloadProgress 请求请求进度的回调
/// @param completion  请求完毕回调
/// @return 返回请求唯一标识 id
- (NSUInteger)requestWithUrlConfig:(RCSNetworkConfig *)urlConfig
                      downloadPath:(NSString *)downloadPath
                  downloadProgress:(RCSNetworkProgress _Nullable)downloadProgress
                        completion:(RCSNetworkCompletion _Nullable)completion {
    /// 设置单独 request 请求
    RCSRequest *request = [RCSRequest new];
    request.requestURL = urlConfig.url;
    request.httpMethod = RCSHTTPRequestMethodTypeGET;
    request.downloadPath = downloadPath;

    return [request startWithProgressBlock:^(RCSRequest * _Nonnull request, NSProgress * _Nonnull progress) {
        !downloadProgress ?: downloadProgress(progress);
    } successBlock:^(RCSRequest * _Nonnull request, id  _Nullable responseObject) {
        RCSResponseModel *model = [RCSResponseModel new];
        model.data = responseObject;
        !completion ?: completion(model);
    } failBlock:^(RCSRequest * _Nonnull request, NSError * _Nullable error) {
        RCSResponseModel *model = [[RCSResponseModel alloc] initWithErrorCode:error.code
                                                                     errorMsg:error.description];
        !completion ?: completion(model);
    }];
}

#pragma mark - cancel request
- (void)cancelRequestWithId:(NSUInteger)identifier {
    [[RCSRequestManager shared] cancelRequestForTaskId:identifier];
}

#pragma mark - private method
- (RCSResponseModel *)parseDataFromJson:(NSDictionary *)jsonDict targetClass:(Class)targetClass {
    RCSResponseModel *result;
    if (![jsonDict isKindOfClass:NSDictionary.class]) {
        result = [[RCSResponseModel alloc] initWithErrorCode:-1 errorMsg:@"数据格式不为Json"];
        result.data = jsonDict;
        return result;
    }
    
    NSNumber *errorNumber = jsonDict[@"code"];
    NSString *msg = jsonDict[@"msg"];
    
    if ([jsonDict[@"data"] isKindOfClass:NSDictionary.class]) {
        result = [RCSResponseModel new];
        result.data = targetClass ? [targetClass yy_modelWithDictionary:jsonDict[@"data"]] : jsonDict[@"data"];
        result.code = (errorNumber ? errorNumber.intValue : RCSResponseStatusCodeSuccess);
        result.msg = (msg && ![msg isKindOfClass:[NSNull class]]) ? msg : @"";
    } else if ([jsonDict[@"data"] isKindOfClass:NSArray.class]) {
        result = [RCSResponseModel new];
        result.data = targetClass ? [NSArray yy_modelArrayWithClass:targetClass json:jsonDict[@"data"]] : jsonDict[@"data"];
        result.code = (errorNumber ? errorNumber.intValue : RCSResponseStatusCodeSuccess);
        result.msg = (msg && ![msg isKindOfClass:[NSNull class]]) ? msg : @"";
    } else {
        result = [[RCSResponseModel alloc] initWithErrorCode:(errorNumber ? errorNumber.intValue : RCSResponseStatusCodeSuccess)
                                                    errorMsg:(msg?:@"")];
        result.data = jsonDict[@"data"];
    }
    return result;
}

@end
