//
//  RCSRequest.h
//  RCSceneLoginKit
//
//  Created by 彭蕾 on 2022/6/7.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>

NS_ASSUME_NONNULL_BEGIN

@interface RCSRequest : NSObject

/// HTTP Request method
typedef NS_ENUM(NSUInteger, RCSHTTPRequestMethodType) {
    RCSHTTPRequestMethodTypeGET = 0,
    RCSHTTPRequestMethodTypePOST,
    RCSHTTPRequestMethodTypeHEAD,
    RCSHTTPRequestMethodTypePUT,
    RCSHTTPRequestMethodTypeDELETE,
    RCSHTTPRequestMethodTypePATCH,
};

/// Request serializer type
typedef NS_ENUM(NSUInteger, RCSRequestSerializerType) {
    RCSRequestSerializerTypeHTTP = 0,
    RCSRequestSerializerTypeJSON
};

/**
 网络请求响应内容序列化类型
 1. 用来决定使用什么方式进行序列化
 2. 并且决定最终产生的responseSerializedObject属性类型
 - RCSResponseSerializerTypeHTTP: NSData type
 - RCSResponseSerializerTypeJSON: JSON object type
 */
typedef NS_ENUM(NSUInteger, RCSResponseSerializerType) {
    RCSResponseSerializerTypeHTTP = 0,
    RCSResponseSerializerTypeJSON,
};

typedef void(^RCSRequestSuccessBlock)(RCSRequest * _Nonnull request, id _Nullable responseObject);
typedef void(^RCSRequestFailBlock)(RCSRequest * _Nonnull request,  NSError * _Nullable error);

#pragma mark - Request Configuration

/**
 网络请求的方法, 默认为RCSHTTPRequestMethodType
 */
@property (nonatomic, assign) RCSHTTPRequestMethodType httpMethod;

/**
 网络请求的URL。
 1. 如果requestURL可以生成一个NSURL则使用requestURL作为请求地址。
 2. 如果baseURL存在，则和baseURL共同拼接成URL作为请求地址。
 */
@property (nonatomic, strong) NSString * _Nonnull requestURL;

/**
 请求的BaseURL。
 如果设置了该值，requestURL可以忽略掉baseURL部分直接写API路径。
 可以在API接口实现类中自定义接口的BaseURL
 */
@property (nonatomic, strong, nullable) NSString *baseURL;

/**
 网络请求的超时时间单位秒。默认为60.
 */
@property (nonatomic, assign) NSTimeInterval timeoutInterval;

/**
 网络请求序列化类型，默认为RCSRequestSerializerTypeHTTP
 */
@property (nonatomic, assign, readonly) RCSRequestSerializerType requestSerializerType;

/**
 网络响应数据序列化类型，默认为RCSResponseSerializerTypeJSON
 */
@property (nonatomic, assign, readonly) RCSResponseSerializerType responseSerializerType;

/**
 网络请求参数键值对。
 */
@property (nonatomic, strong, nullable) NSDictionary<NSString *, id> *requestParams;

/**
 网络请求Header的键值对。
 */
@property (nonatomic, strong, nullable) NSDictionary<NSString *, id> *requestHeaders;

/**
 网络请求序列化 model 名称
 */
@property (nonatomic, strong, nullable) NSString *responseModelClassName;


#pragma mark - Callback

/**
 网络请求处理完成的回调
 */
@property (nonatomic, copy, nullable) RCSRequestSuccessBlock successBlock;
@property (nonatomic, copy, nullable) RCSRequestFailBlock failBlock;

#pragma mark - Request Information
@property (nonatomic, strong, nullable) NSURLSessionTask *sessionTask;

@property (nonatomic, readonly, getter=isCancelled) BOOL cancelled;
@property (nonatomic, readonly, getter=isExecuting) BOOL executing;


#pragma mark - Response Information
@property (nonatomic, strong, nullable) NSData *responseData;
@property (nonatomic, strong, nullable) id responseJSONObject;
@property (nonatomic, strong, nullable) id responseObject; // jsonObj or data
@property (nonatomic, strong, readonly, nullable) NSHTTPURLResponse *response;
@property (nonatomic, strong, readonly, nullable) NSDictionary *responseHeaders;

/**
 清空block设置，防止循环引用。
 */
- (void)clearCompletionBlock;

/**
 将当前请求加入到请求队列当中，并开始请求。
 */
- (void)start;

/**
 从请求队列中删除当前请求，并取消请求。
 */
- (void)stop;

/**
 使用callback回调的快捷开始请求的方法。
 */
- (void)startWithSuccessBlock:(RCSRequestSuccessBlock _Nullable)success
                    failBlock:(RCSRequestFailBlock _Nullable)fail;

@end

NS_ASSUME_NONNULL_END
