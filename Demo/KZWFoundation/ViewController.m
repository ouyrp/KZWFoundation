//
//  ViewController.m
//  KZWFoundation
//
//  Created by ouyang on 2018/5/8.
//  Copyright © 2018年 ouyang. All rights reserved.
//

#import "ViewController.h"
#import "KZWFoundationHear.h"

@interface ViewController ()

@property  (nonatomic, strong) UIView *view;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(100, 100, 200, 20) textColor:[UIColor baseColor] font:FontSize30];
    label.text = @"啦啦啦啦";
    [self.view addSubview:label];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)view {

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
