//
//  NSError+LPDErrorMessage.h
//  LPDCrowdsource
//
//  Created by 沈强 on 16/3/7.
//  Copyright © 2016年 elm. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString *LPDBNetworkErrorDomain = @"LPDBNetworkErrorDomain";

static NSString *LPDBNetworkUserMessage = @"userErrorMessage";

static NSString *LPDBNetworkBusinessErrorCode = @"businessErrorCode";

typedef NS_ENUM(NSUInteger, LPDBNeteworkErrorCode) {
    LPDBNeteworkResponseDataError = 300,
    LPDBNeteworkBusinessError = 500,
};

@interface NSError (LPDBErrorMessage)

/**
 *  用户错误提示信息
 *
 *
 */
- (NSString *)message;

/**
 *  用户业务逻辑错误信息
 *
 *
 */
- (NSString *)businessMessage;

/**
 *  用户业务逻辑错误信息
 *
 *  @param defaultMessage 当用户业务逻辑错误信息 是空的时候，返回默认值
 *
 *
 */
- (NSString *)businessMessage:(NSString *)defaultMessage;


/**
 *  用户业务逻辑错误code
 *
 *
 */
- (NSString *)businessErrorCode;

@end
