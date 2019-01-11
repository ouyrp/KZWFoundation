//
//  KZWWebViewController.h
//  KZWfinancial
//
//  Created by ouy on 2017/3/15.
//  Copyright © 2017年 ouy. All rights reserved.
//

#import "KZWViewController.h"
#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import <dsBridge/dsBridge.h>

@interface KZWWebViewController : KZWViewController
@property (nonatomic, strong) DWKWebView *webView;
@end
