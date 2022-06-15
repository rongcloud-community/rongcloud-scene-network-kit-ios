# RCSceneNetworkKit

[![CI Status](https://img.shields.io/travis/彭蕾/RCSceneNetworkKit.svg?style=flat)](https://travis-ci.org/彭蕾/RCSceneNetworkKit)
[![Version](https://img.shields.io/cocoapods/v/RCSceneNetworkKit.svg?style=flat)](https://cocoapods.org/pods/RCSceneNetworkKit)
[![License](https://img.shields.io/cocoapods/l/RCSceneNetworkKit.svg?style=flat)](https://cocoapods.org/pods/RCSceneNetworkKit)
[![Platform](https://img.shields.io/cocoapods/p/RCSceneNetworkKit.svg?style=flat)](https://cocoapods.org/pods/RCSceneNetworkKit)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

Minimum iOS Target：iOS 11.0

## Installation

RCSceneNetworkKit is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'RCSceneNetworkKit'
```

## Usage

通过添加 ```RCSNetworkConfig``` 分类配置请求信息，和添加 ```RCSNetworkDataHandler``` 分类发起请求

```Objective-c

	/// 添加全局网络配置
    [RCSNetworkConfig configWithBaseUrl:@""
                         bussinessToken:@""];
    
    /// 通过 RCSNetworkDataHandler 实例对象发起请求
    [[RCSNetworkDataHandler new] sendCodeWithParams:@{} completionBlock:^(RCSResponseModel * _Nonnull model) {
        NSLog(@"%@", model.description);
    }];



//  RCSNetworkConfig+Login.h
@interface RCSNetworkConfig (Login)

/// 获取登录验证码
+ (RCSNetworkConfig *)sendCodeUrlConfigWith:(NSDictionary *)params;


@end

//  RCSNetworkConfig+Login.m
@implementation RCSNetworkConfig (Login)

/// 获取登录验证码
+ (RCSNetworkConfig *)sendCodeUrlConfigWith:(NSDictionary *)params {
    return [self configWithUrl:@"user/sendCode"
                        method:RCSHTTPRequestMethodPOST
                        params:params];
}

@end


//  RCSNetworkDataHandler+Login.h
@interface RCSNetworkDataHandler (Login)

/// 登录验证码
- (void)sendCodeWithParams:(NSDictionary * _Nullable)params
           completionBlock:(RCSNetworkCompletion _Nullable)completionBlock;


@end

//  RCSNetworkDataHandler+Login.m
@implementation RCSNetworkDataHandler (Login)

/// 登录验证码
- (void)sendCodeWithParams:(NSDictionary * _Nullable)params
           completionBlock:(RCSNetworkCompletion _Nullable)completionBlock {
    RCSNetworkConfig *config = [RCSNetworkConfig sendCodeUrlConfigWith:params];
    [self requestWithUrlConfig:config completion:completionBlock];
}

@end

```

## Author

彭蕾, penglei1@rongcloud.cn

## License

RCSceneNetworkKit is available under the MIT license. See the LICENSE file for more info.
