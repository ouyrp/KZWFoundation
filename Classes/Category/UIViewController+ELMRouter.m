//
//  UIViewController+ELMRouter.m
//  ELMRouter
//
//  Created by 0oneo on 4/20/15.
//  Copyright (c) 2015 0oneo. All rights reserved.
//

#import "UIViewController+ELMRouter.h"
#import <objc/runtime.h>
#import "AppDelegate.h"

static char kAssociatedParamsObjectKey;

@implementation UIViewController (ELMRouter)

@dynamic elm_params;

- (NSDictionary *)elm_params {
  return objc_getAssociatedObject(self, &kAssociatedParamsObjectKey);
}

- (void)setElm_params:(NSDictionary *)elm_params {
  objc_setAssociatedObject(self, &kAssociatedParamsObjectKey, elm_params, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (NSSet *)elm_requiredKeys {
  return nil;
}

+ (UIViewController *)rootController {
    return ((AppDelegate *)[UIApplication sharedApplication].delegate).window.rootViewController;
}

+ (UIViewController *)getCurrentVCFrom {
    UIViewController *currentVC;
    UIViewController *rootVC = [self rootController];
    
    if ([rootVC presentedViewController]) {
        // 视图是被presented出来的
        
        rootVC = [rootVC presentedViewController];
    }
    
    if ([rootVC isKindOfClass:[UITabBarController class]]) {
        // 根视图为UITabBarController
        
        currentVC = [self getCurrentVCFrom];
        
    } else if ([rootVC isKindOfClass:[UINavigationController class]]){
        // 根视图为UINavigationController
        
        currentVC = [self getCurrentVCFrom];
        
    } else {
        // 根视图为非导航类
        
        currentVC = rootVC;
    }
    
    return currentVC;
}

@end
