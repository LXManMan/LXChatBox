//
//  LXChatBox.m
//  LXChatBox
//
//  Created by zlwl001 on 2017/3/7.
//  Copyright © 2017年 manman. All rights reserved.
//

#import "LXChatBox.h"
#import "LXChatBoxFaceView.h"
#import "LXChatBoxMoreView.h"
#import "LXEmotion.h"
@interface LXChatBox()<UITextViewDelegate,LXChatBoxMoreViewDelegate>
@property(nonatomic,strong)UITextView *textView;
@property(nonatomic,strong)UIView *topContainer;//上侧容器
@property(nonatomic,strong)UIView *bottomCotainer;//下侧容器

@property(nonatomic,strong)LXChatBoxFaceView *faceView;
@property(nonatomic,strong)LXChatBoxMoreView *moreView;
/** chotBox的顶部边线 */
@property(nonatomic,strong)UIView *topLine;
/** 录音按钮 */
@property(nonatomic,strong)UIButton *voiceButton;
/** 表情按钮 */

@property(nonatomic,strong)UIButton *faceButton;
/** (+)按钮 */
@property(nonatomic,strong)UIButton *moreButton;
/** 按住说话 */
@property(nonatomic,strong)UIButton *talkButton;
@end
@implementation LXChatBox
{
    CGFloat keyboardY;
 
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = LBColor(241, 241, 248);
//        self.backgroundColor =[UIColor redColor];
        
        self.status = LXChatBoxStatusNothing;
        [self.textView resignFirstResponder];
        [self setUpUI];
        [self addNotification];
    }
    
    return self;
}
#pragma mark---添加子视图---
-(void)setUpUI{
    
    [self addSubview:self.topContainer];
    [self addSubview:self.bottomCotainer];
    [self.topContainer addSubview:self.topLine];
    [self.topContainer addSubview:self.voiceButton];
    [self.topContainer addSubview:self.faceButton];
    [self.topContainer addSubview:self.moreButton];
    [self.topContainer addSubview:self.textView];
    [self.topContainer addSubview:self.talkButton];
    
    [self.bottomCotainer addSubview:self.faceView];
    [self.bottomCotainer addSubview:self.moreView];
    
}
#pragma mark--设置是否有动画 （一体键盘）
-(void)setIsDisappear:(BOOL)isDisappear{
    _isDisappear = isDisappear;
}
#pragma mark---textview--代理方法---
-(void)textViewDidBeginEditing:(UITextView *)textView{
    if (self.status != LXChatBoxStatusShowKeyboard) {
        self.status = LXChatBoxStatusShowKeyboard;

    }
        [self changeFrame:ceilf([textView sizeThatFits:textView.frame.size].height)];
}
-(void)textViewDidChange:(UITextView *)textView{
    [self changeFrame:ceilf([textView sizeThatFits:textView.frame.size].height)];
    
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    if ([text isEqualToString:@"\n"]) {
        if (self.textView.text.length >0) {
            if (self.delegate &&[self.delegate respondsToSelector:@selector(chatBoxSendTextMessage:)]) {
                [self.delegate chatBoxSendTextMessage:self.textView.text];
            }
        }
        self.textView.text = @"";
        self.textView.height = HEIGHT_TEXTVIEW;
        [self textViewDidChange:self.textView];
        return NO;
    }
    return YES;
}
- (void)changeFrame:(CGFloat)height{

    CGFloat maxH = 0;
    if (self.maxVisibleLine) {
       maxH = ceil(self.textView.font.lineHeight * (self.maxVisibleLine - 1) + self.textView.textContainerInset.top + self.textView.textContainerInset.bottom);
    }
    self.textView.scrollEnabled = height >maxH && maxH >0;
    if (self.textView.scrollEnabled) {
        height = 5+maxH;
    }else{
        height = height;
    }
    CGFloat textviewH = height;
    
    CGFloat totalH = 0;
    if (self.status == LXChatBoxStatusShowFace || self.status == LXChatBoxStatusShowMore) {
        totalH = height + BOXTEXTViewSPACE *2 +BOXOTHERH;
        if (keyboardY ==0) {
            keyboardY = KScreenH;
        }
        self.y = keyboardY - totalH;
        self.height = totalH;
        self.topContainer.height = height + BOXTEXTViewSPACE *2;
        self.bottomCotainer.y =self.topContainer.height;
        self.textView.y = BOXTEXTViewSPACE;
        self.textView.height = textviewH;
        
        self.talkButton.frame = self.textView.frame;
        self.moreButton.y =  self.faceButton.y = self.voiceButton.y  = totalH - BOXBTNBOTTOMSPACE- CHATBOX_BUTTON_WIDTH-BOXOTHERH;

    }else
    {
         totalH = height + BOXTEXTViewSPACE *2;
        self.y = keyboardY - totalH;
        self.height = totalH;
        self.topContainer.height = totalH;
        
        self.textView.y = BOXTEXTViewSPACE;
        self.textView.height = textviewH;
        self.bottomCotainer.y =self.topContainer.height;

        self.talkButton.frame = self.textView.frame;
        self.moreButton.y =  self.faceButton.y = self.voiceButton.y  = totalH - BOXBTNBOTTOMSPACE- CHATBOX_BUTTON_WIDTH;
    }
    
    if ([self.delegate respondsToSelector:@selector(changeStatusChat:)]) {
        [self.delegate changeStatusChat:self.y];
    }

    [self.textView scrollRangeToVisible:NSMakeRange(0, self.textView.text.length)];
}
-(void)setMaxVisibleLine:(NSInteger)maxVisibleLine{
    _maxVisibleLine = maxVisibleLine;
    
    
}
-(void)setDelegate:(id<LXChatBoxDelegate>)delegate{
    _delegate = delegate;
}

