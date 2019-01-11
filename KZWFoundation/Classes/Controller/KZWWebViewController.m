//
//  KZWWebViewController.m
//  KZWfinancial
//
//  Created by ouy on 2017/3/15.
//  Copyright © 2017年 ouy. All rights reserved.
//

#import "KZWWebViewController.h"
#import "ELMEnvironmentManager.h"
#import "ELMRouter.h"
#import "KZWConstants.h"
#import "KZWDSJavaScripInterface.h"
#import "KZWHUD.h"
#import "KZWNetStateView.h"
#import "KZWRouterHelper.h"
#import "NSString+ELMFoundation.h"
#import "UIButton+KZWButton.h"
#import "UIColor+KZWColor.h"
#import "WKCookieSyncManager.h"
#import <AFNetworking/UIImageView+AFNetworking.h>

@interface KZWWebViewController () <WKNavigationDelegate, KZWDSJavaScripInterfaceDelegate>

@property (strong, nonatomic) UIProgressView *progressView;
@property (strong, nonatomic) NSURL *url;
@property (strong, nonatomic) NSString *baseUrlString;
@property (copy, nonatomic) NSNumber *backType;
@property (strong, nonatomic) KZWDSJavaScripInterface *JavaScripInterface;
@property (strong, nonatomic) KZWJavascripModel *javascripModel;

@end

@implementation KZWWebViewController

+ (void)load {
    @autoreleasepool {
        [[ELMRouter sharedRouter] map:KZWWebViewControllerRouterPath toController:[self class]];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self initWebView];
    [self.view addSubview:self.progressView];
    [self getWebUrl];
    [self loadURLRequest];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.JavaScripInterface = [[KZWDSJavaScripInterface alloc] init];
    self.JavaScripInterface.delegate = self;
    [self leftBar];
}

- (void)getWebUrl {
    NSString *urlString = [self fullString:[self elm_params][KZW_WEBVIEW_PATH]];
    self.baseUrlString = urlString;
    self.url = [NSURL URLWithString:[urlString elm_URLDecodedString]];
}

- (void)leftBar {
    NSString *bundlePath = [[NSBundle bundleForClass:[KZWNetStateView class]].resourcePath
        stringByAppendingPathComponent:@"/KZWFundation.bundle"];
    NSBundle *resource_bundle = [NSBundle bundleWithPath:bundlePath];
    UIImage *image = [UIImage imageNamed:@"ic_colorback.png"
                                inBundle:resource_bundle
           compatibleWithTraitCollection:nil];
    UIBarButtonItem *itemone = [[UIBarButtonItem alloc] initWithCustomView:({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:image forState:UIControlStateNormal];
        [button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        button.frame = CGRectMake(0, 0, 30, 30);
        button;
    })];
    self.navigationItem.leftBarButtonItems = @[ itemone ];
}

- (void)setNavTitl:(KZWJavascripModel *)model {
    self.javascripModel = model;
    if (model.leftImg) {
        UIBarButtonItem *itemone = [[UIBarButtonItem alloc] initWithCustomView:({
            UIImageView *image = [[UIImageView alloc] init];
            [image setImageWithURL:[NSURL URLWithString:model.leftImg]];
            image;
        })];
        [self.navigationItem.leftBarButtonItem setAction:@selector(back)];
        self.navigationItem.leftBarButtonItems = @[ itemone ];
    }

    if (model.titleBg) {
        self.navigationItem.titleView.backgroundColor = [UIColor colorWithHexString:model.titleBg];
        self.navigationItem.titleView.tintColor = [UIColor whiteColor];
    } else {
        self.navigationItem.titleView.backgroundColor = [UIColor whiteColor];
        self.navigationItem.titleView.tintColor = [UIColor colorWithHexString:FontColor333333];
    }

    if (model.rightStr) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:({
            UIButton *rightButton = [[UIButton alloc] initWithType:KZWButtonTypeDefault normalTitle:model.rightStr titleFont:16 cornerRadius:0];
            rightButton.frame = CGRectMake(0, 0, 70, 30);
            rightButton.tag = 1;
            [rightButton addTarget:self action:@selector(rightAction:) forControlEvents:UIControlEventTouchUpInside];
            rightButton;
        })];
    } else if (model.rightImg) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:({
            UIImageView *image = [[UIImageView alloc] init];
            [image setImageWithURL:[NSURL URLWithString:model.rightImg]];
            image;
        })];
        [self.navigationItem.rightBarButtonItem setAction:@selector(rightAction:)];
    } else {
        self.navigationItem.rightBarButtonItem = nil;
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)initWebView {
    WKUserContentController *userContentController = WKUserContentController.new;
    WKUserScript *cookieScript = [[WKUserScript alloc]
          initWithSource:[NSString stringWithFormat:@"document.cookie = '%@'", [self setCurrentCookie]]
           injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:NO];
    [userContentController addUserScript:cookieScript];
    WKCookieSyncManager *cookiesManager = [WKCookieSyncManager sharedWKCookieSyncManager];
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
    configuration.processPool = cookiesManager.processPool;
    configuration.userContentController = userContentController;
    self.webView = [[DWKWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - KZW_StatusBarAndNavigationBarHeight) configuration:configuration];
    if (KZW_iPhoneX) {
        self.webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    self.webView.scrollView.bounces = NO;
    self.webView.navigationDelegate = self;
    [self.view addSubview:self.webView];
    [self.webView addJavascriptObject:self.JavaScripInterface namespace:nil];
    [self.webView addObserver:self
                   forKeyPath:NSStringFromSelector(@selector(estimatedProgress))
                      options:0
                      context:nil];
    [self.webView addObserver:self forKeyPath:NSStringFromSelector(@selector(title)) options:NSKeyValueObservingOptionNew context:NULL];
}

- (NSString *)readCurrentCookie {
    return @"";
}

- (NSString *)setCurrentCookie {
    return @"";
}

- (void)rightAction:(UIButton *)sender {
    if ([self.javascripModel.rightUrl containsString:@"#app.share"]) {
        //        KZWShareModel *model = self.javascripModel.shareContent;
        //        [KZWShareService wxShareWithImages:@[model.imageUrl] shareTitle:model.title shareContent:model.content shareURLString:model.url response:^(id responseData) {
        //
        //        }];
    } else {
        [KZWRouterHelper pushbyPath:self.javascripModel.rightUrl];
    }
}

- (UIProgressView *)progressView {
    if (!_progressView) {
        _progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
        _progressView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 2);

        [_progressView setTrackTintColor:[UIColor clearColor]];
        _progressView.progressTintColor = [UIColor baseColor];
    }
    return _progressView;
}

