//
//  NYSwipeView.m
//  NYSwipeView
//
//  Created by yejunyou on 2017/5/16.
//  Copyright © 2017年 yejunyou. All rights reserved.
//

#import "NYSwipeView.h"

@interface NYSwipeView ()<UIScrollViewDelegate>
{
    NSInteger kImageCount;
    UIImageView *previousClickedImageView;
}
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) NSTimer *timer;
@property (strong, nonatomic) UIPageControl *pageControl;
@property (nonatomic, strong) NSMutableArray *imageArray;
@end


@implementation NYSwipeView

#pragma mark - 初始化
- (instancetype)initWithFrame:(CGRect)frame ImageArray:(NSArray *)image
{
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.scrollView];
        [self addSubview:self.pageControl];
        
        kImageCount = image.count;
        
        for (int i = 0; i < kImageCount; i++)
        {
            UIImageView *imageView = [[UIImageView alloc] init];
            [self.scrollView addSubview:imageView];
            [self.imageArray addObject:imageView];
            NSString *imageName = image[i];
            imageView.image = [UIImage imageNamed:imageName];
            imageView.tag = i;
        }
        
        
        self.pageControl.numberOfPages = kImageCount;
        self.pageControl.currentPage = 0;
        
        [self startTimer];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {

    }
    return self;
}


#pragma mark - 设置frame 并 跟新内容
- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.scrollView.frame = self.bounds;
    self.scrollView.contentSize = CGSizeMake(kImageCount * self.bounds.size.width, 0);
    
    
    for (int i = 0; i<kImageCount; i++)
    {
        UIImageView *imageView = self.scrollView.subviews[i];
        imageView.frame = CGRectMake(i * self.scrollView.frame.size.width, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height);
    }
    
    CGFloat pageW = 80;
    CGFloat pageH = 20;
    CGFloat pageX = self.scrollView.frame.size.width - pageW;
    CGFloat pageY = self.scrollView.frame.size.height - pageH;
    self.pageControl.frame = CGRectMake(pageX, pageY, pageW, pageH);
    
    // 更新内容
    [self updateContent:self.pageControl.currentPage];
}

- (void)setImages:(NSArray *)images
{
    _images = images;
    
    // 设置页码
    self.pageControl.numberOfPages = images.count;
    self.pageControl.currentPage = 0;
    
    // 设置内容
    [self updateContent:self.pageControl.currentPage];
    
    // 开始定时器
    [self startTimer];
}

#pragma mark - <UIScrollViewDelegate>
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSLog(@"%s",__func__);
    // 找出最中间的那个图片控件
    NSInteger page = 0;
    CGFloat minDistance = MAXFLOAT;
    for (int i = 0; i < kImageCount; i++)
    {
        UIImageView *imageView = self.imageArray[i];
        CGFloat distance = 0;
        
        distance = ABS(imageView.frame.origin.y - scrollView.contentOffset.y);
      
        if (distance < minDistance)
        {
            minDistance = distance;
            page = imageView.tag;
        }
    }
    self.pageControl.currentPage = page;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    NSLog(@"%s",__func__);
    [self stopTimer];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    NSLog(@"%s",__func__);
    [self startTimer];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSLog(@"%s",__func__);
    [self updateContent:self.pageControl.currentPage];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    NSLog(@"%s",__func__);
    [self updateContent:self.pageControl.currentPage];
}

#pragma mark - 内容更新
- (void)updateContent:(NSInteger)index
{
    // 设置图片
    CGFloat scrollViewW = CGRectGetWidth(self.scrollView.frame);
    CGFloat scrollViewH = CGRectGetHeight(self.scrollView.frame);
    
    NSInteger previousIndex = [self.imageArray indexOfObject:previousClickedImageView];
    CGFloat offsetX;
    
    if ((index - previousIndex <= 1) && (index - previousIndex >= -1)){
        offsetX = self.scrollView.frame.size.width * index;
    }else if (index - previousIndex > 1){ //右移
        offsetX = self.scrollView.frame.size.width * (previousIndex + 1);
        UIImageView *iv = self.imageArray[index];
        iv.frame =  CGRectMake((previousIndex + 1) * scrollViewW, 0, scrollViewW, scrollViewH);
    }else if (index - previousIndex < 1){ //左移
        offsetX = self.scrollView.frame.size.width * (previousIndex - 1);
        UIImageView *iv = self.imageArray[index];
        iv.frame =  CGRectMake((previousIndex - 1) * scrollViewW, 0, scrollViewW, scrollViewH);
    }
    
    previousClickedImageView = self.imageArray[index];
    
    NSLog(@"idnex = %zd",index);
    self.pageControl.currentPage = self.pageControl.currentPage+1;
    // 设置偏移量在中间
    self.scrollView.contentOffset = CGPointMake(offsetX, 0);
}

#pragma mark - 定时器处理
- (void)startTimer
{
    NSTimer *timer = [NSTimer timerWithTimeInterval:2 target:self selector:@selector(next) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    self.timer = timer;
}

- (void)stopTimer
{
    [self.timer invalidate];
    self.timer = nil;
}

- (void)next
{
    [self.scrollView setContentOffset:CGPointMake(2 * self.scrollView.frame.size.width, 0) animated:YES];
}

#pragma mark - setting and getting
- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.pagingEnabled = YES;
        _scrollView.bounces = NO;
        _scrollView.delegate = self;
    }
    return _scrollView;
}

- (UIPageControl *)pageControl
{
    if(!_pageControl)
    {
        _pageControl = [[UIPageControl alloc] init];
        _pageControl.backgroundColor = [UIColor redColor];
    }
    return _pageControl;
}

- (NSMutableArray *)imageArray
{
    if (!_imageArray) {
        _imageArray = [[NSMutableArray alloc] init];
    }
    return _imageArray;
}
@end
