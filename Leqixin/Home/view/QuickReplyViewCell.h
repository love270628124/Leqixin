//
//  QuickReplyViewCell.h
//  乐企信
//
//  Created by 震霄 张 on 16/3/24.
//  Copyright © 2016年 SDW. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface QuickReplyViewCell : UITableViewCell
+(id)cellWithTableView:(UITableView *)tableView indexpath:(NSIndexPath *)indexPath;
@property (nonatomic,strong)NSString *showInfo;

@end
