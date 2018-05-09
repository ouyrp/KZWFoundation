//
//  FMWKWebViewBridge.h
//  FMWebViewJavascriptBridge
//
//  Created by 沈强 on 2017/3/10.
//  Copyright © 2017年 沈强. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>

@interface FMWKWebViewBridge : NSObject

@property(nonatomic, readonly)WKWebView *webview;

+ (instancetype)wkwebViewBridge:(WKWebView *)webView;

- (void)addJavascriptInterface:(NSObject *)interface withName:(NSString *)name;

- (void)addJavascriptInterfaces:(NSDictionary *)interfaces;

@end