#pragma mark---Event Responds---

-(void)voiceButtonDown:(UIButton *)button{
    
    button.selected = !button.selected;
    if (button.selected) {
        self.status = LXChatBoxStatusShowKeyboard;
    }else{
        self.status = LXChatBoxStatusShowVoLXe;
    }
    
}
-(void)faceButtonDown:(UIButton *)button{
    button.selected = !button.selected;
    if (button.selected) {
        self.status = LXChatBoxStatusShowFace;
    }else{
        self.status = LXChatBoxStatusShowKeyboard;
    }
   
    
}
-(void)moreButtonDown:(UIButton *)button{
    button.selected = !button.selected;
    if (button.selected) {
        self.status = LXChatBoxStatusShowMore;
    }else{
        self.status = LXChatBoxStatusShowKeyboard;
    }
}
#pragma mark---点击moreview item 的代理方法---
-(void)chatBoxMoreView:(LXChatBoxMoreView *)chatBoxMoreView didSelectItem:(LXChatBoxItem)itemType{
    NSLog(@"%s",__func__);
}

-(void)setStatus:(LXChatBoxStatus)status{
    if (_status == status) {
        return;
    }
    _status = status;
    switch (_status) {
        case LXChatBoxStatusNothing:
        {
            self.voiceButton.selected = YES;
            self.faceView.hidden = self.moreView.hidden = YES;
            [self.textView resignFirstResponder];
            [UIView animateWithDuration:0.3 animations:^{
                self.frame = CGRectMake(0, KScreenH - self.textView.height - 2 *BOXTEXTViewSPACE, KScreenW, self.textView.height + 2 *BOXTEXTViewSPACE);

            }];
        }
            
           
            break;
        case LXChatBoxStatusShowKeyboard:
        {
            self.faceView.hidden = self.moreView.hidden = YES;

            self.voiceButton.selected = YES;
            self.textView.hidden = NO;
            self.talkButton.hidden = YES;
            self.faceButton.selected= NO;
            
            [UIView animateWithDuration:0.3 animations:^{
                self.frame = CGRectMake(0, self.y, KScreenW, self.textView.height + 2 *BOXTEXTViewSPACE);
                
            }];
             [self.textView becomeFirstResponder];
        }
        break;
        case LXChatBoxStatusShowVoLXe:
        {
            self.faceView.hidden = self.moreView.hidden = YES;

            [self.textView resignFirstResponder];
            self.voiceButton.selected = NO;
            self.talkButton.hidden = NO;
            self.textView.hidden = YES;
            [UIView animateWithDuration:0.3 animations:^{
                [self voiceResetFrame];
            }];

        }
            
            break;
        case LXChatBoxStatusShowFace:
        {
            if (self.textView.isFirstResponder) {
                [self.textView resignFirstResponder];
            }
            

            self.voiceButton.selected = YES;
            self.moreView.hidden = YES;
            self.faceView.hidden = NO;
            
            self.height = self.textView.height+2 *BOXTEXTViewSPACE + BOXOTHERH;
            self.y = KScreenH - self.height;
            self.bottomCotainer.y = self.textView.height + 2 *BOXTEXTViewSPACE;

        }
            
            break;
        case LXChatBoxStatusShowMore:
        {
            

            if (self.textView.isFirstResponder) {
                [self.textView resignFirstResponder];
            }
            
            self.voiceButton.selected = YES;
            self.moreView.hidden = NO;
            self.faceView.hidden = YES;

            self.height = self.textView.height+2 *BOXTEXTViewSPACE + BOXOTHERH;
            self.y = KScreenH - self.height;
            self.bottomCotainer.y = self.textView.height + 2 *BOXTEXTViewSPACE;
        }
        default:
            break;
    }
    if ([self.delegate respondsToSelector:@selector(changeStatusChat:)]) {
        [self.delegate changeStatusChat:self.y];
    }
}
#pragma mark --重置Frame ---
-(void)voiceResetFrame
{
    self.frame = CGRectMake(0, KScreenH -HEIGHT_TABBAR, KScreenW, HEIGHT_TABBAR);
    self.talkButton.frame = CGRectMake(CHATBOX_BUTTON_WIDTH+ BOXBTNSPACE, (HEIGHT_TABBAR - HEIGHT_TEXTVIEW)/2, KScreenW -3 * CHATBOX_BUTTON_WIDTH - 2 *BOXBTNSPACE, HEIGHT_TEXTVIEW);
    self.voiceButton.frame = CGRectMake(0, (HEIGHT_TABBAR - CHATBOX_BUTTON_WIDTH)/2, CHATBOX_BUTTON_WIDTH, CHATBOX_BUTTON_WIDTH);
    self.faceButton.frame =CGRectMake(KScreenW -2 *CHATBOX_BUTTON_WIDTH, (HEIGHT_TABBAR - CHATBOX_BUTTON_WIDTH)/2, CHATBOX_BUTTON_WIDTH, CHATBOX_BUTTON_WIDTH);
    self.moreButton.frame =CGRectMake(KScreenW - CHATBOX_BUTTON_WIDTH, (HEIGHT_TABBAR - CHATBOX_BUTTON_WIDTH)/2, CHATBOX_BUTTON_WIDTH, CHATBOX_BUTTON_WIDTH);
}
#pragma mark--添加通知---
-(void)addNotification{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardDidChangeFrame:) name:UIKeyboardDidChangeFrameNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(emotionDidSelected:) name:LXEmotionDidSelectNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteBtnClicked) name:LXEmotionDidDeleteNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sendMessage) name:LXEmotionDidSendNotification object:nil];
}
#pragma mark 通知 --选择表情
- (void)emotionDidSelected:(NSNotification *)notifi
{
    LXEmotion *emotion = notifi.userInfo[LXSelectEmotionKey];
    if (emotion.code) {
        [self.textView insertText:emotion.code.emoji];
    } else if (emotion.face_name) {
        [self.textView insertText:emotion.face_name];
    }
}
#pragma mark --发送消息---
- (void)sendMessage
{
    if (self.textView.text.length > 0) {     // send Text

        if (self.delegate && [self.delegate respondsToSelector:@selector(chatBoxSendTextMessage:)]) {
            [self.delegate chatBoxSendTextMessage:self.textView.text];
        }
    }
    [self.textView setText:@""];
    self.textView.height = HEIGHT_TEXTVIEW;
    [self textViewDidChange:self.textView];
}
#pragma mark 通知 --- 删除--回退--
- (void)deleteBtnClicked
{
    [self.textView deleteBackward];
}

