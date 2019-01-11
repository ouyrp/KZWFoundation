//
//  UINavigationController+KZWBackButtonHandler.h
//  kongzhongfinancial
//
//  Created by ouy on 2017/7/12.
//  Copyright © 2017年 ouy. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BackButtonHandlerProtocol <NSObject>
@optional
// 重写下面的方法以拦截导航栏返回按钮点击事件，返回 YES 则 pop，NO 则不 pop
- (BOOL)navigationShouldPopOnBackButton;
@end

@interface UIViewController (ShouldPopOnBackButton) <BackButtonHandlerProtocol>

@end

@interface UINavigationController (KZWBackButtonHandler)

- (BOOL)navigationBar:(UINavigationBar *)navigationBar shouldPopItem:(UINavigationItem *)item;

@end
