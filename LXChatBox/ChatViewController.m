//
//  ChatViewController.m
//  LXChatBox
//
//  Created by zlwl001 on 2017/3/7.
//  Copyright © 2017年 manman. All rights reserved.
//

#import "ChatViewController.h"
#import "LXChatBox.h"
#import "LXEmotionManager.h"
@interface ChatViewController ()<UITableViewDelegate,UITableViewDataSource,LXChatBoxDelegate>
@property(nonatomic,strong)LXChatBox *chatBox;
@property(nonatomic,strong)UITableView *tableview;
@property(nonatomic,strong)NSMutableArray *array;
@end

@implementation ChatViewController
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.chatBox.isDisappear = YES;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.chatBox.isDisappear = NO;
    
     [self.tableview scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.array.count -1 inSection:0]  atScrollPosition:UITableViewScrollPositionBottom animated:NO];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor =[UIColor whiteColor];
    self.chatBox =[[LXChatBox alloc]initWithFrame:CGRectMake(0, KScreenH - HEIGHT_TABBAR, KScreenW, HEIGHT_TABBAR)];
    self.chatBox.maxVisibleLine = 3;
    self.chatBox.delegate = self;
    [self.view addSubview:self.chatBox];
    
    [self.view addSubview:self.tableview];
    
    self.array =[NSMutableArray array];
    for (int i = 0; i<19; i++) {
        NSAttributedString *string =[[NSAttributedString alloc]initWithString:@"情开一朵，爱难临摹"];
        [self.array addObject:string];
    }
    [self.tableview reloadData];

}
-(void)changeStatusChat:(CGFloat)chatBoxY{
    
    self.tableview.frame = CGRectMake(0, 64, KScreenW, chatBoxY - 20-64);
     [self.tableview scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.array.count -1 inSection:0]  atScrollPosition:UITableViewScrollPositionBottom animated:NO];
}
-(void)chatBoxSendTextMessage:(NSString *)message{
    
    NSAttributedString *attribute =[LXEmotionManager transferMessageString:message font:[UIFont systemFontOfSize:16.0] lineHeight:[UIFont systemFontOfSize:16.0].lineHeight];

    [self.array addObject:attribute];
   
    [self.tableview reloadData];
    [self.tableview scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.array.count -1 inSection:0]  atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    
}
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    self.chatBox.status = LXChatBoxStatusNothing;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.array.count ;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    return 100;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
   
    cell.textLabel.attributedText = self.array[indexPath.row];
    cell.textLabel.numberOfLines = 0;
   
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}
-(UITableView *)tableview{
    if (!_tableview) {
        _tableview =[[UITableView alloc]initWithFrame:CGRectMake(0, 64, KScreenW, KScreenH - 64-HEIGHT_TABBAR) style:UITableViewStylePlain];
        _tableview.delegate=  self;
        _tableview.dataSource = self;
        _tableview.tableFooterView =[UIView new];
    }
    return _tableview;
    
}
@end
