//
//  UIControl+Block.m
//  LPDAdditions
//
//  Created by foxsofter on 15/2/23.
//  Copyright (c) 2015年 foxsofter. All rights reserved.
//

#import "UIControl+Block.h"
#import "NSObject+LPDAssociatedObject.h"

#define UIControlEventImpl(methodName, eventName)                                                               \
    -(void)methodName : (void (^)(void))eventBlock {                                                            \
        [self setCopyNonatomicObject:eventBlock withKey:@selector(methodName:)];                                \
        [self addTarget:self action:@selector(methodName##Action:) forControlEvents:UIControlEvent##eventName]; \
    }                                                                                                           \
    -(void)methodName##Action : (id)sender {                                                                    \
        void (^block)() = [self object:@selector(methodName:)];                                                 \
        if (block) {                                                                                            \
            block();                                                                                            \
        }                                                                                                       \
    }

@interface UIControl ()

@end

@implementation UIControl (Block)

UIControlEventImpl(touchDown, TouchDown);
UIControlEventImpl(touchDownRepeat, TouchDownRepeat);
UIControlEventImpl(touchDragInside, TouchDragInside);
UIControlEventImpl(touchDragOutside, TouchDragOutside);
UIControlEventImpl(touchDragEnter, TouchDragEnter);
UIControlEventImpl(touchDragExit, TouchDragExit);
UIControlEventImpl(touchUpInside, TouchUpInside);
UIControlEventImpl(touchUpOutside, TouchUpOutside);
UIControlEventImpl(touchCancel, TouchCancel);
UIControlEventImpl(valueChanged, ValueChanged);
UIControlEventImpl(editingDidBegin, EditingDidBegin);
UIControlEventImpl(editingChanged, EditingChanged);
UIControlEventImpl(editingDidEnd, EditingDidEnd);
UIControlEventImpl(editingDidEndOnExit, EditingDidEndOnExit);

@end
