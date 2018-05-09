//
//  NSObject+FMAnnotation.m
//  FMWebViewJavascriptBridge
//
//  Created by 沈强 on 2017/3/10.
//  Copyright © 2017年 沈强. All rights reserved.
//

#import "NSObject+FMAnnotation.h"
#import <objc/runtime.h>

@implementation NSObject (FMAnnotation)

- (NSDictionary *)methodAnnotations {
  
  NSMutableDictionary *methodsMap = objc_getAssociatedObject(self, _cmd);
  if (methodsMap) {
    return methodsMap;
  }
  
  methodsMap = [NSMutableDictionary dictionary];
  Class moduleClass = self.class;
  unsigned int methodCount;
  Method *methods = class_copyMethodList(object_getClass(moduleClass), &methodCount);
  
  for (unsigned int i = 0; i < methodCount; i++) {
    
    Method method = methods[i];
    SEL selector = method_getName(method);
    
    if ([NSStringFromSelector(selector) hasPrefix:@"__fm_export__"]) {
      
      IMP imp = method_getImplementation(method);
      NSDictionary *methodMap = ((NSDictionary * (*)(id, SEL))imp)(moduleClass, selector);
      
      NSAssert(methodMap.count, @"dont export method");
      
      NSString *exportMethodName = methodMap.allKeys[0];
      
      NSAssert(exportMethodName.length, @"dont export method name error");
      
      NSRange range = [exportMethodName rangeOfString:@":"];
      NSString* name = range.location!= NSNotFound ? [exportMethodName substringToIndex:range.location] : exportMethodName;
      [methodsMap setValue:methodMap[exportMethodName] forKey:name];
      
    }
  }
  objc_setAssociatedObject(self, _cmd, methodsMap, OBJC_ASSOCIATION_COPY_NONATOMIC);
  free(methods);
  return methodsMap;
}


@end
