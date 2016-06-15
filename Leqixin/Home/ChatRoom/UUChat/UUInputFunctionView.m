//
//  UUInputFunctionView.m
//  UUChatDemoForTextVoicePicture
//
//  Created by shake on 14-8-27.
//  Copyright (c) 2014年 uyiuyao. All rights reserved.
//

#import "UUInputFunctionView.h"
//#import "Mp3Recorder.h"
#import "UUProgressHUD.h"
#import "QuickReplyViewCell.h"
#import "EditReplyViewController.h"

#define kMinHeightTextView    (35.5)

#define kMaxHeightTextView   (70)

#define quickReplyViewHeight 160


@interface UUInputFunctionView ()<UITextViewDelegate,UITableViewDelegate,UITableViewDataSource>
{
    BOOL isbeginVoiceRecord;
//    Mp3Recorder *MP3;
    NSInteger playTime;
    NSTimer *playTimer;
    
    UILabel *placeHold;
    
}
@property (nonatomic,weak)UIView *quickReplyView;
@property (nonatomic,strong)NSMutableArray *dataArr;
@property (nonatomic,assign)CGFloat mHeightTextView;
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,assign)BOOL isNeedRefresh;
@end

@implementation UUInputFunctionView
-(NSMutableArray *)dataArr
{
    if (self.isNeedRefresh == NO) {
        if (_dataArr == nil) {
            _dataArr = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults]valueForKey:@"quickReply"]];
        }
    }else{
        _dataArr =[NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults]valueForKey:@"quickReply"]];
        self.isNeedRefresh = NO;
    }
    return _dataArr;
}


- (id)initWithSuperVC:(UIViewController *)superVC
{
    self.mHeightTextView = kMinHeightTextView; //默认设置输入框最小高度

    self.superVC = superVC;
    CGRect frame = CGRectMake(0, Main_Screen_Height-45.5-64, Main_Screen_Width, 45.5);
    
    self = [super initWithFrame:frame];
    if (self) {
//        MP3 = [[Mp3Recorder alloc]initWithDelegate:self];
        self.backgroundColor = [UIColor whiteColor];
        //发送消息
        self.btnSendMessage = [UIButton buttonWithType:UIButtonTypeCustom];
        self.btnSendMessage.frame = CGRectMake(Main_Screen_Width-60, 5, 50, 35.5);
        self.isAbleToSendTextMessage = YES;
        [self.btnSendMessage setTitle:@"发送" forState:UIControlStateNormal];
        [self.btnSendMessage setBackgroundImage:[UIImage imageNamed:@"chat_send_message"] forState:UIControlStateNormal];
        self.btnSendMessage.titleLabel.font = [UIFont systemFontOfSize:12];
        [self.btnSendMessage addTarget:self action:@selector(sendMessage:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.btnSendMessage];
        
        //改变状态（语音、文字）
        self.btnChangeVoiceState = [UIButton buttonWithType:UIButtonTypeCustom];
        self.btnChangeVoiceState.frame = CGRectMake(5, 5, 30, 30);
        isbeginVoiceRecord = NO;
        [self.btnChangeVoiceState setBackgroundImage:[UIImage imageNamed:@"icon_voice"] forState:UIControlStateNormal];
        self.btnChangeVoiceState.titleLabel.font = [UIFont systemFontOfSize:12];
        [self.btnChangeVoiceState addTarget:self action:@selector(voiceRecord:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.btnChangeVoiceState];

        //语音录入键
        self.btnVoiceRecord = [UIButton buttonWithType:UIButtonTypeCustom];
        self.btnVoiceRecord.frame = CGRectMake(70, 5, Main_Screen_Width-70*2, 30);
        self.btnVoiceRecord.hidden = YES;
        [self.btnVoiceRecord setBackgroundImage:[UIImage imageNamed:@"chat_message_back"] forState:UIControlStateNormal];
        [self.btnVoiceRecord setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [self.btnVoiceRecord setTitleColor:[[UIColor lightGrayColor] colorWithAlphaComponent:0.5] forState:UIControlStateHighlighted];
        [self.btnVoiceRecord setTitle:@"Hold to Talk" forState:UIControlStateNormal];
        [self.btnVoiceRecord setTitle:@"Release to Send" forState:UIControlStateHighlighted];
        [self.btnVoiceRecord addTarget:self action:@selector(beginRecordVoice:) forControlEvents:UIControlEventTouchDown];
        [self.btnVoiceRecord addTarget:self action:@selector(endRecordVoice:) forControlEvents:UIControlEventTouchUpInside];
        [self.btnVoiceRecord addTarget:self action:@selector(cancelRecordVoice:) forControlEvents:UIControlEventTouchUpOutside | UIControlEventTouchCancel];
        [self.btnVoiceRecord addTarget:self action:@selector(RemindDragExit:) forControlEvents:UIControlEventTouchDragExit];
        [self.btnVoiceRecord addTarget:self action:@selector(RemindDragEnter:) forControlEvents:UIControlEventTouchDragEnter];
//        [self addSubview:self.btnVoiceRecord];
        
        //输入框
        self.TextViewInput = [[UITextView alloc]initWithFrame:CGRectMake(45, 5, Main_Screen_Width-2*45-20, 35.5)];
        self.TextViewInput.layer.cornerRadius = 4;
        self.TextViewInput.layer.masksToBounds = YES;
        self.TextViewInput.delegate = self;
        self.TextViewInput.layer.borderWidth = 1;
        self.TextViewInput.font = [UIFont systemFontOfSize:16];
        self.TextViewInput.layer.borderColor = [[[UIColor lightGrayColor] colorWithAlphaComponent:0.4] CGColor];
        [self addSubview:self.TextViewInput];
        
        //输入框的提示语
        placeHold = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 200, 30)];
        placeHold.text = @"请输入";
        placeHold.textColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.8];
        [self.TextViewInput addSubview:placeHold];
        
        //分割线
        self.layer.borderWidth = 1;
        self.layer.borderColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.3].CGColor;
        
        //添加通知
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textViewDidEndEditing:) name:UIKeyboardWillHideNotification object:nil];
    }
    return self;
}

