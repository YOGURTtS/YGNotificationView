//
//  ViewController.m
//  EHINotificationView
//
//  Created by yogurts on 2018/8/28.
//  Copyright © 2018年 yogurts. All rights reserved.
//

#import "ViewController.h"
#import "EHINotificationView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    EHINotificationView *notificationView = [EHINotificationView new];
    notificationView.frame = CGRectMake(0, 20, self.view.bounds.size.width, 20);
    [self.view addSubview:notificationView];
    notificationView.noticeList = @[@"哈哈哈哈哈哈", @"呵呵呵呵"];
    notificationView.animationType = EHINotificationViewAnimationTypeCube;
    [notificationView startAnimation];
    notificationView.animationDidStart = ^{
        NSLog(@"animationDidStart");
    };
    notificationView.animationDidStop = ^{
        NSLog(@"animationDidStop");
    };
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
