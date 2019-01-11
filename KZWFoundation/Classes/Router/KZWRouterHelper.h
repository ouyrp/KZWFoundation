//
//  KZWRouterHelper.h
//  KZWfinancial
//
//  Created by ouy on 2017/3/15.
//  Copyright © 2017年 ouy. All rights reserved.
//

#import "KZWWebViewController.h"
#import "NSURL+ELMFoundation.h"
#import <Foundation/Foundation.h>

#define KZW_WEBVIEW_PATH @"path"
#define KZW_TITLE @"title"
#define KZW_WEBVIEW_FULLURL @"fullUrl"
#define KZW_NAV_BAR_HIDDEN @"fullScreen"
#define KZW_WEBVIEW_TITLEBGCOLOR @"titleBgColor"
#define KZWWebViewControllerRouterPath @"KZWWebViewController"
#define KZW_Native_Back @"needBack"
#define KZW_BACK_TYPE @"backType"


#define KZW_NAV_HIDDEN(x) \
    KZW_NAV_BAR_HIDDEN:   \
    @(x)

#define LPD_ROUTER_URL(path, params) \
    [NSString stringWithFormat:@"%@?%@", path, [NSURL elm_queryStringFromParameters:params]]


@interface KZWRouterHelper : NSObject

@property (nonatomic, weak) KZWWebViewController *webViewController;

- (instancetype)initWithKZWWebViewController:(KZWWebViewController *)KZWWebViewController;

+ (void)userLogout;

+ (UIViewController *)rootController;

+ (UIViewController *)getCurrentVC;

+ (void)pushbyPath:(NSString *)path;

+ (UIViewController *)routeWebController:(NSString *)path navgtionBarHidden:(BOOL)hidden navigationTitle:(NSString *)string;


@end
