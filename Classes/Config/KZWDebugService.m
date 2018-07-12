//
//  KZWDebugService.m
//  kongzhongfinancial
//
//  Created by ouyang on 2018/7/10.
//  Copyright © 2018年 ouy. All rights reserved.
//

#import "KZWDebugService.h"
#import "KZWConstants.h"

@implementation KZWDebugService

static id _debug = nil;

+ (id)currentDebug {
    @synchronized(self) {
        if (!_debug) {
            NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:KZWDEBUGKEY];
            if (data) {
                _debug = [NSKeyedUnarchiver unarchiveObjectWithData:data];
            }
        }
    }
    return _debug;
}

+ (void)setCurrentDebug:(id)debug {
    @synchronized(self) {
        _debug = debug;
    }
}

+ (void)saveDebug {
    @synchronized(self) {
        if (_debug == nil) {
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:KZWDEBUGKEY];
        } else {
            NSData *data = [NSKeyedArchiver archivedDataWithRootObject:_debug];
            [[NSUserDefaults standardUserDefaults] setObject:data forKey:KZWDEBUGKEY];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }
}

+ (void)deleteDebug {
    @synchronized(self) {
        _debug = nil;
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:KZWDEBUGKEY];
    }
}

@end