- (void)loadURLRequest {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:self.url];
    [request addValue:[self readCurrentCookie] forHTTPHeaderField:@"Cookie"];
    [self.webView loadRequest:request];
}

#pragma mark wkwebdelegate
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    self.progressView.hidden = NO;
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    NSString *urlString = [[navigationAction.request URL] absoluteString];
    urlString = [urlString stringByRemovingPercentEncoding]; //解析url
    //url截取根据自己业务增加代码
    if ([[navigationAction.request.URL host] isEqualToString:@"itunes.apple.com"] && [[UIApplication sharedApplication] openURL:navigationAction.request.URL]) {
        decisionHandler(WKNavigationActionPolicyCancel);
    } else if ([urlString hasPrefix:@"tel"]) {
        decisionHandler(WKNavigationActionPolicyCancel);
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
    } else {
        decisionHandler(WKNavigationActionPolicyAllow);
    }
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
}

- (WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures {
    if (!navigationAction.targetFrame.isMainFrame) {
        [KZWRouterHelper pushbyPath:navigationAction.request.URL.absoluteString];
    }
    return nil;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey, id> *)change
                       context:(void *)context {
    if ([keyPath isEqualToString:NSStringFromSelector(@selector(estimatedProgress))] && object == self.webView) {
        [self.progressView setAlpha:1.0f];
        BOOL animated = self.webView.estimatedProgress > self.progressView.progress;
        [self.progressView setProgress:self.webView.estimatedProgress
                              animated:animated];
        if (self.webView.estimatedProgress >= 1.0f) {
            @WeakObj(self)
                [UIView animateWithDuration:0.3f
                    delay:0.3f
                    options:UIViewAnimationOptionCurveEaseOut
                    animations:^{
                        @StrongObj(self)
                            [self.progressView setAlpha:0.0f];
                    }
                    completion:^(BOOL finished) {
                        @StrongObj(self)
                            [self.progressView setProgress:0.0f animated:NO];
                    }];
        }
    } else if ([keyPath isEqualToString:@"title"]) {
        if (object == self.webView) {
            NSString *title = [self elm_params][KZW_TITLE];
            if (title.length <= 0 && self.webView.title.length <= 0) {
                self.title = @"xxxx";
            } else {
                self.title = (title.length > 0) ? title : self.webView.title;
            }
        } else {
            [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        }
    } else {
        [super observeValueForKeyPath:keyPath
                             ofObject:object
                               change:change
                              context:context];
    }
}

- (void)dismissModalStack {
    UIViewController *vc = self.presentingViewController;
    while (vc.presentingViewController) {
        vc = vc.presentingViewController;
    }
    [vc dismissViewControllerAnimated:YES completion:NULL];
}

- (void)back {
    if ([self.webView canGoBack]) {
        [self.webView goBack];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)comeBack:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSString *)fullString:(NSString *)path {
    NSString *domain = nil;
    switch ([ELMEnvironmentManager environment]) {
        case ELMEnvBeta:
            domain = @"xxxxx";
            break;
        case ELMEnvAlpha:
            domain = @"xxxxx";
            break;
        case ELMEnvProduction:
            domain = @"xxxxx";
            break;
        default:
            domain = @"xxxxx";
            break;
    }
    if ([path containsString:@"http"]) {
        return path;
    } else {
        return [domain stringByAppendingString:path];
    }
}

- (void)dealloc {
    self.webView.UIDelegate = nil;
    [self.webView stopLoading];
    [self.webView removeObserver:self forKeyPath:NSStringFromSelector(@selector(estimatedProgress))];
    [self.webView removeObserver:self forKeyPath:NSStringFromSelector(@selector(title))];
    self.webView = nil;
}

@end
