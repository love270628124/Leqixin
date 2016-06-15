//
//  WSChatMessageInputBar.m
//  QQ
//
//  Created by weida on 15/9/23.
//  Copyright (c) 2015年 weida. All rights reserved.
//  https://github.com/weida-studio/QQ

#import "WSChatMessageInputBar.h"
#import "QuickReplyViewCell.h"
#import "EditReplyViewController.h"

//背景颜色
#define kBkColor               ([UIColor colorWithRed:0.922 green:0.925 blue:0.929 alpha:1])

//输入框最小高度
#define kMinHeightTextView          (34)

//输入框最大高度
#define kMaxHeightTextView   (70)

//默认输入框和父控件底部间隔
#define kDefaultBottomTextView_SupView  (5)

#define kDefaultTopTextView_SupView  (5)

//按钮大小
#define kSizeBtn                 (CGSizeMake(34, 34))


#define moreViewHeight 100
#define moreViewBtnHeight 90

#define quickReplyViewHeight 160


@interface WSChatMessageInputBar ()<UITextViewDelegate,UITableViewDataSource,UITableViewDelegate>

/**
 *  @brief  输入TextView
 */
@property(nonatomic,strong)UITextView *mInputTextView;
@property (nonatomic,weak)UIView *moreView;
@property (nonatomic,assign)CGFloat mHeightTextView;//TextView的高度
@property (nonatomic,weak)UIView *quickReplyView;
@property (nonatomic,strong)NSArray *dataArr;

/**
 *  @brief  快捷回复按钮
 */
@property(nonatomic,strong)UIButton   *mQuickReplyBtn;

/**
 *  @brief  表情按钮
 */
@property(nonatomic,strong)UIButton   *mFaceBtn;

/**
 *  @brief  更多按钮
 */
@property(nonatomic,strong)UIButton   *mMoreBtn;

@end

@implementation WSChatMessageInputBar

#pragma mark - Override System Method

-(NSArray *)dataArr
{
    if (_dataArr == nil) {
        _dataArr = @[@"请问有什么可以帮到您",@"货真价实不还价哦",@"请联系曹经理",@"编辑快速回复"];
    }
    return _dataArr;
}

-(instancetype)init
{
    self = [super init];
    if (self)
    {
        self.backgroundColor = kBkColor;
        self.mHeightTextView = kMinHeightTextView; //默认设置输入框最小高度
        
        
        self.mQuickReplyBtn.x = 10 * SCREEN_SCALE_W;
        self.mQuickReplyBtn.y = 5*SCREEN_SCALE_H;
        self.mQuickReplyBtn.size = kSizeBtn;
        [self addSubview:self.mQuickReplyBtn];
        
        self.mInputTextView.x = CGRectGetMaxX(self.mQuickReplyBtn.frame)+10*SCREEN_SCALE_W;
        self.mInputTextView.y = 5*SCREEN_SCALE_H;
        self.mInputTextView.width = [UIScreen mainScreen].bounds.size.width - 4 * kSizeBtn.width;
        self.mInputTextView.height = self.mHeightTextView;
        
        
        [self addSubview:self.mInputTextView];
        
        self.mFaceBtn.x = CGRectGetMaxX(self.mInputTextView.frame);
        self.mFaceBtn.y = self.mInputTextView.y;
        self.mFaceBtn.size =kSizeBtn;
        [self addSubview:self.mFaceBtn];
        
        self.mMoreBtn.x = CGRectGetMaxX(self.mFaceBtn.frame);
        self.mMoreBtn.y = self.mInputTextView.y;
        self.mMoreBtn.size = kSizeBtn;
        [self addSubview:self.mMoreBtn];

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

        if ([self.delegate respondsToSelector:@selector(changeHightWithInputBar:)]) {
            
            [self.delegate changeHightWithInputBar:self.y];
        }
    }else
    {
        self.y += keyboardEndFrame.size.height;
        
        if ([self.delegate respondsToSelector:@selector(changeHightWithInputBar:)]) {
            
            [self.delegate changeHightWithInputBar:self.y];
        }
    }
    
    [self.superview layoutIfNeeded];
    [UIView commitAnimations];
}

#pragma mark - 点击事件处理

