//
//  CmInputBar.m
//  乐企信
//
//  Created by 震霄 张 on 16/4/5.
//  Copyright © 2016年 SDW. All rights reserved.
//

#import "CmInputBar.h"
//背景颜色
#define kBkColor               ([UIColor colorWithRed:0.922 green:0.925 blue:0.929 alpha:1])

//输入框最小高度
#define kMinHeightTextView          (34)

//输入框最大高度
#define kMaxHeightTextView   (75)

//默认输入框和父控件底部间隔
#define kDefaultBottomTextView_SupView  (5)

#define kDefaultTopTextView_SupView  (5)

//按钮大小
#define kSizeBtn                 (CGSizeMake(34, 34))

@interface CmInputBar()<UITextViewDelegate>
@property(nonatomic,strong)UIButton *sendBtn;
@property(nonatomic,strong)UITextView *mInputTextView;
@property (nonatomic,assign)CGFloat mHeightTextView;//TextView的高度
@end

@implementation CmInputBar

-(instancetype)init
{
    self = [super init];
    if (self)
    {
        self.backgroundColor = kBkColor;
        self.mHeightTextView = kMinHeightTextView; //默认设置输入框最小高度

        self.mInputTextView.x = 10*SCREEN_SCALE_W;
        self.mInputTextView.y = 5*SCREEN_SCALE_H;
        self.mInputTextView.width = [UIScreen mainScreen].bounds.size.width -   kSizeBtn.width-30*SCREEN_SCALE_W;
        self.mInputTextView.height = self.mHeightTextView;
        
        
        [self addSubview:self.mInputTextView];
        
        self.sendBtn.x = CGRectGetMaxX(self.mInputTextView.frame);
        self.sendBtn.y = self.mInputTextView.y;
        self.sendBtn.height =kSizeBtn.height;
        self.sendBtn.width = kSizeBtn.width*1.4;
//        [self.sendBtn setTitle:@"发送" forState:UIControlStateNormal];
        [self.sendBtn setBackgroundImage:[UIImage imageNamed:@"btn_huifu"] forState:UIControlStateNormal];
        [self addSubview:self.sendBtn];
        
        /**
         *  @brief  监听键盘显示、隐藏变化，让自己伴随键盘移动
         */
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardChange:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardChange:) name:UIKeyboardWillHideNotification object:nil];
        
    }
    return self;
}


-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark - 伴随键盘移动

-(void)keyboardChange:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];
    
    
    NSTimeInterval animationDuration;
    UIViewAnimationCurve animationCurve;
    CGRect keyboardEndFrame;
    
    [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardEndFrame];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:animationCurve];
    
    if (notification.name == UIKeyboardWillShowNotification)
    {
        self.y -= keyboardEndFrame.size.height;
        
//        if ([self.delegate respondsToSelector:@selector(changeHightWithInputBar:)]) {
//            
//            [self.delegate changeHightWithInputBar:self.y];
//        }
        self.isOut = YES;
    }else
    {
        self.y += keyboardEndFrame.size.height;
        
//        if ([self.delegate respondsToSelector:@selector(changeHightWithInputBar:)]) {
//            
//            [self.delegate changeHightWithInputBar:self.y];
//        }
        self.isOut = NO;
    }
    
    [self.superview layoutIfNeeded];
    [UIView commitAnimations];
}

-(UIButton *)sendBtn
{
    if (_sendBtn) {
        return _sendBtn;
    }
    
    _sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_sendBtn addTarget:self action:@selector(sendBtnClick) forControlEvents:UIControlEventTouchUpInside];
    _sendBtn.backgroundColor = [UIColor clearColor];
  //  [_sendBtn setImage:[UIImage imageNamed:@"icon_smile"] forState:UIControlStateNormal];
//    [_sendBtn setTitle:@"发送" forState:UIControlStateNormal];
    [self.sendBtn setBackgroundImage:[UIImage imageNamed:@"btn_huifu"] forState:UIControlStateNormal];

    UIColor *titleColor =ZXcolor(10, 212, 134);
    [_sendBtn setTitleColor:titleColor forState:UIControlStateNormal];
    _sendBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    _sendBtn.enabled = NO;
    
    return _sendBtn;
}

