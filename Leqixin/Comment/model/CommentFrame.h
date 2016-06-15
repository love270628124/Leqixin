//
//  CommentFrame.h
//  乐企信
//
//  Created by 震霄 张 on 16/4/1.
//  Copyright © 2016年 SDW. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommentModel.h"
@interface CommentFrame : NSObject

@property (nonatomic,strong)CommentModel *model;

@property (nonatomic,assign)CGRect iconViewFrame;
@property (nonatomic,assign)CGRect nameLabelFrame;
//@property (nonatomic,assign)CGRect locationLabelFrame;
@property (nonatomic,assign)CGRect statusViewFrame;
@property (nonatomic,assign)CGRect commentLabelFrame;
//@property (nonatomic,assign)CGRect bodyLabelFrame;
@property (nonatomic,assign)CGRect timeLabelFrame;
@property (nonatomic,assign)CGRect passBtnFrame;
@property (nonatomic,assign)CGRect trashBtnFrame;
@property (nonatomic,assign)CGRect deleteBtnFrame;
//@property (nonatomic,assign)CGRect replyLabelFrame;

@property (nonatomic,assign)CGRect lineViewFrame;
@property (nonatomic,assign)CGFloat cellHeight;

@end