-(void)quickReplyBtnClick:(UIButton *)sender
{
    
    if (self.moreView) {
        [self moreBtnClick:self.mMoreBtn];
    }
    
    if (sender.selected) {
        [self.quickReplyView removeFromSuperview];
        self.quickReplyView = nil;
        self.y+=quickReplyViewHeight;
        if ([self.delegate respondsToSelector:@selector(changeHightWithInputBar:)]) {
            [self.delegate changeHightWithInputBar:self.y];
        }
        
    }else{
        
        self.height += quickReplyViewHeight;
        self.y-=quickReplyViewHeight;
        UIView *quickView = [[UIView alloc]init];
        quickView.backgroundColor = [UIColor blueColor];
        quickView.width = SCREEN_W;
        quickView.height = quickReplyViewHeight;
        quickView.x= 0;
        quickView.y= CGRectGetMaxY(self.mInputTextView.frame);
        [self addSubview:quickView];
        self.quickReplyView = quickView;
        [self.mInputTextView resignFirstResponder];
        
        UITableView *quickReplytableView = [[UITableView alloc]initWithFrame:quickView.bounds];
        [quickReplytableView registerClass:[QuickReplyViewCell class] forCellReuseIdentifier:@"replyCell"];
        quickReplytableView.dataSource = self;
        quickReplytableView.delegate  =self;
        [quickView addSubview:quickReplytableView];
        
        if ([self.delegate respondsToSelector:@selector(changeHightWithInputBar:)]) {
            [self.delegate changeHightWithInputBar:self.y];
        }

    }
    
    sender.selected = ! sender.selected;

}


-(void)faceBtnClick:(UIButton*)sender
{
    
    
//    if (mMoreView)
//    {//如果当前还在显示更多视图，则隐藏他先
//        [self moreBtnClick:self.mMoreBtn];
//    }
//    
//    if (sender.selected)
//    {
//        [mFaceView removeFromSuperview];
//        mFaceView = nil;
//        
//        mBottomConstraintTextView.constant = -kDefaultBottomTextView_SupView;
//        
//        [self.mInputTextView becomeFirstResponder];
//    }else
//    {
//        mFaceView = [[WSChatMessageEmojiView alloc]init];
//        mFaceView.translatesAutoresizingMaskIntoConstraints = NO;
//        
//        [self addSubview:mFaceView];
//        
//        
//        [mFaceView autoPinEdgeToSuperviewEdge:ALEdgeLeading];
//        [mFaceView autoPinEdgeToSuperviewEdge:ALEdgeTrailing];
//        [mFaceView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.mInputTextView withOffset:6];
//        
//        mBottomConstraintTextView.constant = -(kDefaultBottomTextView_SupView+[mFaceView intrinsicContentSize].height);
//
//        
//        [self.mInputTextView resignFirstResponder];
//    }
//
//    [self invalidateIntrinsicContentSize];
//    
//    sender.selected = !sender.selected;
}


-(void)moreBtnClick:(UIButton*)sender
{
    if (self.quickReplyView) {
        [self quickReplyBtnClick:self.mQuickReplyBtn];
    }
    
    
    if (sender.selected) {
        [self.moreView removeFromSuperview];
        self.moreView = nil;
        
        self.y+=moreViewHeight;

        if ([self.delegate respondsToSelector:@selector(changeHightWithInputBar:)]) {
            [self.delegate changeHightWithInputBar:self.y];
        }
    }else{
        
        self.height += moreViewHeight;
        self.y-=moreViewHeight;
        UIView *moreView = [[UIView alloc]init];
       // moreView.backgroundColor = [UIColor blueColor];
        moreView.width = SCREEN_W;
        moreView.height = moreViewHeight;
        moreView.x= 0;
        moreView.y= CGRectGetMaxY(self.mInputTextView.frame);
        [self addSubview:moreView];
    
        self.moreView = moreView;
        
        [self.mInputTextView resignFirstResponder];

        CGFloat padW = (SCREEN_W - 3 * moreViewBtnHeight)/4;
        CGFloat padH = (moreViewHeight-moreViewBtnHeight)/2;

        UIButton *picBtn = [[UIButton alloc]init];
        [picBtn setImage:[UIImage imageNamed:@"icon_pic"] forState:UIControlStateNormal];
        picBtn.width = moreViewBtnHeight;
        picBtn.height = moreViewBtnHeight;
        picBtn.x = padW;
        picBtn.y = padH;
        [moreView addSubview:picBtn];
        
        UIButton *cameraBtn = [[UIButton alloc]init];
        [cameraBtn setImage:[UIImage imageNamed:@"icon_camera"] forState:UIControlStateNormal];
        cameraBtn.width = moreViewBtnHeight;
        cameraBtn.height = moreViewBtnHeight;
        cameraBtn.x = padW+padW+moreViewBtnHeight;
        cameraBtn.y = padH;
        [moreView addSubview:cameraBtn];
        
        UIButton *replyBtn = [[UIButton alloc]init];
        [replyBtn setImage:[UIImage imageNamed:@"icon_reply"] forState:UIControlStateNormal];
        replyBtn.width = moreViewBtnHeight;
        replyBtn.height = moreViewBtnHeight;
        replyBtn.x = padW+(padW + moreViewBtnHeight)*2;
        replyBtn.y = padH;
        [moreView addSubview:replyBtn];
        
        if ([self.delegate respondsToSelector:@selector(changeHightWithInputBar:)]) {
            [self.delegate changeHightWithInputBar:self.y];
        }
    }
    
    sender.selected = ! sender.selected;

}


