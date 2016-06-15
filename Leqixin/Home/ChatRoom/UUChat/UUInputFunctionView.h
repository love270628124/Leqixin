//
//  UUInputFunctionView.h
//  UUChatDemoForTextVoicePicture
//
//  Created by shake on 14-8-27.
//  Copyright (c) 2014年 uyiuyao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UUInputFunctionView;

@protocol UUInputFunctionViewDelegate <NSObject>

@optional
// text
- (void)UUInputFunctionView:(UUInputFunctionView *)funcView sendMessage:(NSString *)message;

// image
- (void)UUInputFunctionView:(UUInputFunctionView *)funcView sendPicture:(UIImage *)image;

// audio
- (void)UUInputFunctionView:(UUInputFunctionView *)funcView sendVoice:(NSData *)voice time:(NSInteger)second;

//改变聊天tableview的高度
-(void)changeHightWithInputBar:(CGFloat)inputBarY;
//跳转到快捷回复编辑界面
-(void)jump2ViewController:(UIViewController *)controller;
//
-(void)quickReplyViewShow:(CGFloat)quickReplyViewHeight;

@end

@interface UUInputFunctionView : UIView <UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic, retain) UIButton *btnSendMessage;
@property (nonatomic, retain) UIButton *btnChangeVoiceState;
@property (nonatomic, retain) UIButton *btnVoiceRecord;
@property (nonatomic, retain) UITextView *TextViewInput;

@property (nonatomic, assign) BOOL isAbleToSendTextMessage;

@property (nonatomic, assign) UIViewController *superVC;

@property (nonatomic, assign) id<UUInputFunctionViewDelegate>delegate;

- (id)initWithSuperVC:(UIViewController *)superVC;

-(void)refreshData;
//- (void)changeSendBtnWithPhoto:(BOOL)isPhoto;

@end
