//
//  CmInputBar.h
//  乐企信
//
//  Created by 震霄 张 on 16/4/5.
//  Copyright © 2016年 SDW. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UsrAnswerModel.h"
@protocol CommentInputBarDelegate <NSObject>

-(void)changeHightWithInputBar:(CGFloat)inputBarY;
-(void)sendComment:(NSString *)replyStr;

@end
@interface CmInputBar : UIView
@property (nonatomic,strong)id<CommentInputBarDelegate>delegate;
@property (nonatomic,assign)BOOL isOut;
@property (nonatomic,strong)UsrAnswerModel *ansModel;

@end