#pragma mark - Getter Method

-(UIButton *)mMoreBtn
{
    if (_mMoreBtn) {
        return _mMoreBtn;
    }
    
    _mMoreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_mMoreBtn addTarget:self action:@selector(moreBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    _mMoreBtn.backgroundColor = [UIColor clearColor];
    [_mMoreBtn setImage:[UIImage imageNamed:@"icon_add"] forState:UIControlStateNormal];
    return _mMoreBtn;
}
-(UIButton *)mQuickReplyBtn
{
    if (_mQuickReplyBtn) {
        return _mQuickReplyBtn;
    }
    _mQuickReplyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_mQuickReplyBtn addTarget:self action:@selector(quickReplyBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    _mQuickReplyBtn.backgroundColor = [UIColor clearColor];
    [_mQuickReplyBtn setImage:[UIImage imageNamed:@"icon_reply-1"] forState:UIControlStateNormal];
    return _mQuickReplyBtn;
}

-(UIButton *)mFaceBtn
{
    if (_mFaceBtn) {
        return _mFaceBtn;
    }
    
    _mFaceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    _mFaceBtn.translatesAutoresizingMaskIntoConstraints = NO;
    [_mFaceBtn addTarget:self action:@selector(faceBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    _mFaceBtn.backgroundColor = [UIColor clearColor];
    [_mFaceBtn setImage:[UIImage imageNamed:@"icon_smile"] forState:UIControlStateNormal];
//    [_mFaceBtn setImage:[UIImage imageNamed:@"chat_bottom_smile_press@3x"] forState:UIControlStateHighlighted];
//    [_mFaceBtn  setImage:[UIImage imageNamed:@"chat_bottom_keyboard_nor@3x"] forState:UIControlStateSelected];
//    [_mFaceBtn autoSetDimensionsToSize:kSizeBtn];
    
    
    return _mFaceBtn;
}


-(UITextView *)mInputTextView
{
    if (_mInputTextView) {
        return _mInputTextView;
    }
    
//    _mInputTextView = [[UITextView alloc]initForAutoLayout];
    _mInputTextView = [[UITextView alloc]init];
    
    _mInputTextView.delegate = self;
    _mInputTextView.layer.cornerRadius = 4;
    _mInputTextView.layer.masksToBounds = YES;
    _mInputTextView.layer.borderWidth = 1;
    _mInputTextView.layer.borderColor = [[[UIColor lightGrayColor] colorWithAlphaComponent:0.4] CGColor];
//    _mInputTextView.scrollIndicatorInsets = UIEdgeInsetsMake(10.0f, 0.0f, 10.0f, 4.0f);
//    _mInputTextView.contentInset = UIEdgeInsetsZero;
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
    
    return _mInputTextView;
}

#pragma mark -TextView Delegate

//输入框获取输入焦点后，隐藏其他视图
-(void)textViewDidBeginEditing:(UITextView *)textView
{

    if (self.moreView) {
        [self moreBtnClick:self.mMoreBtn];
        
    }
    if (self.quickReplyView) {
        [self quickReplyBtnClick:self.mQuickReplyBtn];
    }
}

//判断用户是否点击了键盘发送按钮
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"])
    {//点击了发送按钮
       
        if (![textView.text isEqualToString:@""])
        {//输入框当前有数据才需要发送
           
        //    [self routerEventWithType:EventChatCellTypeSendMsgEvent userInfo:@{@"type":@(WSChatCellType_Text),@"text":textView.text}];
            
            textView.text = @"";//清空输入框
            [self textViewDidChange:textView];
        }
        return NO;
    }
    
    return YES;
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
        if ([self.delegate respondsToSelector:@selector(changeHightWithInputBar:)]) {
            [self.delegate changeHightWithInputBar:self.y];
        }
        
        
    }
}
#pragma mark replyTableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
}
-(QuickReplyViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    QuickReplyViewCell *cell = [QuickReplyViewCell cellWithTableView:tableView indexpath:indexPath];
//    if (indexPath.row == [self.dataArr count]-1) {
//        cell.textLabel.textColor = [UIColor orangeColor];
//    }
    cell.showInfo = self.dataArr[indexPath.row];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return quickReplyViewHeight/4;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == self.dataArr.count - 1) {
        if ([self.delegate respondsToSelector:@selector(jump2ViewController:)]) {
            [self.delegate jump2ViewController:[[EditReplyViewController alloc]init]];
        }
        
    }else{
        self.mInputTextView.text = self.dataArr[indexPath.row];
    }
    
}


@end
