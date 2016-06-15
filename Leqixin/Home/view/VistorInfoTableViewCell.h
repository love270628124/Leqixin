//
//  VistorInfoTableViewCell.h
//  乐企信
//
//  Created by 震霄 张 on 16/3/25.
//  Copyright © 2016年 SDW. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VistorInfoTableViewCell : UITableViewCell

@property (nonatomic,weak)UIImageView *iconView;
@property (nonatomic,weak)UILabel *infoLabel;
@property (nonatomic,weak)UILabel *describLabel;//描述

+(id)cellWithTableView:(UITableView *)tableView indexpath:(NSIndexPath *)indexPath;

@end