#pragma mark - 录音touch事件
- (void)beginRecordVoice:(UIButton *)button
{
//    [MP3 startRecord];
//    playTime = 0;
//    playTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countVoiceTime) userInfo:nil repeats:YES];
//    [UUProgressHUD show];
}

- (void)endRecordVoice:(UIButton *)button
{
//    if (playTimer) {
//        [MP3 stopRecord];
//        [playTimer invalidate];
//        playTimer = nil;
//    }
}

- (void)cancelRecordVoice:(UIButton *)button
{
//    if (playTimer) {
//        [MP3 cancelRecord];
//        [playTimer invalidate];
//        playTimer = nil;
//    }
//    [UUProgressHUD dismissWithError:@"Cancel"];
}

- (void)RemindDragExit:(UIButton *)button
{
    [UUProgressHUD changeSubTitle:@"Release to cancel"];
}

- (void)RemindDragEnter:(UIButton *)button
{
    [UUProgressHUD changeSubTitle:@"Slide up to cancel"];
}


- (void)countVoiceTime
{
    playTime ++;
    if (playTime>=60) {
        [self endRecordVoice:nil];
    }
}

#pragma mark - Mp3RecorderDelegate

//回调录音资料
- (void)endConvertWithData:(NSData *)voiceData
{
    [self.delegate UUInputFunctionView:self sendVoice:voiceData time:playTime+1];
    [UUProgressHUD dismissWithSuccess:@"Success"];
   
    //缓冲消失时间 (最好有block回调消失完成)
    self.btnVoiceRecord.enabled = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.btnVoiceRecord.enabled = YES;
    });
}

- (void)failRecord
{
    [UUProgressHUD dismissWithSuccess:@"Too short"];
    
    //缓冲消失时间 (最好有block回调消失完成)
    self.btnVoiceRecord.enabled = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.btnVoiceRecord.enabled = YES;
    });
}