-(void)keyboardWillChangeFrame:(NSNotification *)notification{
    
    NSDictionary *userInfo = notification.userInfo;
    // 动画的持续时间
    double duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];

    // 键盘的frame
    CGRect keyboardF = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    //    NSLog(@"%@",NSStringFromCGRect(keyboardF));
    keyboardY = keyboardF.origin.y;
    //因为在 切换视图的时候，点击了表情按钮，或者更多按钮，输入框是，键盘弹出在textViewDidBeginEditing 这个方法调用之前就会调用，
//        self.height = self.textView.height + 2 *BOXTEXTViewSPACE;
    if (self.status == LXChatBoxStatusShowMore ||self.status == LXChatBoxStatusShowFace) {
        return;
    }
    
    // 执行动画
    if (!_isDisappear) {
        
        [UIView animateWithDuration:duration animations:^{
            // 工具条的Y值 == 键盘的Y值 - 工具条的高度
            
            if (keyboardF.origin.y > KScreenH) {
                self.y = KScreenH- self.height;
            }else
            {
                self.y = keyboardF.origin.y - self.height;
            }
            //            NSLog(@"%f",self.y);
        }];
        if ([self.delegate respondsToSelector:@selector(changeStatusChat:)]) {
            [self.delegate changeStatusChat:self.y];
        }

    }
    
    
}

