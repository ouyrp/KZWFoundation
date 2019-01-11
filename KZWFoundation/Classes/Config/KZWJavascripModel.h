//
//  KZWJavascripModel.h
//  kongzhongfinancial
//
//  Created by ouyang on 2018/5/16.
//  Copyright © 2018年 ouy. All rights reserved.
//

#import "LPDBModel.h"
#import <Foundation/Foundation.h>

@class KZWShareModel;

@interface KZWJavascripModel : LPDBModel

@property (copy, nonatomic) NSString *leftImg;
@property (copy, nonatomic) NSString *titleBg;
@property (copy, nonatomic) NSString *rightImg;
@property (copy, nonatomic) NSString *rightStr;
@property (copy, nonatomic) NSString *rightUrl;
@property (assign, nonatomic) BOOL isNeedLogin;
@property (strong, nonatomic) KZWShareModel *shareContent;

@end

@interface KZWShareModel : LPDBModel

@property (copy, nonatomic) NSString *url;
@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *content;
@property (copy, nonatomic) NSString *imageUrl;

@end

@interface KZWWebControllerModel : LPDBModel

@property (nonatomic, copy) NSString *controllerName;
@property (nonatomic, assign) NSInteger pid;

@end
