//
//  UsrAnswerFrame.h
//  乐企信
//
//  Created by 震霄 张 on 16/4/5.
//  Copyright © 2016年 SDW. All rights reserved.
//

#import <Foundation/Foundation.h>
@class UsrAnswerModel;
@interface UsrAnswerFrame : NSObject
@property (nonatomic,strong)UsrAnswerModel *model;
@property (nonatomic,assign)CGRect iconViewFrame;
@property (nonatomic,assign)CGRect nameLabelFrame;
@property (nonatomic,assign)CGRect locationLabelFrame;
@property (nonatomic,assign)CGRect commentLabelFrame;
@property (nonatomic,assign)CGRect timeLabelFrame;

@property (nonatomic,assign)CGFloat ansCellHeight;
@end
