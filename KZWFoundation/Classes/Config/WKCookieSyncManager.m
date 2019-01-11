//
//  WKCookieSyncManager.m
//  shoes
//
//  Created by 奉强 on 16/4/5.
//  Copyright © 2016年 saygogo. All rights reserved.
//

#import "WKCookieSyncManager.h"

@interface WKCookieSyncManager () <WKNavigationDelegate>

@property (nonatomic, strong) WKWebView *webView;

///用来测试的url这个url是不存在的
@property (nonatomic, strong) NSURL *testUrl;


@end

@implementation WKCookieSyncManager

+ (instancetype)sharedWKCookieSyncManager {
    static WKCookieSyncManager *sharedWKCookieSyncManagerInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedWKCookieSyncManagerInstance = [[self alloc] init];
    });
    return sharedWKCookieSyncManagerInstance;
}

- (void)setCookie {
    //判断系统是否支持wkWebView
    Class wkWebView = NSClassFromString(@"WKWebView");
    if (!wkWebView) {
        return;
    }
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    config.processPool = self.processPool;
    self.webView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:config];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:self.testUrl];
    self.webView.navigationDelegate = self;
    [self.webView loadRequest:request];
}

#pragma - get
- (WKProcessPool *)processPool {
    if (!_processPool) {
        static dispatch_once_t predicate;
        dispatch_once(&predicate, ^{
            _processPool = [[WKProcessPool alloc] init];
        });
    }

    return _processPool;
}

- (NSURL *)testUrl {
    if (!_testUrl) {
        NSURLComponents *urlComponents = [NSURLComponents new];
        urlComponents.host = @"duoshuo.com";
        urlComponents.scheme = @"http";
        urlComponents.path = @"/tsttsssdsds.php";
        NSLog(@"测试url=%@", urlComponents.URL);

        return urlComponents.URL;
    }

    return _testUrl;
}

#pragma mark - WKNavigationDelegate
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    //取出cookie
    NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    //js函数
    NSString *JSFuncString =
        @"function setCookie(name,value,expires)\
    {\
        var oDate=new Date();\
        oDate.setDate(oDate.getDate()+expires);\
        document.cookie=name+'='+value+';expires='+oDate;\
    }\
    function getCookie(name)\
    {\
        var arr = document.cookie.match(new RegExp('(^| )'+name+'=([^;]*)(;|$)'));\
        if(arr != null) return unescape(arr[2]); return null;\
    }\
    function delCookie(name)\
    {\
        var exp = new Date();\
        exp.setTime(exp.getTime() - 1);\
        var cval=getCookie(name);\
        if(cval!=null) document.cookie= name + '='+cval+';expires='+exp.toGMTString();\
    }";

    //拼凑js字符串
    NSMutableString *JSCookieString = JSFuncString.mutableCopy;
    for (NSHTTPCookie *cookie in cookieStorage.cookies) {
        NSString *excuteJSString = [NSString stringWithFormat:@"setCookie('%@', '%@', 1);", cookie.name, cookie.value];
        [JSCookieString appendString:excuteJSString];
    }
    //执行js
    [webView evaluateJavaScript:JSCookieString completionHandler:nil];
}

@end
