//
//  UIApplication+ELMFoundation.m
//  ELMFoundation
//
//  Created by Andy on 4/20/15.
//  Copyright (c) 2015 eleme. All rights reserved.
//

#import "UIApplication+ELMFoundation.h"

@implementation UIApplication (ELMFoundation)

+ (NSString *)elm_version {
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
}

+ (NSString *)elm_bundleID {
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleIdentifier"];
}

+ (NSString *)elm_userAgent {
    return [NSMutableString stringWithString:[[UIWebView new] stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"]];
}

+ (void)elm_clearAllLocalNotifications {
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:1];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
}


@end
