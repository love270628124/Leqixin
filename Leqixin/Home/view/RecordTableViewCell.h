//
//  RecordTableViewCell.h
//  乐企信
//
//  Created by 震霄 张 on 16/3/25.
//  Copyright © 2016年 SDW. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecordTableViewCell : UITableViewCell

@property (nonatomic,weak)UILabel *timeLabel;
@property (nonatomic,weak)UILabel *statusLabel;//描述
+(id)cellWithTableView:(UITableView *)tableView indexpath:(NSIndexPath *)indexPath;

@end
