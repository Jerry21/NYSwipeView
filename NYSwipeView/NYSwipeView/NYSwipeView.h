//
//  NYSwipeView.h
//  NYSwipeView
//
//  Created by yejunyou on 2017/5/16.
//  Copyright © 2017年 yejunyou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NYSwipeView : UIView
@property (strong, nonatomic) NSArray *images;

- (instancetype)initWithFrame:(CGRect)frame ImageArray:(NSArray *)image;
@end
