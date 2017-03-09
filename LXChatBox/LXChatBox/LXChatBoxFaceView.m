
//
//  LXChatBoxFaceView.m
//  LXChatBox
//
//  Created by zlwl001 on 2017/3/7.
//  Copyright © 2017年 manman. All rights reserved.
//

#import "LXChatBoxFaceView.h"
#import "LXEmotionListView.h"
#import "LXChatBoxMenuView.h"
#import "LXEmotionManager.h"

#define bottomViewH 36.0

@interface LXChatBoxFaceView()<LXChatBoxMenuDelegate>
@property(nonatomic,weak)LXEmotionListView *showingListView;
@property(nonatomic,strong)LXEmotionListView *emojiListView;
@property(nonatomic,strong)LXEmotionListView *customListView;
@property(nonatomic,strong)LXEmotionListView *gifListView;
@property(nonatomic,strong)LXChatBoxMenuView *menuView;
@end
@implementation LXChatBoxFaceView


-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
       
        self.menuView = [[LXChatBoxMenuView alloc]init];
        self.menuView.delegate =self;
        [self addSubview:self.menuView];
        self.showingListView = self.emojiListView;
        [self addSubview:self.showingListView];
        self.backgroundColor =[UIColor grayColor];
        
       
       

    }
    return self;
}
#pragma mark - ICChatBoxMenuDelegate

- (void)emotionMenu:(LXChatBoxMenuView *)menu didSelectButton:(LXEmotionMenuButtonType)buttonType
{
    [self.showingListView removeFromSuperview];
    switch (buttonType) {
        case LXEmotionMenuButtonTypeEmoji:
            [self addSubview:self.emojiListView];
            break;
        case LXEmotionMenuButtonTypeCuston:
            [self addSubview:self.customListView];
            break;
        case LXEmotionMenuButtonTypeGif:
            [self addSubview:self.gifListView];
            break;
        default:
            break;
    }
    self.showingListView = [self.subviews lastObject];
    [self setNeedsLayout];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    self.menuView.width = self.width;
    self.menuView.height = bottomViewH;
    self.menuView.x = 0;
    self.menuView.y = self.height - self.menuView.height;
    
    self.showingListView.x = self.showingListView.y = 0;
    self.showingListView.width = self.width;
    self.showingListView.height = self.menuView.y;
    
}
-(LXEmotionListView *)emojiListView{
    if (!_emojiListView) {
        _emojiListView =[[LXEmotionListView alloc]init];
         _emojiListView.emotions  = [LXEmotionManager emojiEmotion];
    }
    return _emojiListView;
}
-(LXEmotionListView *)customListView{
    if (!_customListView) {
        _customListView =[[LXEmotionListView alloc]init];
        _customListView.emotions = [LXEmotionManager customEmotion];


    }
    return _customListView;
}
-(LXEmotionListView *)gifListView{
    if (!_gifListView) {
        _gifListView =[[LXEmotionListView alloc]init];
    }
    return _gifListView;
}
@end
