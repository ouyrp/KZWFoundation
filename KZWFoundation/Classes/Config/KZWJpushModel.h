//
//  KZWJpushModel.h
//  kongzhongfinancial
//
//  Created by ouyang on 2018/1/10.
//  Copyright © 2018年 ouy. All rights reserved.
//

#import "LPDBModel.h"
#import <Foundation/Foundation.h>

@interface KZWJpushInfoModel : LPDBModel

@property (nonatomic, copy) NSString *messageContent;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, assign) NSInteger sysType;
@property (nonatomic, assign) BOOL isRedirct;
@property (nonatomic, copy) NSString *targetUrl;
@property (nonatomic, assign) NSInteger backMessageType;
@property (nonatomic, copy) NSString *createdTime;

@end

@interface KZWJpushAps : LPDBModel

@property (copy, nonatomic) NSString *sound;
@property (copy, nonatomic) NSString *alert;
@property (assign, nonatomic) NSInteger badge;

@end

@interface KZWJpushModel : LPDBModel

@property (copy, nonatomic) NSString *extInfo;
@property (copy, nonatomic) KZWJpushAps *aps;

@end
