# LXChatBox

![image](https://github.com/liuxinixn/LXChatBox/blob/master/LXChatBox/%E9%94%AE%E7%9B%98.gif)
文章简介：http://www.jianshu.com/p/d61962517cb6



    self.chatBox =[[LXChatBox alloc]initWithFrame:CGRectMake(0, KScreenH - HEIGHT_TABBAR, KScreenW, HEIGHT_TABBAR)];

    //设置最大行数限制（稍后会优化）
    self.chatBox.maxVisibleLine = 3;
    
    self.chatBox.delegate = self;
    
    [self.view addSubview:self.chatBox];
    
     //实现以下代理即可 ，返回聊天键盘的高度 与发送消息，目前只支持文本消息
    -(void)changeStatusChat:(CGFloat)chatBoxY{
    
    self.tableview.frame = CGRectMake(0, 64, KScreenW, chatBoxY - 20-64);
     [self.tableview scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.array.count -1 inSection:0]  atScrollPosition:UITableViewScrollPositionBottom animated:NO];
     }
    //发送消息的代理方法
     -(void)chatBoxSendTextMessage:(NSString *)message{
    
    NSAttributedString *attribute =[LXEmotionManager transferMessageString:message font:[UIFont systemFontOfSize:16.0] lineHeight:[UIFont systemFontOfSize:16.0].lineHeight];

    [self.array addObject:attribute];
   
    [self.tableview reloadData];
    [self.tableview scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.array.count -1 inSection:0]  atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    
     }