-(void)keyboardDidChangeFrame:(NSNotification *)notification{
    
    NSDictionary *userInfo = notification.userInfo;
    // 动画的持续时间
    //    double duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    // 键盘的frame
    CGRect keyboardF = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    //    NSLog(@"%@",NSStringFromCGRect(keyboardF));
    
   
    // 工具条的Y值 == 键盘的Y值 - 工具条的高度
    if (_isDisappear) {
        if (keyboardF.origin.y > KScreenH) {
            self.y = KScreenH- self.height;
        }else
        {
            self.y = keyboardF.origin.y - self.height;
        }
//        NSLog(@"%f",self.y);
    }
    
    
}
// 说话按钮
- (void)talkButtonDown:(UIButton *)sender
{
    //    if (_delegate && [_delegate respondsToSelector:@selector(chatBoxDidStartRecordingVoice:)]) {
    //        [_delegate chatBoxDidStartRecordingVoice:self];
    //    }
}

- (void)talkButtonUpInside:(UIButton *)sender
{
    //    if (_delegate && [_delegate respondsToSelector:@selector(chatBoxDidStopRecordingVoice:)]) {
    //        [_delegate chatBoxDidStopRecordingVoice:self];
    //    }
}

- (void)talkButtonUpOutside:(UIButton *)sender
{
    //    if (_delegate && [_delegate respondsToSelector:@selector(chatBoxDidCancelRecordingVoice:)]) {
    //        [_delegate chatBoxDidCancelRecordingVoice:self];
    //    }
}

- (void)talkButtonDragOutside:(UIButton *)sender
{
    //    if ([_delegate respondsToSelector:@selector(chatBoxDidDrag:)]) {
    //        [_delegate chatBoxDidDrag:NO];
    //    }
}

