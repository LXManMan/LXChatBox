//
//  LXEmotion.m
//  LXChatBox
//
//  Created by zlwl001 on 2017/3/8.
//  Copyright © 2017年 manman. All rights reserved.
//

#import "LXEmotion.h"

@implementation LXEmotion
- (BOOL)isEqual:(LXEmotion *)emotion
{
    return [self.face_name isEqualToString:emotion.face_name] || [self.code isEqualToString:emotion.code];
}
@end
