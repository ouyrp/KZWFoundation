//
//  NSError+LPDErrorMessage.m
//  LPDCrowdsource
//
//  Created by 沈强 on 16/3/7.
//  Copyright © 2016年 elm. All rights reserved.
//

#import "NSError+LPDErrorMessage.h"

@implementation NSError (LPDErrorMessage)
- (NSString *)message {
    NSDictionary *userInfo = self.userInfo;
    return userInfo[LPDBNetworkUserMessage] ? userInfo[LPDBNetworkUserMessage] : @"服务异常";
}

- (NSString *)businessMessage {
    if (self.code == LPDBNeteworkBusinessError) {
        NSDictionary *userInfo = self.userInfo;
        return userInfo[LPDBNetworkUserMessage];
    }
    return nil;
}

- (NSString *)businessMessage:(NSString *)defaultMessage {
    if (self.code == LPDBNeteworkBusinessError) {
        NSDictionary *userInfo = self.userInfo;
        return userInfo[LPDBNetworkUserMessage];
    }
    return defaultMessage;
}

- (NSString *)businessErrorCode {
    if (self.code == LPDBNeteworkBusinessError) {
        NSDictionary *userInfo = self.userInfo;
        return userInfo[LPDBNetworkBusinessErrorCode];
    }
    return nil;
}

@end
