//
//  UIViewController+ELMRouter.h
//  ELMRouter
//
//  Created by 0oneo on 4/20/15.
//  Copyright (c) 2015 0oneo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (ELMRouter)

@property (nonatomic, strong) NSDictionary *elm_params;

/**
 *  Define ViewController required keys
 *
 *  @return An `NSSet` instance contains keys that viewController requires.
 */
+ (NSSet *)elm_requiredKeys;

@end
