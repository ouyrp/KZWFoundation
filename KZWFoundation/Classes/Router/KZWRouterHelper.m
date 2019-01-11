//
//  KZWRouterHelper.m
//  KZWfinancial
//
//  Created by ouy on 2017/3/15.
//  Copyright © 2017年 ouy. All rights reserved.
//

#import "KZWRouterHelper.h"
#import "ELMRouter.h"
#import "NSString+ELMFoundation.h"
#import "NSString+KZWData.h"

@implementation KZWRouterHelper

- (instancetype)initWithKZWWebViewController:(KZWWebViewController *)KZWWebViewController {
    if (self = [super init]) {
        self.webViewController = KZWWebViewController;
    }
    return self;
}

+ (void)userLogout {
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 9.0) {
        WKWebsiteDataStore *dateStore = [WKWebsiteDataStore defaultDataStore];
        [dateStore fetchDataRecordsOfTypes:[WKWebsiteDataStore allWebsiteDataTypes]
                         completionHandler:^(NSArray<WKWebsiteDataRecord *> *__nonnull records) {
                             for (WKWebsiteDataRecord *record in records) {
                                 if ([record.displayName containsString:@"xxxxx"]) {
                                     [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:record.dataTypes
                                                                               forDataRecords:@[ record ]
                                                                            completionHandler:^{
                                                                                NSLog(@"Cookies for %@ deleted successfully", record.displayName);
                                                                            }];
                                 }
                             }
                         }];
    } else {
        NSString *librarypath = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES).firstObject;
        NSString *cookiesFolderPath = [librarypath stringByAppendingString:@"/Cookies"];
        [[NSFileManager defaultManager] removeItemAtPath:cookiesFolderPath error:nil];
    }
    NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (NSHTTPCookie *cookie in [cookieJar cookies]) {
        [cookieJar deleteCookie:cookie];
    }
}

+ (UIViewController *)rootController {
    return [UIApplication sharedApplication].delegate.window.rootViewController;
}

+ (UIViewController *)getCurrentVC {
    UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;

    UIViewController *currentVC = [self getCurrentVCFrom:rootViewController];

    return currentVC;
}

+ (UIViewController *)getCurrentVCFrom:(UIViewController *)rootVC {
    UIViewController *currentVC;

    if ([rootVC presentedViewController]) {
        // 视图是被presented出来的

        rootVC = [rootVC presentedViewController];
    }

    if ([rootVC isKindOfClass:[UITabBarController class]]) {
        // 根视图为UITabBarController

        currentVC = [self getCurrentVCFrom:[(UITabBarController *)rootVC selectedViewController]];

    } else if ([rootVC isKindOfClass:[UINavigationController class]]) {
        // 根视图为UINavigationController

        currentVC = [self getCurrentVCFrom:[(UINavigationController *)rootVC visibleViewController]];

    } else {
        // 根视图为非导航类

        currentVC = rootVC;
    }

    return currentVC;
}

+ (void)pushbyPath:(NSString *)path {
    //可以根据需求自己加需要的参数
    NSDictionary *params = @{
        @"path" : [path kzw_urlEncode],
        @"timestimp" : [NSString stringWithFormat:@"%g", [[NSDate date] timeIntervalSince1970]]
    };
    NSString *url =
        [NSString stringWithFormat:@"%@?%@", KZWWebViewControllerRouterPath, [NSURL elm_queryStringFromParameters:params]];
    return [[ELMRouter sharedRouter] open:url animated:NO showStyle:ELMPageShowStylePush];
}

+ (UIViewController *)routeWebController:(NSString *)path navgtionBarHidden:(BOOL)hidden navigationTitle:(NSString *)string {
    NSDictionary *params = @{
        @"path" : path,
        @"fullScreen" : @(NO),
        @"fullUrl" : @(NO),
        @"title" : string ? string : @"",
        @"timestimp" : [NSString stringWithFormat:@"%g", [[NSDate date] timeIntervalSince1970]]
    };
    NSString *url =
        [NSString stringWithFormat:@"%@?%@", KZWWebViewControllerRouterPath, [NSURL elm_queryStringFromParameters:params]];
    return [[ELMRouter sharedRouter] controllerForUrl:url];
}

@end
