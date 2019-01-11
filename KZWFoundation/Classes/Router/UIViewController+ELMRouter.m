//
//  UIViewController+ELMRouter.m
//  ELMRouter
//
//  Created by 0oneo on 4/20/15.
//  Copyright (c) 2015 0oneo. All rights reserved.
//

#import "UIViewController+ELMRouter.h"
#import <objc/runtime.h>

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

@end
