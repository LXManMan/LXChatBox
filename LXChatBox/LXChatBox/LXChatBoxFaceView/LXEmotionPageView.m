//
//  LXEmotionPageView.m
//  LXChatBox
//
//  Created by zlwl001 on 2017/3/8.
//  Copyright © 2017年 manman. All rights reserved.
//

#import "LXEmotionPageView.h"
#import "LXEmotion.h"
#import "LXEmotionManager.h"
#import "LXEmotionButton.h"
@interface LXEmotionPageView()
@property(nonatomic,strong)UIButton *deleteBtn;
@end
@implementation LXEmotionPageView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.deleteBtn setImage:[UIImage imageNamed:@"emotion_delete"] forState:UIControlStateNormal];
        [self.deleteBtn addTarget:self action:@selector(deleteBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.deleteBtn];
    }
    return self;
}
#pragma mark--每一页的最后一个按钮---
-(void)deleteBtn:(UIButton *)button
{
    //可以发送通知
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:LXEmotionDidDeleteNotification object:nil];// 通知出去
    
}
-(void)setEmotions:(NSArray *)emotions{
    _emotions = emotions;
    NSUInteger count = emotions.count;
    for (int i =0; i<count; i++) {
        LXEmotionButton *button =[[LXEmotionButton alloc]init];
        [self addSubview:button];
        
        button.emotion = emotions[i];
        [button addTarget:self action:@selector(emotionBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat inset            = 15;
    NSUInteger count         = self.emotions.count;
    CGFloat btnW             = (self.width - 2*inset)/LXEMotionMaxCols;
    CGFloat btnH             = (self.height - 2*inset)/LXEmotionMaxRows;
    for (int i = 0; i < count; i ++) {
        LXEmotionButton *btn = self.subviews[i + 1];//因为已经加了一个deleteBtn了
        btn.width            = btnW;
        btn.height           = btnH;
        btn.x                = inset + (i % LXEMotionMaxCols)*btnW;
        btn.y                = inset + (i / LXEMotionMaxCols)*btnH;
    }
    self.deleteBtn.width     = btnW;
    self.deleteBtn.height    = btnH;
    self.deleteBtn.x         = inset + (count%LXEMotionMaxCols)*btnW;
    self.deleteBtn.y         = inset + (count/LXEMotionMaxCols)*btnH;
}
#pragma mark---表情按钮的点击方法---
- (void)emotionBtnClicked:(LXEmotionButton *)button
{
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    userInfo[LXSelectEmotionKey]  = button.emotion;
    [[NSNotificationCenter defaultCenter] postNotificationName:LXEmotionDidSelectNotification object:nil userInfo:userInfo];
    
}

@end
