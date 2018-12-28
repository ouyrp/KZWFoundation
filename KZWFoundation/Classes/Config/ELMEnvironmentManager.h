//
//  ELMEnvironmentManager.h
//  ELMFoundation
//
//  Created by Draveness on 8/26/16.
//  Copyright (c) 2016 eleme. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, ELMEnv) {
    ELMEnvTesting = 1,
    ELMEnvStaging,
    ELMEnvBeta,
    ELMEnvAlpha,
    ELMEnvProduction,
};

typedef ELMEnv ELMEnvironment;

/**
 *  `ELMNotificationWillChangeEnvironment` will fire before global environment changes.
 */
extern NSString *const ELMNotificationWillChangeEnvironment;


/**
 *  `ELMNotificationDidChangeEnvironment` will fire after global environment changes.
 */
extern NSString *const ELMNotificationDidChangeEnvironment;

/**
 *  ELMEnvironmentManager manages a global environemnt variable which indicates current
 *  application's environment is production, testing or alpha and etc. You will receive
 *  two different notifications before and after global environment changes.
 */
@interface ELMEnvironmentManager : NSObject

/**
 *  Change global environment, different notifications will fire before and after set
 *  global static variable. Default is `ELMEnvProduction`.
 *
 *  @param environment ELMEnvironment
 */
+ (void)setEnvironment:(ELMEnvironment)environment;

/**
 *  Return current environment.
 *
 *  @return Return a enum value which is an ELMEnvironment
 */
+ (ELMEnvironment)environment;

/**
 *  Whether the current environment is `ELMEnvProduction` or not.
 *
 *  @return A bool value indicates the current environment is `ELMEnvProduction` or not
 */
+ (BOOL)isProduction;

/**
 *  Whether the current environment is `ELMEnvStaging` or not.
 *
 *  @return A bool value indicates the current environment is `ELMEnvStaging` or not
 */
+ (BOOL)isStaging;

@end

@interface ELMEnvironmentManager (ELMEnvironmentManager_Deprecated)

+ (void)setEnv:(ELMEnv)environment __deprecated_msg("Use `+ setEnvironment:` instead of current method, will remove in 2.0.0");

+ (ELMEnv)getEnvironment __deprecated_msg("Use `+ environment` instead of current method, will remove in 2.0.0");

@end