-(void)sendBtnClick
{
    NSLog(@"发送评论:%@",self.mInputTextView.text);
    if ([self.delegate respondsToSelector:@selector(sendComment:)]) {
//        if (self.ansModel == nil) {
//            self.ansModel = [[UsrAnswerModel alloc]init];
//        }
//        self.ansModel.nameStr = @"当前用户";
//        self.ansModel.locationStr = @"江苏省苏州市";
//        self.ansModel.commentStr = self.mInputTextView.text;
//        self.ansModel.timeStr = @"刚刚";
        NSString *replyStr = self.mInputTextView.text;
        [self.delegate sendComment:replyStr];
        [self.mInputTextView resignFirstResponder];
        self.mInputTextView.text = @"";
    }
}
-(UITextView *)mInputTextView
{
    if (_mInputTextView) {
        return _mInputTextView;
    }
    
    _mInputTextView = [[UITextView alloc]init];
    
    _mInputTextView.delegate = self;
    _mInputTextView.layer.cornerRadius = 4;
    _mInputTextView.layer.masksToBounds = YES;
    _mInputTextView.layer.borderWidth = 1;
    _mInputTextView.layer.borderColor = [[[UIColor lightGrayColor] colorWithAlphaComponent:0.4] CGColor];
    _mInputTextView.scrollEnabled = NO;
    _mInputTextView.scrollsToTop = NO;
    _mInputTextView.userInteractionEnabled = YES;
    _mInputTextView.font = [UIFont systemFontOfSize:14];
    _mInputTextView.textColor = [UIColor blackColor];
    _mInputTextView.backgroundColor = [UIColor whiteColor];
    _mInputTextView.keyboardAppearance = UIKeyboardAppearanceDefault;
    _mInputTextView.keyboardType = UIKeyboardTypeDefault;
    _mInputTextView.returnKeyType = UIReturnKeySend;
    _mInputTextView.textAlignment = NSTextAlignmentLeft;
    _mInputTextView.text = @"回复内容";
    return _mInputTextView;
}
-(void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@"回复内容"]) {
        textView.text = @"";
    }
}
- (void)textViewDidEndEditing:(UITextView *)textView {
    if (textView.text.length<1) {
        textView.text = @"回复内容";
        self.sendBtn.enabled = NO;
    }
}
//根据输入文字多少，自动调整输入框的高度
-(void)textViewDidChange:(UITextView *)textView
{
    //计算输入框最小高度
    CGSize size =  [textView sizeThatFits:CGSizeMake(textView.contentSize.width, 0)];
    
    CGFloat contentHeight;
    
    //输入框的高度不能超过最大高度
    if (size.height > kMaxHeightTextView)
    {
        contentHeight = kMaxHeightTextView;
        textView.scrollEnabled = YES;
    }else
    {
        contentHeight = size.height;
        textView.scrollEnabled = NO;
    }
    
    
    if (self.mHeightTextView != contentHeight)
    {//如果当前高度需要调整，就调整，避免多做无用功
        self.y -= contentHeight - self.mHeightTextView;
        self.height += contentHeight-self.mHeightTextView;
        
        self.mHeightTextView = contentHeight ;//重新设置自己的高度
        
        //        self.y-=size.height-self.mInputTextView.height;
        self.mInputTextView.height = size.height;
//        if ([self.delegate respondsToSelector:@selector(changeHightWithInputBar:)]) {
//            [self.delegate changeHightWithInputBar:self.y];
//        }
        
        
    }
}
//判断用户是否点击了键盘发送按钮
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    self.sendBtn.enabled = YES;
    if ([text isEqualToString:@"\n"])
    {//点击了发送按钮
        
        if (![textView.text isEqualToString:@""])
        {//输入框当前有数据才需要发送
            
            //    [self routerEventWithType:EventChatCellTypeSendMsgEvent userInfo:@{@"type":@(WSChatCellType_Text),@"text":textView.text}];
            NSLog(@"发送回复:%@",textView.text);
            [self sendBtnClick];
            textView.text = @"";//清空输入框
            [self textViewDidChange:textView];
         //   [self.mInputTextView resignFirstResponder];
        }
        return NO;
    }
    
    return YES;
}
-(void)setAnsModel:(UsrAnswerModel *)ansModel
{
    _ansModel = ansModel;
    if (ansModel.toWhoStr != nil) {
        self.mInputTextView.text = [NSString stringWithFormat:@"回复%@:",ansModel.toWhoStr];
    }
//    }else
//        self.mInputTextView.text = @"回复评论";
    
    [self.mInputTextView becomeFirstResponder];
}

@end
