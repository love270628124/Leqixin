//
//  ContactTableViewCell.h
//  乐企信
//
//  Created by 震霄 张 on 16/6/1.
//  Copyright © 2016年 SDW. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShowContactModel.h"
@interface ContactTableViewCell : UITableViewCell
+(id)cellWithTableView:(UITableView *)tableView indexpath:(NSIndexPath *)indexPath;
@property (nonatomic,strong)ShowContactModel *model;
@end
