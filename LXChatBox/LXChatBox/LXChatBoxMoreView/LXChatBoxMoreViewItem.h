//
//  LXChatBoxMoreViewItem.h
//  LXChatBox
//
//  Created by zlwl001 on 2017/3/8.
//  Copyright © 2017年 manman. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LXChatBoxMoreViewItem : UIView
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *imageName;

- (void)addTarget:(id)target action:(SEL)action
 forControlEvents:(UIControlEvents)controlEvents;

/**
 *  创建一个ICChatBoxMoreViewItem
 *
 *  @param title     item的标题
 *  @param imageName item的图片
 *
 *  @return item
 */
+ (LXChatBoxMoreViewItem *)createChatBoxMoreItemWithTitle:(NSString *)title
                                                imageName:(NSString *)imageName;


@end
