//
//  KZWDSJavaScripInterface.h
//  kongzhongfinancial
//
//  Created by ouyang on 2018/5/4.
//  Copyright © 2018年 ouy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KZWJavascripModel.h"

@protocol KZWDSJavaScripInterfaceDelegate <NSObject>
@optional

- (void)setNavTitl:(KZWJavascripModel *)model;

@end

@interface KZWDSJavaScripInterface : NSObject

@property (weak, nonatomic) id<KZWDSJavaScripInterfaceDelegate> delegate;

@end
