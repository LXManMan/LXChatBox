//
//  LXChatBoxMenuView.h
//  LXChatBox
//
//  Created by zlwl001 on 2017/3/8.
//  Copyright © 2017年 manman. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum {
    LXEmotionMenuButtonTypeEmoji = 100,
    LXEmotionMenuButtonTypeCuston,
    LXEmotionMenuButtonTypeGif
    
} LXEmotionMenuButtonType;

@class LXChatBoxMenuView;

@protocol LXChatBoxMenuDelegate <NSObject>

@optional
- (void)emotionMenu:(LXChatBoxMenuView *)menu
    didSelectButton:(LXEmotionMenuButtonType)buttonType;

@end
@interface LXChatBoxMenuView : UIView
@property(nonatomic,weak)id<LXChatBoxMenuDelegate>delegate;
@end
