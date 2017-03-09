//
//  LXEmotionPageView.h
//  LXChatBox
//
//  Created by zlwl001 on 2017/3/8.
//  Copyright © 2017年 manman. All rights reserved.
//

#import <UIKit/UIKit.h>
#define LXEmotionMaxRows 3
#define LXEMotionMaxCols 7
#define LXEmotionPageSize ((LXEmotionMaxRows * LXEMotionMaxCols) - 1)
@interface LXEmotionPageView : UIView
@property (nonatomic, strong) NSArray *emotions;
@end
