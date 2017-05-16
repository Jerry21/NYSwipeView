//
//  ViewController.m
//  NYSwipeView
//
//  Created by yejunyou on 2017/5/16.
//  Copyright © 2017年 yejunyou. All rights reserved.
//

#import "ViewController.h"
#import "NYSwipeView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGRect frame = CGRectMake(0, 30, 300, 200);
    NSArray *images = @[@"img_00",
                        @"img_01",
                        @"img_02",
                        @"img_03",
                        @"img_04"
//                        @"https://ss0.bdstatic.com/5aV1bjqh_Q23odCf/static/superman/img/logo/bd_logo1_31bdc765.png",
//                        @"https://ss2.baidu.com/6ONYsjip0QIZ8tyhnq/it/u=2393835635,3743586531&fm=80&w=179&h=119&img.JPEG",
//                        @"https://ss0.baidu.com/6ONWsjip0QIZ8tyhnq/it/u=3113070873,2895720687&fm=80&w=179&h=119&img.GIF"
                        ];
    NYSwipeView *swipeV = [[NYSwipeView alloc] initWithFrame:frame ImageArray:images];
    [self.view addSubview:swipeV];
}

@end
