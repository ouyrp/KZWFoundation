//
//  KZWDSJavaScripInterface.m
//  kongzhongfinancial
//
//  Created by ouyang on 2018/5/4.
//  Copyright © 2018年 ouy. All rights reserved.
//

#import "KZWDSJavaScripInterface.h"
#import <Mantle/Mantle.h>

@implementation KZWDSJavaScripInterface

- (void)share:(id)data {
    NSLog(@"data class: %@, body is %@", [data class], [data debugDescription]);
    NSError *error = nil;
    KZWShareModel *model = [MTLJSONAdapter modelOfClass:KZWShareModel.class fromJSONDictionary:data error:&error];
    //    [KZWShareService wxShareWithImages:@[model.imageUrl] shareTitle:model.title shareContent:model.content shareURLString:model.url response:^(id responseData) {
    //
    //    }];
}

- (void)setNavTitle:(id)data {
    NSError *error = nil;
    KZWJavascripModel *model = [MTLJSONAdapter modelOfClass:KZWJavascripModel.class fromJSONDictionary:data error:&error];
    [self.delegate setNavTitl:model];
}

//替换网页截取跳转，由网页自己来控制该跳原生的哪个界面
- (void)openNativePage:(id)data {
    NSError *error = nil;
    KZWWebControllerModel *model = [MTLJSONAdapter modelOfClass:KZWWebControllerModel.class fromJSONDictionary:data error:&error];
    //用router根据controllerName来进行相应的跳转，如果页面还包含其他必须参数在KZWWebControllerModel中添加即可
}

@end