- (void)talkButtonDragInside:(UIButton *)sender
{
    //    if ([_delegate respondsToSelector:@selector(chatBoxDidDrag:)]) {
    //        [_delegate chatBoxDidDrag:YES];
    //    }
}

- (void)talkButtonTouchCancel:(UIButton *)sender
{
}

#pragma mark---懒加载---
-(UIView *)topContainer{
    if (!_topContainer) {
        _topContainer =[[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenW, HEIGHT_TABBAR)];
        _topContainer.backgroundColor =[UIColor clearColor];
        
    }
    return _topContainer;
}
-(UIView *)bottomCotainer{
    if (!_bottomCotainer) {
        _bottomCotainer =[[UIView alloc]initWithFrame:CGRectMake(0, HEIGHT_TABBAR, KScreenW, BOXOTHERH)];
        _bottomCotainer.backgroundColor =[UIColor clearColor];
        
    }
    return _bottomCotainer;
}
-(LXChatBoxFaceView *)faceView{
    if (!_faceView ) {
        _faceView =[[LXChatBoxFaceView alloc]initWithFrame:CGRectMake(0, 0, KScreenW, BOXOTHERH)];
//        _faceView.backgroundColor =[UIColor purpleColor];
        
    }
    return _faceView;
}
-(LXChatBoxMoreView *)moreView{
    if (!_moreView ) {
        _moreView =[[LXChatBoxMoreView alloc]initWithFrame:CGRectMake(0, 0, KScreenW, BOXOTHERH)];
        _moreView.hidden = YES;
        _moreView.delegate = self;
        // 创建Item
        LXChatBoxMoreViewItem *photosItem = [LXChatBoxMoreViewItem createChatBoxMoreItemWithTitle:@"照片"
                                                                                        imageName:@"sharemore_pic"];
        LXChatBoxMoreViewItem *takePictureItem = [LXChatBoxMoreViewItem createChatBoxMoreItemWithTitle:@"拍摄"
                                                                                             imageName:@"sharemore_video"];
        LXChatBoxMoreViewItem *videoItem = [LXChatBoxMoreViewItem createChatBoxMoreItemWithTitle:@"小视频"
                                                                                       imageName:@"sharemore_sight"];
        LXChatBoxMoreViewItem *docItem   = [LXChatBoxMoreViewItem createChatBoxMoreItemWithTitle:@"文件" imageName:@"sharemore_wallet"];
        [_moreView setItems:[[NSMutableArray alloc] initWithObjects:photosItem, takePictureItem, videoItem,docItem, nil]];

//        _moreView.backgroundColor =[UIColor purpleColor];
    }
    return _moreView;
}

