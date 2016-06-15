//
//  ConsultTableViewCell.h
//  乐企信
//
//  Created by 震霄 张 on 16/3/21.
//  Copyright © 2016年 SDW. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VistorModel.h"
@interface ConsultTableViewCell : UITableViewCell
@property (nonatomic,strong)VistorModel *vistorModel;

+(id)cellWithTableView:(UITableView *)tableView indexpath:(NSIndexPath *)indexPath;

@end