//改变输入与录音状态
- (void)voiceRecord:(UIButton *)sender
{
    self.btnVoiceRecord.hidden = !self.btnVoiceRecord.hidden;
//    self.TextViewInput.hidden  = !self.TextViewInput.hidden;
    isbeginVoiceRecord = !isbeginVoiceRecord;
    if (isbeginVoiceRecord) {
        [self.btnChangeVoiceState setBackgroundImage:[UIImage imageNamed:@"chat_ipunt_message"] forState:UIControlStateNormal];
        [self.TextViewInput resignFirstResponder];
        [self setupQuickReplyView];

        if ([self.delegate respondsToSelector:@selector(quickReplyViewShow:)]) {
            [self.delegate quickReplyViewShow:quickReplyViewHeight];
        }
        
//        self.TextViewInput.editable = NO;
    }else{
//        self.TextViewInput.editable = YES;
        [self.btnChangeVoiceState setBackgroundImage:[UIImage imageNamed:@"icon_voice"] forState:UIControlStateNormal];
        
        self.y += quickReplyViewHeight;
        self.height -= quickReplyViewHeight;
        
        if ([self.delegate respondsToSelector:@selector(changeHightWithInputBar:)]) {
            [self.delegate changeHightWithInputBar:self.y];
        }
        
//        [self.TextViewInput becomeFirstResponder];
        [self.quickReplyView removeFromSuperview];
    }
}

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if (self.quickReplyView) {
        [self voiceRecord:nil];
    }
    return  YES;
}
-(void)setupQuickReplyView
{
    
    self.height += quickReplyViewHeight;
    self.y-=quickReplyViewHeight;
    NSLog(@"self.y = %f",self.y);
    UIView *quickView = [[UIView alloc]init];
    quickView.backgroundColor = [UIColor blueColor];
    quickView.width = SCREEN_W;
    quickView.height = quickReplyViewHeight;
    quickView.x= 0;
    quickView.y= CGRectGetMaxY(self.TextViewInput.frame);
    [self addSubview:quickView];
    self.quickReplyView = quickView;
    
    UITableView *quickReplytableView = [[UITableView alloc]initWithFrame:quickView.bounds];
    [quickReplytableView registerClass:[QuickReplyViewCell class] forCellReuseIdentifier:@"replyCell"];
    quickReplytableView.dataSource = self;
    quickReplytableView.delegate  =self;
    self.tableView = quickReplytableView;
    [quickView addSubview:quickReplytableView];
    
}
//发送消息（文字图片）
- (void)sendMessage:(UIButton *)sender
{
    if (self.isAbleToSendTextMessage && self.TextViewInput.text.length>0) {
        
        NSString *resultStr = [self.TextViewInput.text stringByReplacingOccurrencesOfString:@"   " withString:@""];
        [self.delegate UUInputFunctionView:self sendMessage:resultStr];
        
//        self.TextViewInput.height = kMinHeightTextView;
//        
//        self.height = (self.TextViewInput.y-self.y)*2 + kMinHeightTextView;
//        
//        [self layoutIfNeeded];
        [self textViewDidChange:self.TextViewInput];
//        
        if ([self.delegate respondsToSelector:@selector(changeHightWithInputBar:)]) {
            [self.delegate changeHightWithInputBar:self.y];
        }
    }
    else{
        [self.TextViewInput resignFirstResponder];
//        UIActionSheet *actionSheet= [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Camera",@"Images",nil];
//        [actionSheet showInView:self.window];
    }
}


#pragma mark - TextViewDelegate

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    placeHold.hidden = self.TextViewInput.text.length > 0;
}

- (void)textViewDidChange:(UITextView *)textView
{
//    [self changeSendBtnWithPhoto:textView.text.length>0?NO:YES];
    placeHold.hidden = textView.text.length>0;
    
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
        self.TextViewInput.height = size.height;
        if ([self.delegate respondsToSelector:@selector(changeHightWithInputBar:)]) {
            [self.delegate changeHightWithInputBar:self.y];
        }
        
        
    }

    
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    placeHold.hidden = self.TextViewInput.text.length > 0;
}


#pragma mark - Add Picture
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [self addCarema];
    }else if (buttonIndex == 1){
        [self openPicLibrary];
    }
}

-(void)addCarema{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self.superVC presentViewController:picker animated:YES completion:^{}];
    }else{
        //如果没有提示用户
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Tip" message:@"Your device don't have camera" delegate:nil cancelButtonTitle:@"Sure" otherButtonTitles:nil];
        [alert show];
    }
}

-(void)openPicLibrary{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self.superVC presentViewController:picker animated:YES completion:^{
        }];
    }
}


-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    UIImage *editImage = [info objectForKey:UIImagePickerControllerEditedImage];
    [self.superVC dismissViewControllerAnimated:YES completion:^{
        [self.delegate UUInputFunctionView:self sendPicture:editImage];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self.superVC dismissViewControllerAnimated:YES completion:nil];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
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

    placeHold.hidden = YES;
    NSString *currentStr;
    if (self.TextViewInput.text.length==0) {
        currentStr = @"";
    }else{
        currentStr = self.TextViewInput.text;
    }
    
    self.TextViewInput.text = [NSString stringWithFormat:@"%@%@",currentStr,self.dataArr[indexPath.row]];
//    [self changeSendBtnWithPhoto:self.TextViewInput.text.length>0?NO:YES];
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footView = [[UIView alloc]init];
    footView.backgroundColor = [UIColor whiteColor];
    footView.frame = CGRectMake(0, 0, SCREEN_W, 0);
    UIButton *editBtn = [[UIButton alloc]init];
    editBtn.x = 0;
    editBtn.width = SCREEN_W;
    editBtn.height = quickReplyViewHeight/4 * 0.6;
    editBtn.y = quickReplyViewHeight/4 * 0.2;
    [footView addSubview:editBtn];
    [editBtn setTitle:@"编辑快捷回复" forState:UIControlStateNormal];

    [editBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [editBtn addTarget:self action:@selector(editBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    return footView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return quickReplyViewHeight/4;
}
-(void)editBtnClick:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(jump2ViewController:)]) {
        [self.delegate jump2ViewController:[[EditReplyViewController alloc]init]];
    }
}
-(void)refreshData
{
    self.isNeedRefresh = YES;
    if (self.tableView) {
        [self.tableView reloadData];
    }
    
}

@end
