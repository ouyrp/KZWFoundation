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
    NSLog(@"data class: %@, body is %@",[data class], [data debugDescription]);
//    NSError *error = nil;
//    KZWShareModel *model = [MTLJSONAdapter modelOfClass:KZWShareModel.class fromJSONDictionary:data error:&error];
//    [KZWShareService wxShareWithImages:@[model.imageUrl] shareTitle:model.title shareContent:model.content shareURLString:model.url response:^(id responseData) {
//
//    }];
}

- (void)setNavTitle:(id)data {
    NSError *error = nil;
    KZWJavascripModel *model = [MTLJSONAdapter modelOfClass:KZWJavascripModel.class fromJSONDictionary:data error:&error];
    [self.delegate setNavTitl:model];
}

@end
