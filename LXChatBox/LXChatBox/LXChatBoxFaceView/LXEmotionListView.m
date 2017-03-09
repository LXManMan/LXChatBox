
//
//  LXEmotionListView.m
//  LXChatBox
//
//  Created by zlwl001 on 2017/3/8.
//  Copyright © 2017年 manman. All rights reserved.
//

#import "LXEmotionListView.h"
#import "LXEmotionPageView.h"
#define  topLineH 0.5
@interface LXEmotionListView()<UIScrollViewDelegate>
@property(nonatomic,strong)UIView *topLine;
@property(nonatomic,strong)UIScrollView *scrollview;
@property(nonatomic,strong)UIPageControl *pageControl;
@end
@implementation LXEmotionListView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor =LBColor(237, 237, 246);
       
        [self topLine];
        [self scrollview];
        [self pageControl];
    }
    return self;
}
-(void)layoutSubviews{
    [super layoutSubviews];
    self.pageControl.width =  self.width;
    self.pageControl.height = 10;
    self.pageControl.x =0;
    self.pageControl.y = self.height - self.pageControl.height;
    
    self.scrollview.width = self.width;
    self.scrollview.height = self.pageControl.y;
    self.scrollview.x = self.scrollview.y = 0;
    
    NSUInteger count = self.scrollview.subviews.count;
    for (int i =0 ; i< count; i++) {
        LXEmotionPageView *pageview = self.scrollview.subviews[i];
        pageview.width = self.scrollview.width ;
        pageview.height = self.scrollview.height;
        pageview.x = i *pageview.width;
        pageview.y = 0;
    }
    self.scrollview.contentSize =CGSizeMake(count *self.scrollview.width, 0);
}
-(void)setEmotions:(NSArray *)emotions{
    _emotions = emotions;
    [self.scrollview.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    NSUInteger count = (emotions.count + LXEmotionPageSize -1)/LXEmotionPageSize;
    self.pageControl.numberOfPages = count;
    for (int i = 0; i< count; i++) {
        LXEmotionPageView *pageView =[[LXEmotionPageView alloc]init];
        NSRange range;
        range.location  =   i * LXEmotionPageSize;
        NSUInteger left =   emotions.count - range.location;//剩余
        if (left >= LXEmotionPageSize) {
            range.length = LXEmotionPageSize;
        }else{
            range.length = left;
        }
        pageView.emotions = [emotions subarrayWithRange:range];
        [self.scrollview addSubview:pageView];
    }
    [self setNeedsLayout];
}
#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    double pageNum                = scrollView.contentOffset.x/scrollView.width;
    self.pageControl.currentPage  = (int)(pageNum+0.5);
}
- (UIView *)topLine
{
    if (!_topLine) {
        UIView * topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenW,topLineH)];
        [self addSubview:topLine];
        topLine.backgroundColor = LBColor (188.0, 188.0, 188.0);
        _topLine = topLine;
    }
    return _topLine;
}
-(UIPageControl *)pageControl{
    if (!_pageControl) {
        _pageControl =[[UIPageControl alloc]init];
        [self addSubview:_pageControl];
        _pageControl.currentPageIndicatorTintColor =[UIColor grayColor];
        _pageControl.pageIndicatorTintColor =[UIColor lightGrayColor];
        _pageControl.userInteractionEnabled = NO;
    }
    return _pageControl;
}
-(UIScrollView *)scrollview{
    if (!_scrollview) {
        _scrollview =[[UIScrollView alloc]init];
        _scrollview.showsVerticalScrollIndicator = NO;
        _scrollview.showsHorizontalScrollIndicator = NO;
        _scrollview.pagingEnabled = YES;
        _scrollview.delegate = self;
        [self addSubview:_scrollview];
    }
    return _scrollview;
}
@end
