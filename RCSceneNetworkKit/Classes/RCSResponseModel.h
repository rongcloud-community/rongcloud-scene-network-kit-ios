//
//  RCSResponseModel.h
//  RCSceneLoginKit
//
//  Created by 彭蕾 on 2022/6/6.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSUInteger, RCSResponseStatusCode) {
    RCSResponseStatusCodeSuccess = 10000,
};

/// RCSRequest的响应体序列化后产生的基础对象。
@interface RCSResponseModel : NSObject

@property (nonatomic, assign) NSInteger code;
@property (nonatomic, nullable, strong) NSString *msg;
/// 传入的rspClass具体模型，或者都为rspClass模型的数组
@property (nonatomic, nullable, strong) id data;

- (instancetype)initWithErrorCode:(NSInteger)errorCode
                         errorMsg:(NSString *)errorMsg;

@end

NS_ASSUME_NONNULL_END
