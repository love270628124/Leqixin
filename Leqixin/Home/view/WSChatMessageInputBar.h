//
//  WSChatMessageInputBar.h
//  QQ
//
//  Created by weida on 15/9/23.
//  Copyright (c) 2015年 weida. All rights reserved.
//  https://github.com/weida-studio/QQ

#import <UIKit/UIKit.h>


/**
 *  @brief  聊天界面底部输入界面
 */
@protocol WSChatMessageInputBarDelegate <NSObject>

-(void)changeHightWithInputBar:(CGFloat)inputBarY;
-(void)jump2ViewController:(UIViewController *)controller;
@end

@interface WSChatMessageInputBar : UIView
@property (nonatomic,strong)id<WSChatMessageInputBarDelegate>delegate;

@end
