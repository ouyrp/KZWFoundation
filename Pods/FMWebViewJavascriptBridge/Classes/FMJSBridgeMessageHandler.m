//
//  FMJSBridgeMessageHandler.m
//  FMWebViewJavascriptBridge
//
//  Created by 沈强 on 2017/3/10.
//  Copyright © 2017年 沈强. All rights reserved.
//

#import "FMJSBridgeMessageHandler.h"
#import "FMWKWebViewBridge+Private.h"
#import "NSObject+FMAnnotation.h"

#define FMCallBackId @"callbackId"
#define FMJSFunctionArgsData @"jsFunctionArgsData"

@interface FMJSBridgeMessageHandler () {
  __weak FMWKWebViewBridge *_webViewBridge;
}
@end

@implementation FMJSBridgeMessageHandler

- (instancetype)initWithWebViewBridge:(FMWKWebViewBridge *)webViewBridge {
  if (self = [super init]) {
    _webViewBridge = webViewBridge;
  }
  return self;
}

- (void)userContentController:(WKUserContentController *)userContentController
      didReceiveScriptMessage:(WKScriptMessage *)message {
  
  if (![message.body isKindOfClass:[NSDictionary class]]) {
    
#if DEBUG
    NSLog(@"FMJSBridgeMessageHandler: WARNING: Invalid message.body ,is not a dictionary,received: %@",
          [message.body class]);
#endif
    
    return;
  }
  
  NSDictionary *body = message.body;
  NSString *object = body[@"module"];
  NSString *method = body[@"method"];
  NSParameterAssert(object);
  NSParameterAssert(method);
  
  [self callNative:object method:method arguments:body[@"args"]];
  
}


- (void)callNative:(NSString *)module
            method:(NSString *)method
         arguments:(NSArray *)arguments {
  
  id interface = _webViewBridge.javascriptInterfaces[module];
  
  NSString *methodName = [interface methodAnnotations][method];
  
  NSParameterAssert(interface);
  NSParameterAssert(methodName);
  
  SEL selector = NSSelectorFromString(methodName);
  
  NSMethodSignature *sig = [interface methodSignatureForSelector:selector];
  
  NSParameterAssert(sig);
  if (!sig) {
    [self raiseException:@"method not fount" message:[NSString stringWithFormat:@"module %@ selectot %@ not found ",module,methodName]];
    return;
  }
  
  NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:sig];
  invocation.selector = selector;
  invocation.target = interface;
  
  if (sig.numberOfArguments-2 != arguments.count ) {
    [self raiseException:@"arguments error" message:[NSString stringWithFormat:@"module %@ selectot %@ arguments error,expect %@ but get %@",module,methodName,@(sig.numberOfArguments-2),@(arguments.count)]];
    return;
  }
  
  NSMutableArray<dispatch_block_t> *argumentBlocks = [[NSMutableArray alloc] initWithCapacity:sig.numberOfArguments - 2];
  
  
#define FM_CASE(_typeChar, _type, _typeSelector, i)                        \
case _typeChar: {                                                           \
if (argument && ![argument isKindOfClass:[NSNumber class]]) {                \
[self raiseException:@"args type" message:@"args type  error"];               \
return;                                                                        \
}                                                                               \
_type argumentValue = [(NSNumber *)argument _typeSelector];                      \
[argumentBlocks addObject:^() {                                                   \
[invocation setArgument:&argumentValue atIndex:i];                                 \
}];                                                                                 \
break;                                                                               \
}
  
  for (int i=2; i<sig.numberOfArguments; i++) {
    
    const char *argumentType = [sig getArgumentTypeAtIndex:i];
    static const char *blockType = @encode(typeof(^{}));
    id argument = arguments[i-2];
    #pragma clang diagnostic push
    #pragma clang diagnostic ignored "-Wincompatible-pointer-types-discards-qualifiers"
    if (!strcmp(argumentType, blockType)) {
      FMCallBack responseCallback = [^(id result) {
        if (result == nil) {
          result = [NSNull null];
        }
        NSDictionary *msg = @{FMCallBackId:argument, FMJSFunctionArgsData:result};
        [self queueMessage:msg];
      } copy];
      [argumentBlocks addObject:^ {
        [invocation setArgument:&responseCallback atIndex:i];
      }];
    } else {
      switch (argumentType[0]) {
          FM_CASE('c', char, charValue, i)
          FM_CASE('C', unsigned char, unsignedCharValue, i)
          FM_CASE('s', short, shortValue, i)
          FM_CASE('S', unsigned short, unsignedShortValue, i)
          FM_CASE('i', int, intValue, i)
          FM_CASE('I', unsigned int, unsignedIntValue, i)
          FM_CASE('l', long, longValue, i)
          FM_CASE('L', unsigned long, unsignedLongValue, i)
          FM_CASE('q', long long, longLongValue, i)
          FM_CASE('Q', unsigned long long, unsignedLongLongValue, i)
          FM_CASE('f', float, floatValue, i)
          FM_CASE('d', double, doubleValue, i)
          FM_CASE('B', BOOL, boolValue, i)
     #pragma clang diagnostic pop
        default:
          [invocation setArgument:&argument atIndex:i];
          break;
      }
      
    }
  }

  for (dispatch_block_t argumentBlock in argumentBlocks) {
    argumentBlock();
  }
  
  [invocation invoke];
  
}

- (void)queueMessage:(NSDictionary *)message {
  
  NSString *messageJSON = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:message
                                                                                         options:(NSJSONWritingOptions)(0)
                                                                                           error:nil]
                                                encoding:NSUTF8StringEncoding];;
  messageJSON = [self filterJsonString:messageJSON];
  
  NSString *javascriptCommand = [NSString
                                 stringWithFormat:@"WebViewJavascriptBridge.handleMessageFromNative('%@');",
                                 messageJSON];
#define FM_MAIN_EXCUTE(block)                          \
if ([[NSThread currentThread] isMainThread]) {          \
block();                                                 \
} else {                                                  \
dispatch_sync(dispatch_get_main_queue(), ^{                \
block();                                                    \
});                                                          \
}                                                             \

  FM_MAIN_EXCUTE(^{
    [_webViewBridge.webview evaluateJavaScript:javascriptCommand completionHandler:nil];
  })
  
}

- (NSString *)filterJsonString:(NSString *)messageJSON {
  messageJSON = [messageJSON stringByReplacingOccurrencesOfString:@"\\"
                                                       withString:@"\\\\"];
  messageJSON = [messageJSON stringByReplacingOccurrencesOfString:@"\""
                                                       withString:@"\\\""];
  messageJSON = [messageJSON stringByReplacingOccurrencesOfString:@"\'"
                                                       withString:@"\\\'"];
  messageJSON = [messageJSON stringByReplacingOccurrencesOfString:@"\n"
                                                       withString:@"\\n"];
  messageJSON = [messageJSON stringByReplacingOccurrencesOfString:@"\r"
                                                       withString:@"\\r"];
  messageJSON = [messageJSON stringByReplacingOccurrencesOfString:@"\f"
                                                       withString:@"\\f"];
  messageJSON = [messageJSON stringByReplacingOccurrencesOfString:@"\u2028"
                                                       withString:@"\\u2028"];
  messageJSON = [messageJSON stringByReplacingOccurrencesOfString:@"\u2029"
                                                       withString:@"\\u2029"];
  return messageJSON;
}


- (void)raiseException:(NSString *)name message:(NSString *)reason {
#if DEBUG
  NSException *exception =
  [[NSException alloc] initWithName:name reason:reason userInfo:nil];
  [exception raise];
#endif
}


@end
