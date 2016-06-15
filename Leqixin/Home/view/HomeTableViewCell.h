//
//  homeTableViewCell.h
//  乐企信
//
//  Created by 震霄 张 on 16/3/16.
//  Copyright © 2016年 SDW. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeTableViewCell : UITableViewCell
+(id)cellWithTableView:(UITableView *)tableView indexpath:(NSIndexPath *)indexPath;

@property (nonatomic,strong)NSString *iconNameStr;
@property (nonatomic,strong)NSString *remindInfoStr;
@property (nonatomic,strong)NSString *remindNumStr;
@end
