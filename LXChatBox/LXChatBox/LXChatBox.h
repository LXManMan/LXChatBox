//
//  LXChatBox.h
//  LXChatBox
//
//  Created by zlwl001 on 2017/3/7.
//  Copyright © 2017年 manman. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, LXChatBoxStatus) {
    LXChatBoxStatusNothing,     // 默认状态
    LXChatBoxStatusShowVoLXe,   // 录音状态
    LXChatBoxStatusShowFace,    // 输入表情状态
    LXChatBoxStatusShowMore,    // 显示“更多”页面状态
    LXChatBoxStatusShowKeyboard,// 正常键盘
    LXChatBoxStatusShowVideo    // 录制视频
};
@protocol LXChatBoxDelegate <NSObject>

-(void)changeStatusChat:(CGFloat)chatBoxY;
-(void)chatBoxSendTextMessage:(NSString *)message;

@end
@interface LXChatBox : UIView
@property(nonatomic,assign)LXChatBoxStatus status;
@property(nonatomic,assign)BOOL isDisappear;
@property(nonatomic,assign)NSInteger maxVisibleLine;
@property(nonatomic,weak)id<LXChatBoxDelegate>delegate;

@end
