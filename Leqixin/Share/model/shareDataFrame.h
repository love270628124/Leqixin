//
//  shareDataFrame.h
//  乐企信
//
//  Created by 震霄 张 on 16/3/31.
//  Copyright © 2016年 SDW. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "shareDataModel.h"
@interface shareDataFrame : NSObject

@property (nonatomic,strong)shareDataModel *model;
@property (nonatomic,assign)CGRect titleFrame;
@property (nonatomic,assign)CGRect contentFrame;
@property (nonatomic,assign)CGRect shareIconFrame;
@property (nonatomic,assign)CGRect shareLabelFrame;
@property (nonatomic,assign)CGRect shareBtnFrame;
@property (nonatomic,assign)CGRect lineViewFrame;

@property (nonatomic,assign)CGFloat cellHeight;

@end
