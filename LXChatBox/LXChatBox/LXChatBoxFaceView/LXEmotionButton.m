
//
//  LXEmotionButton.m
//  LXChatBox
//
//  Created by zlwl001 on 2017/3/8.
//  Copyright © 2017年 manman. All rights reserved.
//

#import "LXEmotionButton.h"

@implementation LXEmotionButton

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUp];
    }
    return self;
}
-(void)setUp{
    self.titleLabel.font =[UIFont systemFontOfSize:32.0];
    self.adjustsImageWhenHighlighted = NO;
}
-(void)setEmotion:(LXEmotion *)emotion{
    _emotion = emotion;
    
    if (emotion.code) {
        [self setTitle:self.emotion.code.emoji forState:UIControlStateNormal];
    } else if (emotion.face_name) {
        [self setImage:[UIImage imageNamed:self.emotion.face_name] forState:UIControlStateNormal];
    }
}

@end
