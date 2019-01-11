//
//  ELMEnvironmentManager.m
//  ELMFoundation
//
//  Created by Draveness on 8/26/16.
//  Copyright (c) 2015 eleme. All rights reserved.
//

#import "ELMEnvironmentManager.h"

static ELMEnvironment Environment = ELMEnvProduction;

NSString *const ELMNotificationWillChangeEnvironment = @"ELMNotificaitonWillChangeNotification";
NSString *const ELMNotificationDidChangeEnvironment = @"ELMNotificationDidChangeEnvironment";

#define execute_block_on_main_thread($block)            \
    if ($block) {                                       \
        if ([[NSThread currentThread] isMainThread]) {  \
            $block();                                   \
        } else {                                        \
            dispatch_sync(dispatch_get_main_queue(), ^{ \
                $block();                               \
            });                                         \
        }                                               \
    }

@implementation ELMEnvironmentManager

+ (void)setEnvironment:(ELMEnvironment)environment {
    if (Environment == environment)
        return;

    execute_block_on_main_thread(^{
        [[NSNotificationCenter defaultCenter] postNotificationName:ELMNotificationWillChangeEnvironment object:nil];
        Environment = environment;
        [[NSNotificationCenter defaultCenter] postNotificationName:ELMNotificationDidChangeEnvironment object:nil];
    });
}

+ (ELMEnvironment)environment {
    return Environment;
}

+ (BOOL)isProduction {
    return Environment == ELMEnvProduction;
}

+ (BOOL)isStaging {
    return Environment == ELMEnvStaging;
}

@end

@implementation ELMEnvironmentManager (ELMEnvironmentManager_Deprecated)

+ (void)setEnv:(ELMEnvironment)environment {
    [self setEnvironment:environment];
}

+ (ELMEnvironment)getEnvironment {
    return [self environment];
}

@end