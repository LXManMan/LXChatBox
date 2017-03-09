//
//  LXChatBoxMenuView.m
//  LXChatBox
//
//  Created by zlwl001 on 2017/3/8.
//  Copyright © 2017年 manman. All rights reserved.
//

#import "LXChatBoxMenuView.h"
#import "LXEmotionMenuButton.h"

@interface LXChatBoxMenuView()
@property(nonatomic,strong)UIScrollView *scrollView;
@property(nonatomic,strong)UIButton *sendButton;
@property(nonatomic,strong)LXEmotionMenuButton *selectedBtn;
@end
@implementation LXChatBoxMenuView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setupBtn:[@"0x1f603" emoji] buttonType:LXEmotionMenuButtonTypeEmoji];
        [self setupBtn:@"Custom" buttonType:LXEmotionMenuButtonTypeCuston];
    }
    return self;
}
/**
 *  创建按钮
 *
 *  @param title      按钮文字
 *  @param buttonType 类型
 *
 *  @return 按钮
 */
- (LXEmotionMenuButton *)setupBtn:(NSString *)title
                       buttonType:(LXEmotionMenuButtonType)buttonType
{
    LXEmotionMenuButton *btn = [[LXEmotionMenuButton alloc] init];
    [btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchDown];
    btn.tag                  = buttonType; // 不要把0作为tag值
    
    [btn setBackgroundImage:[UIImage gxz_imageWithColor:[UIColor whiteColor]]forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage gxz_imageWithColor:LBColor(241, 241, 244)] forState:UIControlStateSelected];
    if ([title isEqualToString:@"Custom"]) {
        [btn setImage:[UIImage imageNamed:@"[吓]"] forState:UIControlStateNormal];
    } else {
        [btn setTitle:title forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:26.5];
        btn.selected = YES;
        self.selectedBtn = btn;
    }
    [self.scrollView addSubview:btn];
   
    return btn;
}
#pragma mark---发送  menu 菜单的发送按钮----
- (void)sendBtnClicked:(UIButton *)sendBtn
{
    [[NSNotificationCenter defaultCenter] postNotificationName:LXEmotionDidSendNotification object:nil];
}

- (void)btnClicked:(LXEmotionMenuButton *)button
{
    self.selectedBtn.selected = NO;
    button.selected           = YES;
    self.selectedBtn         = button;
    if ([self.delegate respondsToSelector
         :@selector(emotionMenu:didSelectButton:)]) {
        [self.delegate emotionMenu:self
                   didSelectButton:(int)button.tag];
    }
}

#pragma mark - Getter

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    NSUInteger count      = self.scrollView.subviews.count;
    //    CGFloat btnW          = self.width/(count+1);
    CGFloat btnW          = 60;
    self.scrollView.frame = CGRectMake(0, 0, self.width-btnW, self.height);
    self.sendButton.frame    = CGRectMake(self.width-btnW, 0, btnW, self.height);
    CGFloat btnH          = self.height;
    for (int i = 0; i < count; i ++) {
        LXEmotionMenuButton *btn = self.scrollView.subviews[i];
        btn.y                    = 0;
        btn.width                = (int)btnW;// 去除小缝隙
        btn.height               = btnH;
        btn.x                    = (int)btnW * i;
    }
}
-(void)setDelegate:(id<LXChatBoxMenuDelegate>)delegate{
    _delegate = delegate;
}
- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        [_scrollView setShowsHorizontalScrollIndicator:NO];
        [_scrollView setShowsVerticalScrollIndicator:NO];
        [_scrollView setScrollsToTop:NO];
        [self addSubview:_scrollView];
        [_scrollView setBackgroundColor:[UIColor whiteColor]];
    }
    return _scrollView;
}

- (UIButton *)sendButton
{
    if (!_sendButton) {
        _sendButton= [UIButton buttonWithType:UIButtonTypeCustom];
        [_sendButton setTitle:@"发送" forState:UIControlStateNormal];
        _sendButton.titleLabel.font = [UIFont systemFontOfSize:15.0];
        [_sendButton setBackgroundColor:[UIColor colorWithRed:0.1 green:0.4 blue:0.8 alpha:1.0]];
        [_sendButton setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
        [self addSubview:_sendButton];
        [_sendButton addTarget:self action:@selector(sendBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sendButton;
}
@end
