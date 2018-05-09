//
//  UIApplication+ELMFoundation.h
//  ELMFoundation
//
//  Created by Andy on 4/20/15.
//  Copyright (c) 2015 eleme. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIApplication (ELMFoundation)

+ (NSString *)elm_version;

+ (NSString *)elm_bundleID;

+ (NSString *)elm_userAgent;

+ (void)elm_clearAllLocalNotifications NS_EXTENSION_UNAVAILABLE_IOS("");

@end