-(UIView *)topLine{
    if (!_topLine) {
        _topLine =[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.width, 0.5)];
        [_topLine setBackgroundColor:LBColor(165, 165, 165)];
    }
    return _topLine;
}
-(UIButton *)voiceButton{
    if (!_voiceButton) {
        _voiceButton =[[UIButton alloc]initWithFrame:CGRectMake(0, (HEIGHT_TABBAR - CHATBOX_BUTTON_WIDTH)/2, CHATBOX_BUTTON_WIDTH, CHATBOX_BUTTON_WIDTH)];
        [_voiceButton setImage:[UIImage imageNamed:@"ToolViewInputVoice"] forState:UIControlStateSelected];

         [_voiceButton setImage:[UIImage imageNamed:@"ToolViewKeyboard"] forState:UIControlStateNormal];
        
        [_voiceButton addTarget:self action:@selector(voiceButtonDown:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _voiceButton;
}
-(UIButton *)faceButton{
    if (!_faceButton) {
        _faceButton =[[UIButton alloc]initWithFrame:CGRectMake(KScreenW -2 *CHATBOX_BUTTON_WIDTH, (HEIGHT_TABBAR - CHATBOX_BUTTON_WIDTH)/2, CHATBOX_BUTTON_WIDTH, CHATBOX_BUTTON_WIDTH)];
        [_faceButton setImage:[UIImage imageNamed:@"ToolViewEmotion"] forState:UIControlStateNormal];
        [_faceButton setImage:[UIImage imageNamed:@"ToolViewKeyboard"] forState:UIControlStateSelected];
        [_faceButton setImage:[UIImage imageNamed:@"ToolViewEmotionHL"] forState:UIControlStateHighlighted];
        [_faceButton addTarget:self action:@selector(faceButtonDown:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _faceButton;
}
-(UIButton *)moreButton{
    if (!_moreButton) {
        _moreButton =[[UIButton alloc]initWithFrame:CGRectMake(KScreenW - CHATBOX_BUTTON_WIDTH, (HEIGHT_TABBAR - CHATBOX_BUTTON_WIDTH)/2, CHATBOX_BUTTON_WIDTH, CHATBOX_BUTTON_WIDTH)];
        [_moreButton setImage:[UIImage imageNamed:@"TypeSelectorBtn_Black"] forState:UIControlStateNormal];
        [_moreButton setImage:[UIImage imageNamed:@"TypeSelectorBtn_Black"] forState:UIControlStateSelected];
        [_moreButton setImage:[UIImage imageNamed:@"TypeSelectorBtnHL_Black"] forState:UIControlStateHighlighted];
        [_moreButton addTarget:self action:@selector(moreButtonDown:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _moreButton;
}
-(UITextView *)textView{
    if (!_textView) {
        _textView =[[UITextView alloc]initWithFrame:CGRectMake(CHATBOX_BUTTON_WIDTH+ BOXBTNSPACE, (HEIGHT_TABBAR - HEIGHT_TEXTVIEW)/2, KScreenW -3 * CHATBOX_BUTTON_WIDTH - 2 *BOXBTNSPACE, HEIGHT_TEXTVIEW)];
        _textView.font = Font(16);
        _textView.layer. masksToBounds = YES;
        _textView.layer.cornerRadius = 4.0f;
        _textView.layer.borderWidth = 0.5f;
        _textView.layer.borderColor= self.topLine.backgroundColor.CGColor;
        _textView.scrollsToTop = NO;
        _textView.returnKeyType = UIReturnKeySend;
        _textView.delegate = self;
    }
    return _textView;
}
-(UIButton *)talkButton{
    if (!_talkButton) {
        _talkButton = [[UIButton alloc]initWithFrame:self.textView.frame];
        [_talkButton setTitle:@"按住 说话" forState:UIControlStateNormal];
        [_talkButton setTitle:@"松开 结束" forState:UIControlStateHighlighted];
        [_talkButton setTitleColor:[UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:1.0] forState:UIControlStateNormal];
        [_talkButton setBackgroundImage:[UIImage gxz_imageWithColor:[UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:0.5]] forState:UIControlStateHighlighted];
        _talkButton.layer. masksToBounds = YES;
        _talkButton.layer.cornerRadius = 4.0f;
        _talkButton.layer.borderWidth = 0.5f;
        [_talkButton.layer setBorderColor:self.topLine.backgroundColor.CGColor];
        [_talkButton setHidden:YES];
        [_talkButton addTarget:self action:@selector(talkButtonDown:) forControlEvents:UIControlEventTouchDown];
        [_talkButton addTarget:self action:@selector(talkButtonUpInside:) forControlEvents:UIControlEventTouchUpInside];
        [_talkButton addTarget:self action:@selector(talkButtonUpOutside:) forControlEvents:UIControlEventTouchUpOutside];
        [_talkButton addTarget:self action:@selector(talkButtonTouchCancel:) forControlEvents:UIControlEventTouchCancel];
        [_talkButton addTarget:self action:@selector(talkButtonDragOutside:) forControlEvents:UIControlEventTouchDragOutside];
        [_talkButton addTarget:self action:@selector(talkButtonDragInside:) forControlEvents:UIControlEventTouchDragInside];
    }
    return _talkButton;
}
@end
