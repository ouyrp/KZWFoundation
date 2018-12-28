//
//  KZWDebugService.h
//  kongzhongfinancial
//
//  Created by ouyang on 2018/7/10.
//  Copyright © 2018年 ouy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KZWDebugService : NSObject

+ (id)currentDebug;

+ (void)setCurrentDebug:(id)debug;

+ (void)saveDebug;

+ (void)deleteDebug;

@end
