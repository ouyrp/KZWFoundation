//
//  FMWKWebViewBridge.m
//  FMWebViewJavascriptBridge
//
//  Created by 沈强 on 2017/3/10.
//  Copyright © 2017年 沈强. All rights reserved.
//

#import "FMWKWebViewBridge.h"
#import "FMJSBridgeMessageHandler.h"
#import "NSObject+FMAnnotation.h"

@interface FMWKWebViewBridge ()

@property(nonatomic, strong)NSMutableDictionary *javascriptInterfaces;

@end

@implementation FMWKWebViewBridge

+ (instancetype)wkwebViewBridge:(WKWebView *)webView {
  return [[FMWKWebViewBridge alloc] initWithWKWebView:webView];
}

- (instancetype)initWithWKWebView:(WKWebView *)webView {
  if (self = [super init]) {
    _webview = webView;
    [self webViewBridgeSetup];
  }
  return self;
}

- (NSMutableDictionary *)javascriptInterfaces {
  if (!_javascriptInterfaces) {
    _javascriptInterfaces = [[NSMutableDictionary alloc] init];
  }
  return _javascriptInterfaces;
}

- (void)addJavascriptInterfaces:(NSDictionary *)interfaces {
  NSParameterAssert(interfaces);
  [self.javascriptInterfaces addEntriesFromDictionary:interfaces];
  WKUserScript *userScript = [[WKUserScript alloc] initWithSource:[self injectJavascript:interfaces] injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:NO];
  [_webview.configuration.userContentController addUserScript:userScript];
}

- (void)addJavascriptInterface:(NSObject *)interface withName:(NSString *)name {
  NSParameterAssert(interface);
  NSParameterAssert(name);
  [self.javascriptInterfaces setValue:interface forKey:name];
  WKUserScript *userScript = [[WKUserScript alloc] initWithSource:[self injectJavascript:@{name:interface}] injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:NO];
  [_webview.configuration.userContentController addUserScript:userScript];
}

- (NSString *)injectJavascript:(NSDictionary *)javascriptInterfaces {
  
  NSBundle *bundle = [NSBundle bundleForClass:[self class]];
  NSString *filePath =
  [bundle pathForResource:@"FMWebViewJavascriptBridge" ofType:@"js"];
  NSString *content = [NSString stringWithContentsOfFile:filePath
                                                encoding:NSUTF8StringEncoding
                                                   error:nil];
  
  NSMutableDictionary *injectInterfaces = [NSMutableDictionary dictionary];
  
  for (NSString *key in javascriptInterfaces.allKeys) {
    NSObject *interface = javascriptInterfaces[key];
    [injectInterfaces setValue:[interface methodAnnotations].allKeys forKey:key];
  }
  
  NSString *jsInjectInterfaces = [self serializeMessage:injectInterfaces];
  
  return [NSString stringWithFormat:@"%@(%@);",content,jsInjectInterfaces];
}

- (NSString *)serializeMessage:(id)message {
  return [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:message
                                                                        options:(NSJSONWritingOptions)(0)
                                                                          error:nil]
                               encoding:NSUTF8StringEncoding];
}


- (void)webViewBridgeSetup {
  
  FMJSBridgeMessageHandler *messageHandler = [[FMJSBridgeMessageHandler alloc] initWithWebViewBridge:self];
  [_webview.configuration.userContentController addScriptMessageHandler:messageHandler name:@"fm_webViewBridge"];
  
}



@end
