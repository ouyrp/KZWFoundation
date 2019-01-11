//
//  KZWVersionModel.h
//  KZWFoundation
//
//  Created by ouyang on 2018/5/8.
//  Copyright © 2018年 ouyang. All rights reserved.
//

#import "LPDBModel.h"
#import <Foundation/Foundation.h>

@interface KZWVersionModel : LPDBModel

@property (copy, nonatomic) NSString *appVersion;
@property (copy, nonatomic) NSString *updateDesc;
@property (copy, nonatomic) NSString *updateType;
@property (copy, nonatomic) NSString *packageDownloadUrl;

@end
