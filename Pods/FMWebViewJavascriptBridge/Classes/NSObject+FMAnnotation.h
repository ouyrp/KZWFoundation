//
//  NSObject+FMAnnotation.h
//  FMWebViewJavascriptBridge
//
//  Created by 沈强 on 2017/3/10.
//  Copyright © 2017年 沈强. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef FMAnnotation_h
#define FMAnnotation_h

typedef void(^FMCallBack)(id result);

#define FM_EXPORT_METHOD(method) \
FM_RENAME_METHOD(NSStringFromSelector(method),method)

#define FM_RENAME_METHOD(js_name, method) \
FM_EXTERN_RENAME_METHOD(js_name, method)            \

#define FM_EXTERN_RENAME_METHOD(js_name, method)                              \
+(NSDictionary *)FM_CONCAT(                                                     \
__fm_export__, FM_CONCAT(__LINE__, __COUNTER__)) { \
return @{js_name:NSStringFromSelector(method)};                                       \
}

#define FM_CONCAT2(A, B) A##B

#define FM_CONCAT(A, B) FM_CONCAT2(A, B)

#endif


@interface NSObject (FMAnnotation)

- (NSDictionary *)methodAnnotations;

@end
