//
//  ShareTableViewCell.h
//  乐企信
//
//  Created by 震霄 张 on 16/3/31.
//  Copyright © 2016年 SDW. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "shareDataFrame.h"
#import "shareDataModel.h"
@protocol ShareTableViewCellDelegate <NSObject>

-(void)createShareView:(shareDataModel *)model;

@end

@interface ShareTableViewCell : UITableViewCell

@property (nonatomic,strong)shareDataFrame *shareFrame;
@property (nonatomic,strong)id<ShareTableViewCellDelegate>delegate;

@property (nonatomic,weak)UIView *lineView;
+(id)cellWithTableView:(UITableView *)tableView indexpath:(NSIndexPath *)indexPath;

@end
